import java.io.IOException;
import java.util.Collections;
import java.util.Enumeration;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
public class JarList {
    public static void main(String args[]) throws IOException {

        if (args.length > 0) {
            JarFile jarFile = new JarFile(args[0]);
            Enumeration<JarEntry> allEntries = jarFile.entries();
            Collections.list(allEntries).stream()
                .map(it -> it.getName().replaceAll("/", "."))
                .filter(it -> !it.startsWith("META"))
                .filter(it -> it.endsWith(".class"))
                .map(it -> it.replaceAll(".class", ""))
                .filter(it -> !it.contains("$"))
                .forEach(it -> System.out.println(it));

            //while (allEntries.hasMoreElements()) {
                //JarEntry entry = (JarEntry) allEntries.nextElement();
                //String name = entry.getName();
                //name = name.replaceAll("/", ".")
                //System.out.println(name);
            //}
        }
    }
}
