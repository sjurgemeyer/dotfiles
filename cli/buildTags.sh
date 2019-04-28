repo_root=`git rev-parse --show-toplevel || pwd`

pushd $repo_root >> /dev/null

echo "Processing $repo_root..."

ctags -R

if [ -e .ctags-projects ]; then
    for project in `cat .ctags-projects`; do
        echo "Processing $HOME/$project..."
        ctags -R -a $HOME/$project
    done
fi
popd >> /dev/null

echo "Done."
