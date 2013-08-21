#! /usr/bin/env groovy
System.in.eachLine() { line ->  
    def pathRegex = /([_\/\-a-zA-Z0-9]+\.groovy)/
    def foundPattern = line =~ /.*[^a-zA-Z0-9]([a-zA-Z0-9]+\.groovy)/
    if (foundPattern) {
        def fullPath
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
        def lineNumber = line.substring(startIndex) =~ /:\s*(\d+)/
        if (lineNumber) {
            line = line - existingPath
            line = line - lineNumber[0][1]
            println "''$fullPath:${lineNumber[0][1]}'' $line"
        } else {
            println line
        }
    } else {
        println line
    }

}
