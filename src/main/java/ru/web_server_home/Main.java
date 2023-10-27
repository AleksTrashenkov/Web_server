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

    public static void main(String[] args) throws IOException, InterruptedException {
/*        // Укажите путь к исполняемому файлу FFmpeg
        String ffmpegPath = "C:\\Users\\server\\OneDrive\\Рабочий стол\\ffmpeg-6.0-full_build\\ffmpeg-6.0-full_build\\bin\\ffmpeg.exe";

        // Укажите путь к вашему файлу 3GP и MP4
        String inputVideo = "D:\\cloud\\FILES KATERINA\\Фото\\Видео\\Пусь и груша (3).3gp";
        String outputVideo = "D:\\cloud\\FILES KATERINA\\Фото\\Видео\\Пусь и груша (3)_convert.mp4";

        // Создайте команду для конвертации
        String[] cmd = { ffmpegPath, "-i", inputVideo, "-c:v", "libx264", "-strict", "-2", outputVideo };

        // Запустите процесс FFmpeg
        ProcessBuilder processBuilder = new ProcessBuilder(cmd);
        Process process = processBuilder.start();

        // Дождитесь завершения процесса
        int exitCode = process.waitFor();
        if (exitCode == 0) {
            // Конвертация успешно завершена
            process.destroy();
            System.out.println("Конвертация успешно завершена!");
        } else {
            // Произошла ошибка
            System.out.println("Произошла ошибка во время конвертации.");
        }*/
/*
        try {
            Process process = Runtime.getRuntime().exec("python -");

            // Получите входной и выходной потоки процесса
            InputStream inputStream = process.getInputStream();
            InputStream errorStream = process.getErrorStream();
            OutputStream outputStream = process.getOutputStream();

            // Создайте читатели для потоков
            BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
            BufferedReader errorReader = new BufferedReader(new InputStreamReader(errorStream));

            // Создайте писателя для стандартного ввода
            PrintWriter writer = new PrintWriter(new OutputStreamWriter(outputStream));

            // Сохраните Python код в файл
            String pythonCode =
                    "import g4f\n" +
                            "response = g4f.ChatCompletion.create(\n" +
                            "    model=\"gpt-3.5-turbo\",\n" +
                            "    messages=[{\"role\": \"user\", \"content\": \"Hello\"}],\n" +
                            "    stream=True,\n" +
                            ")\n" +
                            "for message in response:\n" +
                            "    print(message, flush=True, end='')\n";
            writer.println(pythonCode);
            writer.flush();
            writer.close();

            // Прочитайте и выведите вывод Python
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println("Output: " + line);
            }

            // Прочитайте и выведите ошибки Python
            while ((line = errorReader.readLine()) != null) {
                System.out.println("Error: " + line);
            }

            // Дождитесь завершения выполнения Python
            process.waitFor();
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
*/

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
/*       String programmName = "convert.exe"; // Название программы, которую вы хотите проверить

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
        }*/
/*        try {
            // Укажите путь к исполняемому файлу FFmpeg
            String ffmpegPath = "/путь/к/ffmpeg";

            // Укажите путь к вашему файлу 3GP и MP4
            String inputVideo = "/путь/к/input.3gp";
            String outputVideo = "/путь/к/output.mp4";

            // Создайте команду для конвертации
            String[] cmd = { ffmpegPath, "-i", inputVideo, "-c:v", "libx264", "-strict", "-2", outputVideo };

            // Запустите процесс FFmpeg
            ProcessBuilder processBuilder = new ProcessBuilder(cmd);
            Process process = processBuilder.start();

            // Дождитесь завершения процесса
            int exitCode = process.waitFor();

            if (exitCode == 0) {
                // Конвертация успешно завершена
                response.getWriter().write("Конвертация успешно завершена!");
            } else {
                // Произошла ошибка
                response.getWriter().write("Произошла ошибка во время конвертации.");
            }
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            response.getWriter().write("Произошла ошибка: " + e.getMessage());
        }*/
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