package ru.web_server_home;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;

import javax.imageio.ImageIO;
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
       String programmName = "convert.exe"; // Название программы, которую вы хотите проверить

        try {
            Process process = Runtime.getRuntime().exec(System.getenv("windir") + "\\system32\\" + "tasklist.exe");
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;

            while ((line = reader.readLine()) != null) {
                if (line.contains(programmName)) {
                    System.out.println(programmName + " запущена.");
                    break; // Вы можете удалить эту строку, если хотите проверить наличие нескольких экземпляров
                }
                //System.out.println(line);
            }

            if (line == null) {
                System.out.println(programmName + " не запущена.");
            }

            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        /*String heicPath = "C:\\Users\\server\\OneDrive\\Рабочий стол\\2020-02-04 11.14.40.HEIC"; // Замените путь к вашему HEIC изображению
        String jpegPath = "C:\\Users\\server\\OneDrive\\Рабочий стол\\2020-02-04 11.14.40.jpg"; // Путь для сохранения результата в формате JPEG

        convertHEICtoJPEG(heicPath, jpegPath);*/
       /* getStructureFind(directory, ".heic");
        System.out.println(structureCloud.values());*/
    }

/*        public static Multimap<String, String> getStructureFind(String directory, String word) throws IOException {
            scanDirectoryFind(new File(directory), word);
            return structureCloud;
        }
        private static void scanDirectoryFind(File dir, String targetWord) throws IOException {
            if (dir.isDirectory()) {
                for (File item : dir.listFiles()) {
                        String itemName = item.getName().toLowerCase();
                        if (itemName.contains(targetWord.toLowerCase())) {
                            structureCloud.put(itemName, item.getAbsolutePath().replace("\\", "/"));
                        }
                    scanDirectoryFind(item, targetWord);
                }
            }
        }
    public static void convertHEICtoJPEG(String heicPath, String jpegPath) {
        try {
            ProcessBuilder processBuilder = new ProcessBuilder("C:\\Program Files\\ImageMagick-7.1.1-Q16-HDRI\\convert.exe", heicPath, jpegPath);
            Process process = processBuilder.start();

            int exitCode = process.waitFor();
            if (exitCode == 0) {
                System.out.println("Конвертация завершена успешно.");
            } else {
                System.err.println("Произошла ошибка при конвертации.");
            }
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
        File fileDel = new File(heicPath);
        fileDel.delete();
    }*/
}