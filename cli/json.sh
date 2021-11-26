# Stolen directly from https://github.com/tednaleid/shared-zshrc/blob/master/zshrc_base#L333-L346
jqpath_cmd='
def path_str: [.[] | if (type == "string") then "." + . else "[" + (. | tostring) + "]" end] | add;

. as $orig |
    paths(scalars) as $paths |
    $paths |
    . as $path |
    $orig |
    [($path | path_str), "\u00a0", (getpath($path) | tostring)] |
    add
'

# pipe json in to use fzf to search through it for jq paths, uses a non-breaking space as an fzf column delimiter
alias jqpath="jq -rc '$jqpath_cmd' | cat <(echo $'PATH\u00a0VALUE') - | column -t -s $'\u00a0' | fzf +s -m --header-lines=1"
