#! /usr/bin/env groovy
System.in.eachLine() { line ->  
    def pathRegex = /([_\/\-a-zA-Z0-9]+\.groovy)/
    def foundPattern = line =~ /.*[^a-zA-Z0-9]([a-zA-Z0-9]+\.groovy)/
    String output = line
    if (foundPattern) {
        String fullPath
        def path = line =~ pathRegex
        if (path) {
            File file = new File(path[0][1])
            if (file.exists()) {
                fullPath = path[0][1]
            }
        }
        if (!fullPath) {
            String fileName = foundPattern[0][1]
            def proc = "find . -name $fileName".execute()
            fullPath = proc.text.replace('\n','')
        } 

        //Make the path more obvious to vim, because VIM errorformat is the worst thing in the world
        def existingPath = (line =~ pathRegex)[0][1]
        def startIndex = line.indexOf(existingPath) + existingPath.size()
        def lineNumberMatch = line.substring(startIndex) =~ /:\s*(\d+)/
        if (lineNumberMatch) {
            String lineNumber = lineNumberMatch[0][1]
            line = line - existingPath
            line = line - lineNumber
            output = "''$fullPath:$lineNumber'' $line"
        }
    }
    println output
}
