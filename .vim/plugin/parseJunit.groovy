processFile('alltests-errors.html')
processFile('alltests-fails.html')
 
String filePath() {
    'target/test-reports/html/'
}

def processFile(fileName) {
    if (!new File("${filePath()}$fileName").exists()) return
    def errorDetailMap = createErrorDetailMap(fileName)
    def text = getXmlFromHtml(fileName)
    def xml = new XmlSlurper().parseText(text)
    def errorBlocks = xml.body.table.tr.grep{ it.@class == 'Error' || it.@class == 'Failure'}
    if (errorBlocks) {
        errorBlocks.each { errorBlock ->
            def className = errorBlock.td[0].a.text()
            def testName = errorBlock.td[1].a[1].text()
            def testOutput = errorBlock.td[3].text()
            String outputFile = errorBlock.td[0].a.@href
            outputFile = outputFile[0..-6] + '-out.txt'
            def outputMap = createOutputMap(outputFile)

            printRed  wrapTitle(className + ' - ' + testName)
            printErrorMessage(errorDetailMap[testName])
            printOutput(outputMap[testName])
        }
    }
}
def getXmlFromHtml(fileName) {
    def text = ''
    new File("${filePath()}$fileName").eachLine {
        if (includeLine(it)) {
            text += it.replaceAll('nowrap','')
        }
    }
    text
}

def includeLine(line) {
    def excludedTags = ['link','META','hr']
    for (tag in excludedTags) {
        if (line.startsWith("<$tag")) {
            return false
        }
    }
    return true
}

//Create map with system output and key of test name.  This is stored in a different file, so we need to get it seperately
def createOutputMap(outputFile) {
    def outputMap = [:].withDefault {''}
    def currentKey
    new File("${filePath()}$outputFile").eachLine { line ->
        if (line.startsWith('--Output from')) {
            currentKey = line['--Output from '.size()..-3]
        } else {
            outputMap[currentKey] += "$line\n"
        }
    }
    outputMap
}


//Create a map with the output formatted correctly.  XMLParser will lose formatting
def createErrorDetailMap(fileName) {
    def errorMap = [:]
    def currentKey
    boolean inPre
    new File("${filePath()}$fileName").eachLine { line ->
        if (line.contains("name=")) {
            currentKey = (line =~ /name="([^"]*)"/)[0][1]
        }
        if (line.contains('<pre')) {
            inPre = true
            errorMap[currentKey] = line[line.indexOf('<pre')+5..-1]
        } else if (line.contains('</pre')) {
            inPre = false
        } else if (inPre) {
            errorMap[currentKey] += "$line\n"
        }
    }
    errorMap
}

def printOutput(text) {
    if (text) {
        printBlue wrapTitle('System output')
        text.split(/[\n\t]/).each{
            printBlue it
        }
    }
}

def printErrorMessage(text) {
    text.split(/[\n\t]/).each{
        if (it.contains('Exception') || it.contains('Assertion failed')) {
            printYellow it
        } else if (it.trim()) {
            println it
        }
    }
}

def printRed(str) {
    printColor(str, '31')
}
def printGreen(str) {
    printColor(str, '32')
}
def printBlue(str) {
    printColor(str, '34')
}
def printYellow(str) {
    printColor(str, '33')
}
def printColor(str, color) {
    println  "\033[1;${color}m${str}\033[m"
}


String wrapTitle(str) {
    return '\n' + " $str ".center(120, '-')
}
