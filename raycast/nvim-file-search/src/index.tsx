import { List, ActionPanel, Action, getPreferenceValues, showToast, Toast, popToRoot } from "@raycast/api";
import { useState, useEffect, useRef } from "react";
import { execFile } from "child_process";
import { promisify } from "util";
import * as fs from "fs";
import * as path from "path";
import * as os from "os";

const execFileAsync = promisify(execFile);

interface Preferences {
  searchRoot: string;
  fdPath: string;
  nvimPath: string;
  kittyPath: string;
}

function expandHome(p: string): string {
  return p.startsWith("~") ? path.join(os.homedir(), p.slice(1)) : p;
}

function findNvimSocket(): string | null {
  const tmpDir = os.tmpdir();
  try {
    const entries = fs.readdirSync(tmpDir);
    for (const entry of entries) {
      if (!entry.startsWith("nvim")) continue;
      const dirPath = path.join(tmpDir, entry);
      try {
        const stat = fs.statSync(dirPath);
        if (stat.isDirectory()) {
          // Neovim auto-creates /tmp/nvim.XXXXX/0
          const socket = path.join(dirPath, "0");
          if (fs.existsSync(socket)) return socket;
        } else if (stat.isSocket()) {
          return dirPath;
        }
      } catch {
        continue;
      }
    }
  } catch {
    // ignore
  }
  return null;
}

async function openInNvim(filePath: string, prefs: Preferences): Promise<void> {
  const nvim = expandHome(prefs.nvimPath);
  const kitty = expandHome(prefs.kittyPath);
  const socket = findNvimSocket();

  if (socket) {
    // Open as a new tab in the running nvim instance
    await execFileAsync(nvim, ["--server", socket, "--remote-tab", filePath]);
    // Focus kitty so the user sees the result
    execFile("osascript", ["-e", 'tell application "kitty" to activate']);
  } else {
    // No running nvim — spawn a new kitty window with nvim
    execFile(kitty, [nvim, filePath], { detached: true });
  }
}

export default function Command() {
  const prefs = getPreferenceValues<Preferences>();
  const [query, setQuery] = useState("");
  const [files, setFiles] = useState<string[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const abortRef = useRef<AbortController | null>(null);

  useEffect(() => {
    if (!query.trim()) {
      setFiles([]);
      setIsLoading(false);
      return;
    }

    abortRef.current?.abort();
    const abort = new AbortController();
    abortRef.current = abort;
    setIsLoading(true);

    const root = expandHome(prefs.searchRoot);
    const fd = expandHome(prefs.fdPath);

    execFileAsync(fd, ["--type", "f", "--max-results", "50", query, root], {
      signal: abort.signal,
    })
      .then(({ stdout }) => {
        if (abort.signal.aborted) return;
        setFiles(stdout.trim().split("\n").filter(Boolean));
        setIsLoading(false);
      })
      .catch((err) => {
        if (abort.signal.aborted || err.name === "AbortError") return;
        setFiles([]);
        setIsLoading(false);
      });

    return () => abort.abort();
  }, [query]);

  return (
    <List
      isLoading={isLoading}
      onSearchTextChange={setQuery}
      searchBarPlaceholder="Search file name..."
      throttle
    >
      {files.map((file) => (
        <List.Item
          key={file}
          title={path.basename(file)}
          subtitle={file.replace(os.homedir(), "~")}
          actions={
            <ActionPanel>
              <Action
                title="Open in Neovim"
                onAction={async () => {
                  try {
                    await openInNvim(file, prefs);
                    await popToRoot();
                  } catch (err) {
                    await showToast({
                      style: Toast.Style.Failure,
                      title: "Failed to open file",
                      message: String(err),
                    });
                  }
                }}
              />
              <Action.CopyToClipboard
                title="Copy Path"
                content={file}
                shortcut={{ modifiers: ["cmd"], key: "c" }}
              />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
