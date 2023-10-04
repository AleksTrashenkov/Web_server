package ru.web_server_home;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Random;

public class Main {
    public static String directory = "F:/cloud";
    //public static String directory = "/Users/trashenkov_aleks/Downloads/";
    public static Multimap<String, String> structureCloud = ArrayListMultimap.create();

    public static void main(String[] args) {
        String word = "фото";
        System.out.println(getStructure(directory, word));

        /*Random rnd = new Random();
        int number = rnd.nextInt(1000) + 1;
        System.out.println("Random number: " + number);
        if (getStructure(directory).get("Документы").isEmpty()) {
            System.out.println("null");
        } else {
            System.out.println(getStructure(directory).get("Документы").stream().filter(e -> e.startsWith("F:\\cloud\\FILES KATERINA\\Документы")).findFirst().toString().replace("Optional[", "").replace("]", ""));
            System.out.println(getStructure(directory).get("Документы").stream().filter(e -> e.startsWith("F:\\cloud\\FILES KATERINA\\Документы")).findFirst().toString().replace("Optional[", "").replace("]", ""));
        }*/
    }
    public static Multimap<String, String> getStructure(String directory, String targetWord) {
        scanDirectory(new File(directory), targetWord);
        return structureCloud;
    }

    private static void scanDirectory(File dir, String targetWord) {
        if (dir.isDirectory()) {
            for (File item : dir.listFiles()) {
                //if (item.isDirectory()) {
                    String itemName = item.getName();
                    if (itemName.contains(targetWord)) {
                        structureCloud.put(itemName, item.getAbsolutePath().replace("\\", "/"));
                    }
                    scanDirectory(item, targetWord);
                /*} else {
                    String itemName = item.getName();
                    if (itemName.contains(targetWord)) {
                        filesCloud.put(itemName, item.getAbsolutePath().replace("\\", "/"));
                    }
                }*/
            }
        }
    }
}