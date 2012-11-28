def text = ''
new File('target/test-reports/html/alltests-errors.html').eachLine {
    if (includeLine(it)) {
        text += it.replaceAll('nowrap','')
    }
}
def xml = new XmlSlurper().parseText(text)
printRed  '*'*15 + ' Test Failures' + '*'*15 
def errorBlocks = xml.body.table.tr.grep{ it.@class == 'Error' }
errorBlocks.each { errorBlock ->
    def className = errorBlock.td[0].a.text()
    def testName = errorBlock.td[1].a[1].text()
    def testOutput = errorBlock.td[3].text()
    
    printBlue className + ' - ' + testName
    printOutput(testOutput)
    printRed '*'*40
}

def printOutput(text) {
    text.split('\t').each{
        if (it.contains('Exception')) {
            printYellow it
        } else {
            println it
        }
    }
}

String RED='31'
String GREEN='32'
String YELLOW='33'
String BLUE='34'

def printRed(str) {
    printColor(str, '31')
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

def includeLine(line) {
    def excludedTags = ['link','META','hr']
    for (tag in excludedTags) {
        if (line.startsWith("<$tag")) {
            return false
        }
    }
    return true
}
