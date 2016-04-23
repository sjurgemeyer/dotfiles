#!/usr/bin/env groovy
import java.util.zip.*
List<String> classNames = []
ZipInputStream zip = new ZipInputStream(new FileInputStream(args[0]));
for (ZipEntry entry = zip.getNextEntry(); entry != null; entry = zip.getNextEntry()) {
	if (!entry.isDirectory() && entry.getName().endsWith(".class")) {
		// This ZipEntry represents a class. Now, what class does it represent?
		String className = entry.getName().replace('/', '.'); // including ".class"
		classNames.add(className.substring(0, className.length() - ".class".length()));
	}
}
classNames.sort().each {
	println it
}

