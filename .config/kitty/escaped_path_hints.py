import re


# Nerd Font icons live in Unicode Private Use Areas.
# In multi-column lsd output, each filename is preceded by an icon.
# Pattern: icon followed by a space, then everything up to the next icon
# or end of line is the filename.
ICON_THEN_NAME = re.compile(
    r'[\ue000-\uf8ff\U000f0000-\U000fffff]'      # Nerd Font PUA icon
    r' '                                           # space after icon
    r'(.+?)'                                       # filename
    r'(?=\s*[\ue000-\uf8ff\U000f0000-\U000fffff]'  # lookahead: next icon
    r'|\s*$)',                                      # or end of line
    re.MULTILINE,
)


def _clean(text):
    """Strip null bytes (kitty screen padding), surrounding whitespace,
    and wrapping quotes that lsd adds around names with spaces."""
    text = text.replace('\x00', '').strip()
    if len(text) >= 2 and text[0] == text[-1] and text[0] in ("'", '"'):
        text = text[1:-1]
    return text


def _shell_escape(name):
    """Escape a filename for shell use without the shlex.quote noise.

    If the name is simple, return it as-is.
    Otherwise wrap in double quotes, escaping only the characters that
    are special inside double quotes: \\ \" $ `
    """
    if re.match(r'^[a-zA-Z0-9._/@:,+=-]+$', name):
        return name
    escaped = name.replace('\\', '\\\\')
    escaped = escaped.replace('"', '\\"')
    escaped = escaped.replace('$', '\\$')
    escaped = escaped.replace('`', '\\`')
    return f'"{escaped}"'


LINE_RE = re.compile(r'^(.+)$', re.MULTILINE)
ICON_RE = re.compile(r'[\ue000-\uf8ff\U000f0000-\U000fffff]')


def _overlaps(start, end, ranges):
    """True if [start, end) overlaps any (s, e) range in ranges."""
    for s, e in ranges:
        if start < e and s < end:
            return True
    return False


def mark(text, args, Mark, extra_cli_args, *a):
    candidates = []  # list of (start, end, mark_text)

    # Pass 1: icon-based matches (lsd-style output)
    for match in ICON_THEN_NAME.finditer(text):
        start = match.start(1)
        end = match.end(1)
        mark_text = _clean(match.group(1))
        if mark_text:
            candidates.append((start, end, mark_text))

    # Pass 2: whole-line matches (fd-style output) for lines with no icon.
    for match in LINE_RE.finditer(text):
        raw = match.group(1)
        if ICON_RE.search(raw):
            continue
        mark_text = _clean(raw)
        if mark_text:
            candidates.append((match.start(1), match.end(1), mark_text))

    # Sort by start position, drop any that overlap an earlier kept range.
    candidates.sort(key=lambda c: (c[0], c[1]))
    kept = []
    for start, end, mark_text in candidates:
        if kept and start < kept[-1][1]:
            continue
        kept.append((start, end, mark_text))

    for idx, (start, end, mark_text) in enumerate(kept):
        yield Mark(idx, start, end, mark_text, {})


def handle_result(args, data, target_window_id, boss, extra_cli_args, *a):
    matches = data.get('match')
    if not matches:
        return
    match = matches[0]
    if match:
        w = boss.window_id_map.get(target_window_id)
        if w is not None:
            cleaned = _clean(match)
            w.paste_text(_shell_escape(cleaned))
