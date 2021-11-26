echo '{ "gradle.javaDebug": { "tasks": [' > ./.vscode/settings.json
fd build.gradle | sed s,build.gradle,, | sed s,/$,, | sed s,/,:, | sed 's/\(.*\)/"\1:test",/' >> ./.vscode/settings.json
echo ' ], "clean": true } }' >> ./.vscode/settings.json

