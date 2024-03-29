package ru.web_server_home;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.*;
import java.net.URLDecoder;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet("/cloud")
@MultipartConfig(maxFileSize = 1024 * 1024 * 2000, maxRequestSize = 1024 * 1024 * 2000)
public class FileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "D:/cloud";
    public static Multimap<String, String> structureCloud = ArrayListMultimap.create();
    public static HashMap<String, String> ipTablesClients = new HashMap<>();
    public static HashMap<String,String> ipTablesClientsFiles = new HashMap<>();
    public static Multimap<String, File> structureCloudFind = ArrayListMultimap.create();
    public static Multimap<String, File> structureCloudPref = ArrayListMultimap.create();
    public static HashMap<String, String> ipTalesNameFolder = new HashMap<>();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String requestedFilePath = URLDecoder.decode((request.getPathInfo() != null ? request.getPathInfo() : ""), "UTF-8");
        if (requestedFilePath == null || requestedFilePath.equals("/")) {
            showFolderContents(request, response, requestedFilePath);
        } else {
            String action = request.getParameter("action");
            if ("download".equals(action)) {
                showFolderContentsRUSPath(request, response, requestedFilePath);
            } else if ("delete".equals(action)) {
                if (!getStructure(UPLOAD_DIRECTORY).get(requestedFilePath.replace("/", "")).isEmpty()) {
                    String folderPath = getStructure(UPLOAD_DIRECTORY).get(requestedFilePath.replace("/", "")).stream().filter(e -> e.startsWith(ipTablesClients.get(request.getRemoteAddr()))).findFirst().toString().replace("Optional[", "").replace("]", "");
                    deleteFolder(folderPath, response, request);
                } else {
                    String locPath = ipTablesClientsFiles.get(request.getRemoteAddr()) + requestedFilePath;
                    deleteFile(locPath, response, request);
                }
            } else if ("view".equals(action)) {
                try {
                    serveFile(requestedFilePath, response, request);
                } catch (IOException es) {}
            } else if ("redirectToVideos".equals(action)) {
                String ipAdres = request.getRemoteAddr();

                request.setAttribute("ipAdres", ipAdres);
                request.getRequestDispatcher("/WEB-INF/jsp/videos.jsp").forward(request, response);
            } else {
                if (requestedFilePath.endsWith("/")) {
                    showFolderContentsRUSPath(request, response, requestedFilePath);
                } else if (requestedFilePath.endsWith(".mp4") || requestedFilePath.endsWith(".MOV")
                        || requestedFilePath.endsWith(".avi") || requestedFilePath.endsWith(".3gp")
                        || requestedFilePath.endsWith(".MKV".toLowerCase())
                        || requestedFilePath.endsWith(".WMV".toLowerCase()) || requestedFilePath.endsWith(".WebM".toLowerCase())
                        || requestedFilePath.endsWith(".Ogg".toLowerCase())) {
                    serveFileLoader(requestedFilePath, response, request);
                }else {
                    String redirectPath = request.getContextPath() + "/cloud" + requestedFilePath + "/";
                    try {
                        response.sendRedirect(redirectPath);
                    } catch (IOException e) {
                    }
                }
            }
        }
    }
    public static Multimap<String, String> getStructure(String directory) {
        scanDirectory(new File(directory), "");
        return structureCloud;
    }
    private static Multimap<String, String> scanDirectory(File dir, String parentPath) {
        if (dir.isDirectory()) {
            for (File item : dir.listFiles()) {
                if (item.isDirectory()) {
                    structureCloud.put(item.getName(), item.getAbsolutePath().replace("\\","/"));
                    scanDirectory(item, item.getAbsolutePath());
                } /*else {
                    filesCloud.put(item.getName(), item.getAbsolutePath().replace("\\","/"));
                }*/
            }
        }
        return structureCloud;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        switch (action) {
            case "rename" :
                rename(request, response);
                break;
            case "createFolder" :
                createFolder(response, request);
                break;
            case "loader" :
                loader(request, response);
                break;
            case "findFolderFile" :
                findFolderFile(response, request);
                break;
            case "convert" :
                convertHEICtoJPEG(request, response, ipTablesClientsFiles.get(request.getRemoteAddr())+ "/" + request.getParameter("fileName"), ipTablesClientsFiles.get(request.getRemoteAddr())+ "/" + request.getParameter("fileName").replace(".HEIC","(изм. heic).jpg"));
                //response.sendError(HttpServletResponse.SC_NOT_FOUND, "Здесь скоро будет обработчик конвертации "+ request.getParameter("fileName"));
                break;
        }
    }
    private void serveFile(String requestedFilePath, HttpServletResponse response, HttpServletRequest request) throws ServletException, IOException {
        String filePath = ipTablesClientsFiles.get(request.getRemoteAddr()) + requestedFilePath;
        File file = new File(filePath);

        if (file.exists() && file.isFile()) {
            response.setContentType(getContentType(filePath));
            response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");

            try (InputStream inputStream = new FileInputStream(file);
                 OutputStream outputStream = response.getOutputStream()) {
                byte[] buffer = new byte[2097152];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }
        } else {
            // Если папка не существует или не является директорией, то проверьте, существует ли файл и предпросмотрите его, если он существует.
            if (file.exists() && file.isDirectory()) {
                showFolderContents(request, response, requestedFilePath);
            } else {
                // Если и файл не существует, и папка не существует, то выведите сообщение об ошибке.
                // response.sendError(HttpServletResponse.SC_NOT_FOUND, "Folder or File not found");
                //serveFile(requestedFilePath, response, request);
            }
        }
    }
    private void serveFileLoader(String requestedFilePath, HttpServletResponse response, HttpServletRequest request) throws ServletException, IOException {
        String filePath = UPLOAD_DIRECTORY + requestedFilePath;
        File file = new File(filePath);

        if (file.exists() && file.isFile()) {
            response.setContentType(getContentType(filePath));
            response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");

            try (InputStream inputStream = new FileInputStream(file);
                 OutputStream outputStream = response.getOutputStream()) {
                byte[] buffer = new byte[2097152];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }
        } else {
            // Если папка не существует или не является директорией, то проверьте, существует ли файл и предпросмотрите его, если он существует.
            if (file.exists() && file.isDirectory()) {
                showFolderContents(request, response, requestedFilePath);
            } else {
                // Если и файл не существует, и папка не существует, то выведите сообщение об ошибке.
                // response.sendError(HttpServletResponse.SC_NOT_FOUND, "Folder or File not found");
                //serveFile(requestedFilePath, response, request);
            }
        }
    }
    private void showFolderContents(HttpServletRequest request, HttpServletResponse response, String requestedFilePath) throws ServletException, IOException {
        try {
            String folderPath = UPLOAD_DIRECTORY + requestedFilePath;
            ipTablesClients.put(request.getRemoteAddr(), folderPath);
            ipTablesClientsFiles.put(request.getRemoteAddr(), folderPath);
            File folder = new File(folderPath);

            if (folder.exists() && folder.isDirectory()) {
                List<File> filesList = Arrays.asList(folder.listFiles());

                long creationTime = folder.lastModified();
                Instant instant = Instant.ofEpochMilli(creationTime);
                LocalDateTime lastModCreat = LocalDateTime.ofInstant(instant, ZoneId.systemDefault());
                DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
                String formattedDateTime = lastModCreat.format(dateTimeFormatter);
                String ipAdres = request.getRemoteAddr();

                request.setAttribute("ipAdres", ipAdres);
                request.setAttribute("creationDate", formattedDateTime);
                request.setAttribute("files", filesList);
                request.setAttribute("currentPath", folderPath.replace("D:", "home_cloud"));
                request.getRequestDispatcher("/WEB-INF/jsp/file_list.jsp").forward(request, response);
            } else {
                // Если папка не существует или не является директорией, то проверьте, существует ли файл и предпросмотрите его, если он существует.
                File file = new File(UPLOAD_DIRECTORY + requestedFilePath);
                if (file.exists() && file.isFile()) {
                    serveFile(requestedFilePath, response, request);
                } else {
                    // Если и файл не существует, и папка не существует, то выведите сообщение об ошибке.
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Folder or File not found");
                }
            }
        } catch (IOException e) {
            // Обработка ошибок
        }catch (IllegalArgumentException e) {
            showFolderContentsRUSPath(request, response, ipTalesNameFolder.get(request.getRemoteAddr()));
        }
    }
    private void showFolderContentsRUSPath(HttpServletRequest request, HttpServletResponse response, String requestedFilePath) throws ServletException, IOException {
        try {
            if (!getStructure(UPLOAD_DIRECTORY).get(requestedFilePath.replace("/", "")).isEmpty()) {
                String folderPath = getStructure(UPLOAD_DIRECTORY).get(requestedFilePath.replace("/", "")).stream().filter(e -> e.startsWith(ipTablesClientsFiles.get(request.getRemoteAddr()))).findFirst().toString().replace("Optional[", "").replace("]", "");
                ipTablesClients.put(request.getRemoteAddr(), folderPath.replace(requestedFilePath.replace("/",""), ""));
                ipTablesClientsFiles.put(request.getRemoteAddr(), folderPath);
                ipTalesNameFolder.put(request.getRemoteAddr(), requestedFilePath);
                File folder = new File(folderPath);

                if (folder.exists() && folder.isDirectory()) {
                    List<File> filesList = Arrays.asList(folder.listFiles());

                    long creationTime = folder.lastModified();
                    Instant instant = Instant.ofEpochMilli(creationTime);
                    LocalDateTime lastModCreat = LocalDateTime.ofInstant(instant, ZoneId.systemDefault());
                    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
                    String formattedDateTime = lastModCreat.format(dateTimeFormatter);

                    String ipAdres = request.getRemoteAddr();
                    request.setAttribute("ipAdres", ipAdres);
                    request.setAttribute("creationDate", formattedDateTime);
                    request.setAttribute("files", filesList);
                    request.setAttribute("currentPath", folderPath.replace("D:", "home_cloud"));
                    request.getRequestDispatcher("/WEB-INF/jsp/file_list.jsp").forward(request, response);
                } else {showFolderContents(request, response, requestedFilePath);}
            } else {
                if (new File(ipTablesClientsFiles.get(request.getRemoteAddr())+requestedFilePath).isFile()) {
                    serveFile(requestedFilePath, response, request);
                } else {
                    showFolderContents(request, response, requestedFilePath);
                }
            }
        } catch (IOException ez) {
            // Обработка ошибок
        }catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Еще ошибочка нах");
        }
    }
    private String getContentType(String fileName) {
        String contentType = getServletContext().getMimeType(fileName);
        return (contentType != null) ? contentType : "application/octet-stream";
    }

    private void deleteFile(String requestedFilePath, HttpServletResponse response, HttpServletRequest request) {
        File file = new File(requestedFilePath);
        if (file.exists() && file.isFile()) {
            file.delete();
        }
        try {
            showFolderContents(request, response, ipTablesClients.get(request.getRemoteAddr()).replace(UPLOAD_DIRECTORY, ""));
        } catch (ServletException | IOException ex) {}
    }

    private void deleteFolder(String requestedFilePath, HttpServletResponse response, HttpServletRequest request) {
        File folder = new File(requestedFilePath);
        if (folder.isDirectory() && folder.exists()) {
            folder.delete();
        }
        try {
            showFolderContents(request, response, ipTablesClients.get(request.getRemoteAddr()).replace(UPLOAD_DIRECTORY, ""));
        }catch (ServletException | IOException ex) {}
    }
    private void findFolderFile (HttpServletResponse response, HttpServletRequest request) throws ServletException, IOException {
        if (!structureCloudFind.isEmpty()){
            structureCloudFind.clear();
        }
        String wordFind = request.getParameter("findName");
        Multimap<String, File> searchResults = getStructureFind(UPLOAD_DIRECTORY, wordFind);
        List<Map.Entry<String, File>> searchResultsList = new ArrayList<>(searchResults.entries());

        // Сохраните результаты поиска в атрибуте запроса
        String ipAdres = request.getRemoteAddr();

        request.setAttribute("ipAdres", ipAdres);
        request.setAttribute("searchResults", searchResultsList);
        request.setAttribute("wordFind", wordFind);
        // Перенаправьте запрос на JSP-страницу
        request.getRequestDispatcher("/WEB-INF/jsp/file_list_finds.jsp").forward(request, response);
    }
    public static Multimap<String, File> getStructureFind(String directory, String wordFind) {
        scanDirectoryFind(new File(directory), wordFind, "all");
        return structureCloudFind;
    }
    public static List<Map.Entry<String, File>> getStructureCloudPref (String directory) {
        if (!structureCloudPref.isEmpty()){
            structureCloudPref.clear();
        }
        scanDirectoryFind(new File(directory), null, ".mp4" );
        List<Map.Entry<String, File>> searchResultsList = new ArrayList<>(structureCloudPref.entries());
        searchResultsList.sort((entry1, entry2) -> entry1.getKey().compareTo(entry2.getKey()));
        return searchResultsList;
    }


    private static void scanDirectoryFind(File dir, String targetWord, String pref) {
        if (pref.equals("all") && targetWord != null) {
            if (dir.isDirectory()) {
                for (File item : dir.listFiles()) {
                    String itemName = item.getName().toLowerCase();
                    if (itemName.contains(targetWord.toLowerCase())) {
                        structureCloudFind.put(itemName, new File(item.getAbsolutePath().replace("\\", "/").replace(UPLOAD_DIRECTORY, "")));
                    }
                    scanDirectoryFind(item, targetWord, pref);
                }
            }
        }else {
            if (dir.isDirectory()) {
                for (File item : dir.listFiles()) {
                    String itemName = item.getName().toLowerCase();
                    if (itemName.endsWith(pref.toLowerCase()) || itemName.endsWith(".MOV".toLowerCase()) || itemName.endsWith(".avi".toLowerCase())
                            || itemName.endsWith(".3gp".toLowerCase()) || itemName.endsWith(".MKV".toLowerCase())
                    || itemName.endsWith(".WMV".toLowerCase()) || itemName.endsWith(".WebM".toLowerCase()) || itemName.endsWith(".Ogg".toLowerCase())) {
                        DecimalFormat df = new DecimalFormat("0.##");
                        long fileSize = new File(item.getAbsolutePath()).length(); // Получение размера файла в байтах
                        double fileSizeInGB = (double) fileSize / (1024 * 1024); // Перевод в гигабайты
                        String formattedSize = df.format(fileSizeInGB);
                        long creationTime = new File(item.getAbsolutePath()).lastModified();
                        Instant instant = Instant.ofEpochMilli(creationTime);
                        LocalDateTime lastModCreat = LocalDateTime.ofInstant(instant, ZoneId.systemDefault());
                        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
                        String formattedDateTime = lastModCreat.format(dateTimeFormatter);
                        structureCloudPref.put(itemName + " ("+formattedSize+" Мб, созд. "+formattedDateTime+")", new File(item.getAbsolutePath().replace("\\", "/").replace(UPLOAD_DIRECTORY, "")));
                    }
                    scanDirectoryFind(item, targetWord, pref);
                }
            }
        }
    }

    private String getSubmittedFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
    public void createFolder(HttpServletResponse response, HttpServletRequest request) throws ServletException, IOException {
        //String currentPath = request.getParameter("currentPath");
        String currentPath = ipTablesClientsFiles.get(request.getRemoteAddr());
        String newFolderName = request.getParameter("newFolderNameCreate");
        if (currentPath != null && newFolderName != null && !newFolderName.isEmpty()) {
            String fullPath;
            Random rnd = new Random();
            int number = rnd.nextInt(1000) + 1;
            if (ipTablesClientsFiles.get(request.getRemoteAddr()).endsWith(newFolderName) || new File(ipTablesClientsFiles.get(request.getRemoteAddr()) + "/" + newFolderName).exists()) {
                fullPath = ipTablesClientsFiles.get(request.getRemoteAddr()) + "/" + newFolderName+"("+number+")";
            } else {
                fullPath  = ipTablesClientsFiles.get(request.getRemoteAddr()) + "/" + newFolderName;
            }
            File newFolder = new File(fullPath);
            if (!newFolder.exists()) {
                newFolder.mkdirs();
            }
        }
        showFolderContents(request, response, ipTablesClientsFiles.get(request.getRemoteAddr()).replace(UPLOAD_DIRECTORY, ""));
    }
    public void rename (HttpServletRequest request, HttpServletResponse response) throws IOException {
        String oldFileName = request.getParameter("oldFileName");
        String newFileName = request.getParameter("newFileName");

        String oldPath = ipTablesClientsFiles.get(request.getRemoteAddr()) + "/" + oldFileName;
        String newPath;
        Random rnd = new Random();
        int number = rnd.nextInt(1000) + 1;
        if (ipTablesClientsFiles.get(request.getRemoteAddr()).endsWith(newFileName)) {
            newPath = ipTablesClientsFiles.get(request.getRemoteAddr()) + "/" + newFileName+"("+number+")";
        } else {
            newPath = ipTablesClientsFiles.get(request.getRemoteAddr()) + "/" + newFileName;
        }
        File oldFile = new File(oldPath);
        File newFile = new File(newPath);

        if (oldFile.exists()) {
            if (oldFile.renameTo(newFile)) {
                //response.getWriter().write("success"); // Отправляем успешный ответ
                try {
                    showFolderContents(request, response, ipTablesClientsFiles.get(request.getRemoteAddr()).replace(UPLOAD_DIRECTORY, ""));
                }catch (ServletException ex) {}
            } else {
                response.getWriter().write("error"); // Отправляем ответ об ошибке
            }
        } else {
            response.getWriter().write("file_not_found"); // Отправляем ответ, что файл не найден
        }
    }
    public void loader (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Collection<Part> fileParts = request.getParts();

        for (Part filePart : fileParts) {
            if (filePart != null && filePart.getSize() > 0 && !filePart.getName().equals("action")) {
                String fileName = getSubmittedFileName(filePart);

                String filePath;
                Random rnd = new Random();
                int number = rnd.nextInt(1000) + 1;
                if (new File(ipTablesClientsFiles.get(request.getRemoteAddr()) + File.separator + fileName).exists()) {
                    filePath = ipTablesClientsFiles.get(request.getRemoteAddr()) + File.separator + fileName+"("+number+")";
                } else {
                    filePath = ipTablesClientsFiles.get(request.getRemoteAddr()) + File.separator + fileName;
                }
                filePart.write(filePath);
            }
        }
        // После загрузки файлов перенаправляем пользователя на страницу с содержимым папки
        showFolderContents(request, response, ipTablesClientsFiles.get(request.getRemoteAddr()).replace(UPLOAD_DIRECTORY,""));
    }
    public void convertHEICtoJPEG(HttpServletRequest request, HttpServletResponse response, String heicPath, String jpegPath) throws ServletException, IOException {
        try {
            ProcessBuilder processBuilder = new ProcessBuilder("C:\\Program Files\\ImageMagick-7.1.1-Q16-HDRI\\convert.exe", heicPath, jpegPath);
            Process process = processBuilder.start();

            int exitCode = process.waitFor();
            if (exitCode == 0) {
                System.out.println("Конвертация завершена успешно.");
            } else {
                try(FileWriter writer = new FileWriter("C:\\Program Files\\Apache Software Foundation\\Tomcat 9.0_mini-server\\webapps\\home_cloud\\errorsConvertation.txt", false))
                {
                    // запись всей строки
                    String text = "Oшибка конвертации файла: " + heicPath;
                    writer.write(text);

                    writer.flush();
                }
                catch(IOException ex){

                    System.out.println(ex.getMessage());
                }
            }
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
        File fileDel = new File(heicPath);
        fileDel.delete();
        showFolderContents(request, response, ipTablesClientsFiles.get(request.getRemoteAddr()).replace(UPLOAD_DIRECTORY,""));
    }
}

