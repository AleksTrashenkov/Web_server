package ru.web_server_home;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;

public class Main {
    public static String directory = "F:/cloud";
    //public static String directory = "/Users/trashenkov_aleks/Downloads/";
    public static Multimap<String, String> filesCloud = ArrayListMultimap.create();
    public static Multimap<String, String> structureCloud = ArrayListMultimap.create();

    public static void main(String[] args) {
        if (getStructure(directory).get("Документы").isEmpty()) {
            System.out.println("null");
        } else {
            System.out.println(getStructure(directory).get("Документы").stream().filter(e -> e.startsWith("F:\\cloud\\FILES KATERINA\\Документы")).findFirst().toString().replace("Optional[", "").replace("]", ""));
            System.out.println(getStructure(directory).get("Документы").stream().filter(e -> e.startsWith("F:\\cloud\\FILES KATERINA\\Документы")).findFirst().toString().replace("Optional[", "").replace("]", ""));
        }
    }
    public static Multimap<String, String> getStructure(String directory) {
        scanDirectory(new File(directory), "");
        return structureCloud;
    }
    private static void scanDirectory(File dir, String parentPath) {
        if (dir.isDirectory()) {
            for (File item : dir.listFiles()) {
                if (item.isDirectory()) {
                        structureCloud.put(item.getName(), item.getAbsolutePath());
                        scanDirectory(item, item.getAbsolutePath());
                } else {
                        filesCloud.put(item.getName(), item.getAbsolutePath().replace("\\","/"));
                }
            }
        }
    }
}