import java.io.IOException;
import java.util.Enumeration;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

public class JarList {
    public static void main(String args[]) throws IOException {

        if (args.length > 0) {
            JarFile jarFile = new JarFile(args[0]);
            Enumeration allEntries = jarFile.entries();
            while (allEntries.hasMoreElements()) {
                JarEntry entry = (JarEntry) allEntries.nextElement();
                String name = entry.getName();
                System.out.println(name);
            }
        }
    }
