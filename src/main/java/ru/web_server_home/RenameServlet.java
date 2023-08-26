package ru.web_server_home;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;

public class RenameServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String requestedFilePath = URLDecoder.decode((request.getPathInfo() != null ? request.getPathInfo() : ""), "UTF-8");
       // String fullPath = FileServlet.ipTablesClients.get(request.getRemoteAddr()) + requestedFilePath;
        String oldFileName = request.getParameter("oldFileName");
        String newFileName = request.getParameter("newFileName");
        String oldPath = FileServlet.ipTablesClients.get(request.getRemoteAddr()) + oldFileName;
        String newPath = FileServlet.ipTablesClients.get(request.getRemoteAddr()) + newFileName;
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
