package ru.web_server_home;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.event.IIOWriteWarningListener;
import javax.imageio.plugins.jpeg.JPEGImageWriteParam;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Random;

public class Main {
    public static String directory = "D:/cloud";
    //public static String directory = "/Users/trashenkov_aleks/Downloads/";
    public static Multimap<String, String> structureCloud = ArrayListMultimap.create();

    public static void main(String[] args) throws IOException {
/*        String programPath = "C:\\Program Files\\SQLite Expert\\Personal 5\\SQLiteExpertPers64.exe"; // Укажите полный путь к программе

        try {
            // Создаем объект ProcessBuilder с указанным путем к программе
            ProcessBuilder processBuilder = new ProcessBuilder(programPath);

            // Запускаем программу
            Process process = processBuilder.start();
            // Ждем некоторое время (например, 5 секунд)
            Thread.sleep(5000);

            // Завершаем выполнение программы
            process.destroy();

            // Ожидаем завершения выполнения программы (необязательно)
            int exitCode = process.waitFor();

            System.out.println("Программа завершила выполнение с кодом: " + exitCode);
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }*/
    }

/*    public static Multimap<String, String> getStructureFind(String directory, String word) throws IOException {
        scanDirectoryFind(new File(directory), word);
        return structureCloud;
    }
    private static void scanDirectoryFind(File dir, String targetWord) throws IOException {
        if (dir.isDirectory()) {
            for (File item : dir.listFiles()) {
                    String itemName = item.getName();
                    if (itemName.contains(targetWord)) {
                        structureCloud.put(itemName, item.getAbsolutePath().replace("\\", "/"));
                    }
                scanDirectoryFind(item, targetWord);
            }
        }
    }*/
}