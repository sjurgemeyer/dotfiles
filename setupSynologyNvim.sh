#!/bin/sh
# Install neovim + this repo's nvim config on a Synology NAS (DSM 7, x86_64 or
# aarch64) for use over SSH. Everything lands under $HOME; nothing needs root.
#
#   ./setupSynologyNvim.sh           install / repair
#   ./setupSynologyNvim.sh update    git pull the dotfiles, then sync plugins
#
# ~/.config/nvim is a symlink into the repo, so `update` (or a plain git pull
# followed by :Lazy restore) is all it takes to pick up config changes.
#
# Prerequisites on the NAS:
#   - Control Panel > User & Group > Advanced > "Enable user home service"
#   - git: Package Center "Git Server" package, or Entware `opkg install git git-http`
#   - optional, for treesitter parsers beyond the few bundled with nvim:
#     a C compiler, e.g. Entware `opkg install gcc`
#
# Undo: rm ~/.config/nvim (restore any ~/.config/nvim.backup-* it reports),
#       rm -rf ~/.local/opt/nvim-* ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim,
#       rm ~/.local/bin/{nvim,rg,fd,lazygit,tree-sitter},
#       and delete the marked block from ~/.profile.

set -eu

NVIM_VERSION=v0.12.5
RG_VERSION=14.1.1
FD_VERSION=v10.2.0
LAZYGIT_VERSION=0.44.1
TREE_SITTER_VERSION=v0.25.10

DOTFILES_DIR=${DOTFILES_DIR:-$HOME/projects/dotfiles}
DOTFILES_REPO=${DOTFILES_REPO:-https://github.com/sjurgemeyer/dotfiles.git}
LOCAL=$HOME/.local
BIN=$LOCAL/bin
OPT=$LOCAL/opt

# Parsers installed when a C compiler is available. nvim bundles c, lua,
# markdown, markdown_inline, query, vim and vimdoc already.
TS_PARSERS='"bash","css","csv","diff","dockerfile","git_rebase","gitcommit","go","graphql","groovy","hcl","html","http","java","javascript","json","jsonc","kotlin","make","python","regex","ruby","rust","scss","sql","swift","terraform","toml","tsx","typescript","xml","yaml"'

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarn:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

fetch() { curl -fsSL --retry 2 -o "$2" "$1"; }

# Prefer the binaries this script installs over anything else on PATH.
PATH=$BIN:$PATH
export PATH

detect_arch() {
	case "$(uname -m)" in
	x86_64)
		NVIM_ARCH=x86_64
		RG_TARGET=x86_64-unknown-linux-musl
		FD_TARGET=x86_64-unknown-linux-musl
		LAZYGIT_ARCH=x86_64
		TS_ARCH=x64
		;;
	aarch64 | arm64)
		NVIM_ARCH=arm64
		RG_TARGET=aarch64-unknown-linux-gnu
		FD_TARGET=aarch64-unknown-linux-musl
		LAZYGIT_ARCH=arm64
		TS_ARCH=arm64
		;;
	*) die "unsupported CPU '$(uname -m)': neovim publishes Linux builds for x86_64 and arm64 only" ;;
	esac
}

preflight() {
	[ -d "$HOME" ] && [ -w "$HOME" ] ||
		die "\$HOME ($HOME) is missing or not writable; enable the user home service in DSM"
	for c in curl tar gzip; do have "$c" || die "'$c' not found"; done
	have git || die "git not found: install the 'Git Server' package from Package Center, or Entware 'opkg install git git-http'"
	mkdir -p "$BIN" "$OPT" "$HOME/.config"
}

install_nvim() {
	dest=$OPT/nvim-$NVIM_VERSION
	if [ -x "$dest/bin/nvim" ] && "$dest/bin/nvim" --version >/dev/null 2>&1; then
		say "nvim $NVIM_VERSION already installed"
	else
		say "Installing nvim $NVIM_VERSION ($NVIM_ARCH)"
		tarball=nvim-linux-$NVIM_ARCH.tar.gz
		fetch "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/$tarball" "$TMP/$tarball"
		rm -rf "$dest" && mkdir -p "$dest"
		tar -xzf "$TMP/$tarball" -C "$dest" --strip-components=1
		if ! "$dest/bin/nvim" --version >/dev/null 2>&1; then
			# The official build needs a fairly recent glibc. neovim-releases
			# publishes x86_64 builds against an older one.
			[ "$NVIM_ARCH" = x86_64 ] ||
				die "nvim won't run here (glibc: $(ldd --version 2>&1 | head -1)) and there's no older-glibc arm64 build"
			warn "official build won't run (glibc: $(ldd --version 2>&1 | head -1)); trying neovim-releases build"
			fetch "https://github.com/neovim/neovim-releases/releases/download/$NVIM_VERSION/$tarball" "$TMP/$tarball"
			rm -rf "$dest" && mkdir -p "$dest"
			tar -xzf "$TMP/$tarball" -C "$dest" --strip-components=1
			"$dest/bin/nvim" --version >/dev/null 2>&1 || die "neither nvim build runs on this system"
		fi
	fi
	ln -sfn "$dest/bin/nvim" "$BIN/nvim"
}

# install_tool <name> <url> <path-inside-archive>
install_tool() {
	name=$1 url=$2 member=$3
	if have "$name"; then
		say "$name already on PATH ($(command -v "$name"))"
		return
	fi
	say "Installing $name"
	if ! fetch "$url" "$TMP/$name.tgz"; then
		warn "download failed for $name; skipping"
		return
	fi
	mkdir -p "$TMP/$name" && tar -xzf "$TMP/$name.tgz" -C "$TMP/$name"
	cp "$TMP/$name/$member" "$BIN/$name" && chmod 755 "$BIN/$name"
	"$BIN/$name" --version >/dev/null 2>&1 || {
		warn "$name doesn't run on this system; removed"
		rm -f "$BIN/$name"
	}
}

install_tools() {
	install_tool rg \
		"https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-$RG_TARGET.tar.gz" \
		"ripgrep-$RG_VERSION-$RG_TARGET/rg"
	install_tool fd \
		"https://github.com/sharkdp/fd/releases/download/$FD_VERSION/fd-$FD_VERSION-$FD_TARGET.tar.gz" \
		"fd-$FD_VERSION-$FD_TARGET/fd"
	install_tool lazygit \
		"https://github.com/jesseduffield/lazygit/releases/download/v$LAZYGIT_VERSION/lazygit_${LAZYGIT_VERSION}_Linux_$LAZYGIT_ARCH.tar.gz" \
		lazygit

	# nvim-treesitter (main branch) compiles parsers with the tree-sitter CLI
	# and a C compiler; without a compiler the CLI is useless.
	if have cc || have gcc; then
		if ! have tree-sitter; then
			say "Installing tree-sitter CLI"
			fetch "https://github.com/tree-sitter/tree-sitter/releases/download/$TREE_SITTER_VERSION/tree-sitter-linux-$TS_ARCH.gz" "$TMP/ts.gz"
			gzip -dc "$TMP/ts.gz" >"$BIN/tree-sitter" && chmod 755 "$BIN/tree-sitter"
			"$BIN/tree-sitter" --version >/dev/null 2>&1 || {
				warn "tree-sitter CLI doesn't run on this system; removed"
				rm -f "$BIN/tree-sitter"
			}
		fi
	fi
}

clone_dotfiles() {
	if [ -d "$DOTFILES_DIR/.git" ]; then
		say "dotfiles repo present at $DOTFILES_DIR"
	else
		say "Cloning $DOTFILES_REPO -> $DOTFILES_DIR"
		mkdir -p "$(dirname "$DOTFILES_DIR")"
		git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
	fi
	[ -f "$DOTFILES_DIR/.config/nvim/init.lua" ] || die "$DOTFILES_DIR/.config/nvim/init.lua not found"
}

link_config() {
	target=$DOTFILES_DIR/.config/nvim
	link=$HOME/.config/nvim
	if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
		say "~/.config/nvim already linked"
		return
	fi
	if [ -e "$link" ] || [ -L "$link" ]; then
		backup=$link.backup-$(date +%Y%m%d%H%M%S)
		warn "moving existing ~/.config/nvim to $backup"
		mv "$link" "$backup"
	fi
	ln -s "$target" "$link"
	say "Linked ~/.config/nvim -> $target"
}

update_profile() {
	profile=$HOME/.profile
	marker='# >>> dotfiles: synology nvim >>>'
	if [ -f "$profile" ] && grep -qF "$marker" "$profile"; then
		say "~/.profile already configured"
	else
		say "Adding PATH/EDITOR block to ~/.profile"
		cat >>"$profile" <<EOF

$marker
case ":\$PATH:" in *":\$HOME/.local/bin:"*) ;; *) PATH="\$HOME/.local/bin:\$PATH" ;; esac
export PATH
export EDITOR=nvim VISUAL=nvim
# <<< dotfiles: synology nvim <<<
EOF
	fi
	for f in "$HOME/.bash_profile" "$HOME/.bash_login"; do
		[ -f "$f" ] && warn "$f exists, so bash login shells skip ~/.profile; source ~/.profile from it"
	done
	return 0
}

sync_plugins() {
	say "Installing plugins at the commits in lazy-lock.json"
	"$BIN/nvim" --headless "+Lazy! restore" +qa 2>&1 | tail -n 20

	if have tree-sitter && { have cc || have gcc; }; then
		say "Installing treesitter parsers"
		"$BIN/nvim" --headless "+lua require('nvim-treesitter').install({$TS_PARSERS}):wait(900000)" +qa 2>&1 |
			grep -iE 'error|fail' || true
	else
		warn "no C compiler: skipping treesitter parsers (bundled c/lua/markdown/vim/vimdoc still work; other languages fall back to regex highlighting)"
	fi

	if ! git -C "$DOTFILES_DIR" diff --quiet -- .config/nvim/lazy-lock.json; then
		warn "lazy-lock.json changed in the repo. Review it with: git -C $DOTFILES_DIR diff .config/nvim/lazy-lock.json"
		warn "To keep the NAS on the Mac's plugin versions, discard it: git -C $DOTFILES_DIR checkout -- .config/nvim/lazy-lock.json"
	fi
}

cmd_install() {
	detect_arch
	preflight
	install_nvim
	install_tools
	clone_dotfiles
	link_config
	update_profile
	sync_plugins
	say "Done. Log out and back in (or: . ~/.profile), then run nvim."
}

cmd_update() {
	detect_arch
	preflight
	install_nvim
	say "Pulling $DOTFILES_DIR"
	git -C "$DOTFILES_DIR" pull --ff-only
	sync_plugins
	say "Done."
}

case "${1:-install}" in
install) cmd_install ;;
update) cmd_update ;;
*) die "usage: $0 [install|update]" ;;
esac
