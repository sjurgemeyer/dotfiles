#! /usr/bin/env groovy
System.in.eachLine() { line ->  
    def foundPattern = line =~ /.*[^a-zA-Z0-9]([a-zA-Z0-9]+\.groovy)/
    if (foundPattern) {
        String fileName = foundPattern[0][1]
        def proc = "find . -name $fileName".execute()
        println line.replace(fileName, proc.text).replace('\n','')
    } else {
        println line
    }
}
