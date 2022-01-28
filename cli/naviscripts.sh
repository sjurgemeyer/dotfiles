function navialias() {
    navi --query "[$1]" --best-match
}

navialiases=($( rg -N "^#.*\[.*\]" $HOME/Library/Application\ Support/navi/cheats/shaun.cheat | sed -En 's/.*\[(.*)\]/\1/p'))
for i in "${navialiases[@]}"
do
    alias ${i}="navialias ${i}"
done
