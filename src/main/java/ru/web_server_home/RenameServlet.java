package ru.web_server_home;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
//import javax.management.OperatingSystemMXBean;
import java.lang.management.ManagementFactory;

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

/*@WebServlet(name = "SystemInfoServlet", urlPatterns = {"/system-info"})
public class SystemInfoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        OperatingSystemMXBean osBean = ManagementFactory.getPlatformMXBean(OperatingSystemMXBean.class);

        double cpuLoad = osBean.getSystemCpuLoad() * 100;

        long totalMemory = osBean.getTotalPhysicalMemorySize();
        long freeMemory = osBean.getFreePhysicalMemorySize();

        request.setAttribute("cpuLoad", cpuLoad);
        request.setAttribute("totalMemory", totalMemory);
        request.setAttribute("freeMemory", freeMemory);

        // Передаем управление JSP странице
        request.getRequestDispatcher("/system-info.jsp").forward(request, response);
    }
}*/
//вывод инфы:

/*
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Состояние ПК</title>
</head>
<body>
<h1>Информация о состоянии ПК</h1>
<p>CPU Load: <%= request.getAttribute("cpuLoad") %> %</p>
<p>Total Memory: <%= (Long) request.getAttribute("totalMemory") / (1024 * 1024) %> MB</p>
<p>Free Memory: <%= (Long) request.getAttribute("freeMemory") / (1024 * 1024) %> MB</p>
</body>
</html>*/
