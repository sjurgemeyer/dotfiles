# Create aliases directly from navi cheat files.
# Descriptions tagged with [shortcut] will create an alias called shortcut.
# Descriptions tagged with [shortcut] {arg1 arg2} will allow paramers to be passed.  If all are provided the function is directly invoked, otherwise the navi UI will appear
function create_navi_alias() {
    tmp=${@:2}
    count=$(expr $# - 1)
    alias $1="navialias $1 $count $tmp"
}

function navialias() (
    numargs=$2
    for i in {1..$numargs}
    do
        nameindex=$(expr $i + 2)
        valueindex=$(expr $nameindex + $numargs)
        name=${@:$nameindex:1}
        value=${@:$valueindex:1}

        if [[ $valueindex -le $# ]]; then
            eval "export $name=$value"
        fi
    done
    navi --query "[$1]" --best-match
)

function create_navi_aliases() {
    navialiases=($( rg -N "^#.*\[.*\]" "$(navi info cheats-path)/$1" | sed -En 's/.*\[(.*)\].*/\1/p'))
    for i in "${navialiases[@]}"
    do
        navi_func_params=($( rg -N "^#.*\[$i]" "$(navi info cheats-path)/$1" | sed -En 's/.*\{(.*)\}/\1/p'))
        create_navi_alias ${i} ${navi_func_params}
    done
}

create_navi_aliases sjurgemeyer__cheats/shaun.cheat
