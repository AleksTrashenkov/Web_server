package ru.web_server_home;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/cloud")
@MultipartConfig(maxFileSize = 1024 * 1024 * 2000, maxRequestSize = 1024 * 1024 * 2000)
public class FileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "F:/cloud";
    public static Multimap<String, String> filesCloud = ArrayListMultimap.create();
    public static Multimap<String, String> structureCloud = ArrayListMultimap.create();
    public static HashMap<String, String> ipTablesClients = new HashMap<>();
    public static HashMap<String,String> ipTablesClientsFiles = new HashMap<>();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException, ServletException {
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
                        deleteFolder(folderPath);
                        try {
                            response.sendRedirect(ipTablesClients.get(request.getRemoteAddr()).replace("F:","/home_cloud"));
                            /*response.setContentType("text/plain");
                            response.getWriter().println("Папка удалена: " + requestedFilePath);*/
                        } catch (IOException e) {}
                    } else {
                        String locPath = ipTablesClientsFiles.get(request.getRemoteAddr()) + requestedFilePath;
                            deleteFile(locPath);
                            try {
                                response.sendRedirect(ipTablesClientsFiles.get(request.getRemoteAddr()).replace("F:", "/home_cloud"));
                            /*response.setContentType("text/plain");
                            response.getWriter().println("Файл удален: " + requestedFilePath);*/
                            } catch (IOException e) {
                            }
                    }
                } else if ("view".equals(action)) {
                    try {
                        serveFile(requestedFilePath, response, request);
                    } catch (IOException es) {}
                } else if ("rename".equals(action)) {
                    try {
                        rename(request, response, requestedFilePath);
                    }catch (IOException ex) {}
                } else {
                    if (requestedFilePath.endsWith("/")) {
                        showFolderContentsRUSPath(request, response, requestedFilePath);
                    } else {
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
    private static void scanDirectory(File dir, String parentPath) {
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
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Collection<Part> fileParts = request.getParts();

        for (Part filePart : fileParts) {
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);

                String filePath = ipTablesClientsFiles.get(request.getRemoteAddr()) + File.separator + fileName;
                filePart.write(filePath);
            }
        }
        // После загрузки файлов перенаправляем пользователя на страницу с содержимым папки
        response.sendRedirect(request.getContextPath() + ipTablesClientsFiles.get(request.getRemoteAddr()).replace("F:", ""));
    }

    private void serveFile(String requestedFilePath, HttpServletResponse response, HttpServletRequest request) throws ServletException, IOException {
       String filePath = ipTablesClientsFiles.get(request.getRemoteAddr()) + requestedFilePath;
        File file = new File(filePath);

        if (file.exists() && file.isFile()) {
                response.setContentType(getContentType(filePath));
                response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");

                try (InputStream inputStream = new FileInputStream(file);
                     OutputStream outputStream = response.getOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }
                }
            } else {
            showFolderContents(request, response, requestedFilePath);
                /*response.setContentType("text/plain");
                response.getWriter().println("File not found: " + requestedFilePath);*/
            }
        }
    private void showFolderContents(HttpServletRequest request, HttpServletResponse response, String requestedFilePath) throws ServletException {
        try {
            String folderPath = UPLOAD_DIRECTORY + requestedFilePath;
            ipTablesClients.put(request.getRemoteAddr(), folderPath);
            ipTablesClientsFiles.put(request.getRemoteAddr(), folderPath);
            File folder = new File(folderPath);

            if (folder.exists() && folder.isDirectory()) {
                    List<File> filesList = Arrays.asList(folder.listFiles());

                    int itemsPerPage = 15;
                    String pageParam = request.getParameter("page");
                    int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
                    int startIdx = (currentPage - 1) * itemsPerPage;
                    int endIdx = Math.min(startIdx + itemsPerPage, filesList.size());

                    List<File> itemsToShow = filesList.subList(startIdx, endIdx);

                    long creationTime = folder.lastModified();
                    Date creationDate = new Date(creationTime);

                    request.setAttribute("creationDate", creationDate);
                    request.setAttribute("currentPage", currentPage);
                    request.setAttribute("itemsPerPage", itemsPerPage);
                    request.setAttribute("files", itemsToShow);
                    request.setAttribute("filesList", filesList);
                    request.setAttribute("currentPath", folderPath.replace("F:", "home_cloud"));
                    request.getRequestDispatcher("/WEB-INF/jsp/file_list.jsp").forward(request, response);
                } else {
                    serveFile(requestedFilePath, response, request);
                }
        } catch (IOException e) {
            // Обработка ошибок
        }
    }
    private void showFolderContentsRUSPath(HttpServletRequest request, HttpServletResponse response, String requestedFilePath) throws ServletException {
        try {
            if (!getStructure(UPLOAD_DIRECTORY).get(requestedFilePath.replace("/", "")).isEmpty()) {
                String folderPath = getStructure(UPLOAD_DIRECTORY).get(requestedFilePath.replace("/", "")).stream().filter(e -> e.startsWith(ipTablesClientsFiles.get(request.getRemoteAddr()))).findFirst().toString().replace("Optional[", "").replace("]", "");
                ipTablesClients.put(request.getRemoteAddr(), folderPath.replace(requestedFilePath.replace("/",""), ""));
                ipTablesClientsFiles.put(request.getRemoteAddr(), folderPath);
                File folder = new File(folderPath);

                if (folder.exists() && folder.isDirectory()) {
                    List<File> filesList = Arrays.asList(folder.listFiles());

                    int itemsPerPage = 15;
                    String pageParam = request.getParameter("page");
                    int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
                    int startIdx = (currentPage - 1) * itemsPerPage;
                    int endIdx = Math.min(startIdx + itemsPerPage, filesList.size());

                    List<File> itemsToShow = filesList.subList(startIdx, endIdx);

                    long creationTime = folder.lastModified();
                    Date creationDate = new Date(creationTime);

                    request.setAttribute("creationDate", creationDate);
                    request.setAttribute("currentPage", currentPage);
                    request.setAttribute("itemsPerPage", itemsPerPage);
                    request.setAttribute("fileList", filesList);
                    request.setAttribute("endIdx", endIdx);
                    request.setAttribute("files", itemsToShow);
                    request.setAttribute("filesList", filesList);
                    request.setAttribute("currentPath", folderPath.replace("F:", "home_cloud"));
                    request.getRequestDispatcher("/WEB-INF/jsp/file_list.jsp").forward(request, response);
                } else {showFolderContents(request, response, requestedFilePath);}
            } else {
                serveFile(requestedFilePath, response, request);
            }
        } catch (IOException e) {
            // Обработка ошибок
        }
    }
        private String getContentType(String fileName) {
        String contentType = getServletContext().getMimeType(fileName);
        return (contentType != null) ? contentType : "application/octet-stream";
    }

    private void deleteFile(String requestedFilePath) {
        File file = new File(requestedFilePath);
        if (file.exists() && file.isFile()) {
            file.delete();
        }
    }

    private void deleteFolder(String requestedFilePath) {
        File folder = new File(requestedFilePath);
        if (folder.isDirectory() && folder.exists()) {
            folder.delete();
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
    public static boolean containsRussianLetters(String text) {
        Pattern pattern = Pattern.compile("[а-яА-ЯёЁ]");
        Matcher matcher = pattern.matcher(text);
        return matcher.find();
    }
    public static void rename (HttpServletRequest request, HttpServletResponse response, String requestedFilePath) throws IOException {
        // String fullPath = FileServlet.ipTablesClients.get(request.getRemoteAddr()) + requestedFilePath;
        try(FileWriter writer = new FileWriter(UPLOAD_DIRECTORY+"/notes3.txt", false))
        {
            // запись всей строки
            String text = "Hello Gold!";
            writer.write(text);

            writer.flush();
        }
        catch(IOException ex){

            System.out.println(ex.getMessage());
        }
        String oldFileName = request.getParameter("oldFileName");
        String newFileName = request.getParameter("newFileName");
        String oldPath = ipTablesClients.get(request.getRemoteAddr()) + oldFileName;
       // String oldPath = getFiles(UPLOAD_DIRECTORY).get(oldFileName);
        String newPath = ipTablesClients.get(request.getRemoteAddr()) + newFileName;
       //String newPath = getFiles(UPLOAD_DIRECTORY).get(newFileName);
        File oldFile = new File(oldPath);
        File newFile = new File(newPath);

        if (oldFile.exists()) {
            if (oldFile.renameTo(newFile)) {
                response.getWriter().write("success"); // Отправляем успешный ответ
            } else {
                response.getWriter().write("error"); // Отправляем ответ об ошибке
            }
        } else {
            response.getWriter().write("file_not_found"); // Отправляем ответ, что файл не найден
        }
    }
    }

