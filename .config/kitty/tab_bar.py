from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_tab_with_powerline
from kitty.fast_data_types import Screen

YELLOW = 0xF0E68C  # theme color3
GREEN = 0x7FCF78  # theme color2
RED = 0xFF7979  # theme color1

DIM_FACTOR = 0.4  # how much to darken inactive tabs

ACTIVE_FG = 0x000000  # black text reads well against these light bg colors
INACTIVE_FG = 0xFAF7F0  # theme foreground, reads well against the dimmed bg


def dim(color: int, factor: float = DIM_FACTOR) -> int:
    r = int(((color >> 16) & 0xFF) * factor)
    g = int(((color >> 8) & 0xFF) * factor)
    b = int((color & 0xFF) * factor)
    return (r << 16) | (g << 8) | b


def colorize(tab: TabBarData) -> TabBarData:
    if tab.layout_name == "stack":
        color = YELLOW
    elif tab.layout_name == "splits":
        color = GREEN
    else:
        color = RED

    return tab._replace(
        active_bg=color,
        inactive_bg=dim(color),
        active_fg=ACTIVE_FG,
        inactive_fg=INACTIVE_FG,
    )


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    tab = colorize(tab)
    # draw_tab_with_powerline reads extra_data.next_tab to color the
    # separator, so it needs the same per-layout colors applied or the
    # separator blends toward the wrong (uncolored) next-tab background.
    if extra_data.next_tab is not None:
        extra_data.next_tab = colorize(extra_data.next_tab)

    screen.cursor.bg = as_rgb(draw_data.tab_bg(tab))
    screen.cursor.fg = as_rgb(draw_data.tab_fg(tab))
    return draw_tab_with_powerline(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
