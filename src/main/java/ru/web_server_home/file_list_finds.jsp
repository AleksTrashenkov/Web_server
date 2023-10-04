<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList, java.util.HashMap" %>
<!DOCTYPE html>
<html>
<head>
    <title>File List</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 90%; /* Changed width */
            max-width: 800px;
            margin: 20px auto; /* Centered on the screen */
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        .file-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .file-item {
            display: flex;
            flex-wrap: wrap; /* Wraps items if too narrow */
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e6e6e6;
        }
        .file-icon {
            margin-right: 10px;
            font-size: 24px;
        }
        .file-name {
            flex: 1;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-right: 10px;
        }
        .file-actions {
            display: flex;
            gap: 10px;
        }
        .file-link {
            text-decoration: none;
            color: #007bff;
        }
        .file-link:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .container {
                width: 95%;
            }
        }
        .footer {
                position: fixed;
                bottom: 10px;
                right: 10px;
                font-size: 12px;
                color: #888;
                background-color: #f8f8f8;
                padding: 5px 10px;
                border-radius: 5px;
                box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.1);
            }
            .breadcrumb {
                    margin-top: 10px;
                    font-size: 14px;
                    color: #888;
                }
                .breadcrumb a {
                    color: #007bff;
                    text-decoration: none;
                }
                .breadcrumb a:hover {
                    text-decoration: underline;
                }
                .rename-dialog {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background-color: rgba(0, 0, 0, 0.5);
                    z-index: 1000;
                }

                .dialog-content {
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    background-color: white;
                    padding: 20px;
                    border-radius: 5px;
                    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.3);
                }

                .dialog-content h2 {
                    margin-top: 0;
                }

                .dialog-content label {
                    display: block;
                    margin-bottom: 10px;
                }

                .dialog-content input[type="text"] {
                    width: 100%;
                    padding: 5px;
                    margin-bottom: 10px;
                }

                .dialog-content button {
                    padding: 5px 10px;
                    margin-right: 10px;
                    border: none;
                    cursor: pointer;
                }

                .dialog-content button:last-child {
                    margin-right: 0;
                }
                /* Стили для основной кнопки */
                .btn {
                    display: inline-block;
                    padding: 10px 20px;
                    font-size: 14px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    text-align: center;
                    text-decoration: none;
                    outline: none;
                    color: #fff;
                }

                /* Стили для кнопки "Подтвердить" */
                .btn-primary {
                    background-color: #007bff;
                }

                /* Стили для кнопки "Отмена" */
                .btn-secondary {
                    background-color: #6c757d;
                }
                /* Стили для элементов пагинации */
                .pagination {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    margin-top: 20px;
                }

                .pagination a, .pagination span {
                    padding: 8px 12px;
                    margin: 0 5px;
                    text-align: center;
                    text-decoration: none;
                    border: 1px solid #ddd;
                    border-radius: 3px;
                    cursor: pointer;
                    transition: background-color 0.3s, color 0.3s;
                }

                .pagination a:hover {
                    background-color: #f2f2f2;
                }

                .pagination .current-page {
                    background-color: #007bff;
                    color: white;
                    border: 1px solid #007bff;
                }

                .pagination .disabled {
                    color: #ddd;
                    pointer-events: none;
                }
    </style>
</head>
<body>
<div class="container">
    <h1>Частное облако</h1>
    <div class="free-space">
            <%
                long freeSpace = getFreeDiskSpace();
                long totalSpace = getTotalDiskSpace();
                double usedPercentage = 100.0 - ((double) freeSpace / totalSpace) * 100;
                int batterySegments = 10; // Количество сегментов батареи
                int filledSegments = (int) (usedPercentage / (100.0 / batterySegments));
                String batterySymbol = "\u25A3"; // Заполненный квадрат (можно изменить на другой символ)
                String batteryColor = (usedPercentage > 80) ? "red" : "green"; // Изменение цвета при большой заполненности
                StringBuilder battery = new StringBuilder();
                for (int i = 0; i < batterySegments; i++) {
                    if (i < filledSegments) {
                        battery.append("<span style='color: ").append(batteryColor).append(";'>").append(batterySymbol).append("</span>");
                    } else {
                        battery.append("\u25A1"); // Незаполненный квадрат (можно изменить на другой символ)
                    }
                }
            %>
<div class="breadcrumb">
<a href="${pageContext.request.contextPath}/cloud/">Главная</a>
    </div>
    <p>Свободное место на диске: <%= freeSpace %> ГБ (<%= (int) usedPercentage %>%)  <%= battery.toString() %></p>
<ul class="file-list">
    <c:forEach var="file" items="${searchResults}">
            <li class="file-item">
            <span class="file-icon">
                <!-- Иконка файла или папки -->
                <i class="<c:choose>
                            <c:when test='${file.value.directory}'>fas fa-folder'</c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test='${file.value.toString().toLowerCase().endsWith(".jpg") or file.value.toString().toLowerCase().endsWith(".png") or file.value.toString().toLowerCase().endsWith(".jpeg")}'>fas fa-image'</c:when>
                                    <c:when test='${file.value.toString().toLowerCase().endsWith(".txt")}'>far fa-file-alt'</c:when>
                                    <c:when test='${file.value.toString().toLowerCase().endsWith(".pdf")}'>far fa-file-pdf'</c:when>
                                    <c:when test='${file.value.toString().toLowerCase().endsWith(".doc") or file.value.toString().toLowerCase().endsWith(".docx")}'>far fa-file-word'</c:when>
                                    <c:when test='${file.value.toString().toLowerCase().endsWith(".mp4") or file.value.toString().toLowerCase().endsWith(".avi") or file.value.toString().toLowerCase().endsWith(".mkv")}'>far fa-file-video'</c:when>
                                    <c:when test='${file.value.toString().toLowerCase().endsWith(".exe")}'>far fa-file-exe'</c:when>
                                    <c:when test='${file.value.toString().toLowerCase().endsWith(".jar")}'>far fa-file-code'</c:when>
                                    <c:when test='${file.value.toString().toLowerCase().endsWith(".heic")}'>far fa-file-image'</c:when>
                                    <c:when test='${file.value.directory}'>fas fa-folder'</c:when>
                                    <c:otherwise>far fa-file'</c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>"></i>
            </span>
            <span class="file-preview">
                <!-- Предпросмотр или иконка для файла или папки -->
                <c:choose>
                    <c:when test='${file.value.toString().toLowerCase().endsWith(".jpg") or file.value.toString().toLowerCase().endsWith(".png") or file.value.toString().toLowerCase().endsWith(".jpeg") or file.value.toString().toLowerCase().endsWith(".gif")}'>
                        <img class="file-image" src="<c:url value='/cloud/${file.value.toString()}'><c:param name='action' value='view' /><c:param name='currentPath' value='${pageContext.request.pathInfo}' /></c:url>" alt="${file.value.toString()}" style="max-width: 100px; max-height: 100px;" />
                    </c:when>

                    <c:when test="${file.value.directory}">
                        <i class="fas fa-folder"></i>
                    </c:when>
                    <c:when test="${file.value.toString().toLowerCase().endsWith('.txt')}">
                        <i class="far fa-file-alt"></i>
                    </c:when>
                    <c:when test="${file.value.toString().toLowerCase().endsWith('.pdf')}">
                        <i class="far fa-file-pdf"></i>
                    </c:when>
                    <c:when test="${file.value.toString().toLowerCase().endsWith('.doc') or file.value.toString().toLowerCase().endsWith('.docx')}">
                        <i class="far fa-file-word"></i>
                    </c:when>
                    <c:when test="${file.value.toString().toLowerCase().endsWith('.mp4') or file.value.toString().toLowerCase().endsWith('.avi') or file.value.toString().toLowerCase().endsWith('.mkv') or file.value.toString().toLowerCase().endsWith('.mov') or file.value.toString().toLowerCase().endsWith('.wmv')}">
                        <i class="far fa-file-video"></i>
                    </c:when>
                    <c:when test="${file.value.toString().toLowerCase().endsWith('.rar') or file.value.toString().toLowerCase().endsWith('.zip')}">
                    <i class="far fa-file-archive"></i>
                    </c:when>
                    <c:when test="${file.value.toString().toLowerCase().endsWith('.jar')}">
                        <i class="far fa-file-code"></i>
                    </c:when>
                    <c:when test="${file.value.toString().toLowerCase().endsWith('.heic')}">
                     <i class="far fa-file-image"></i>
                    </c:when>
                    <c:otherwise>
                        <i class="fas fa-file"></i>
                    </c:otherwise>
                </c:choose>
            </span>
            <span class="file-name">
                <!-- Имя файла -->
                &nbsp;
               <c:choose>
                    <c:when test="${file.value.directory}">
                        <a class="file-link" href="<c:url value='/cloud/${file.value.toString()}/'><c:param name='action' value='download' /><c:param name='currentPath' value='${pageContext.request.pathInfo}' /></c:url>">${file.value.toString()}</a>
                    </c:when>
                    <c:otherwise>
                        <a class="file-link" href="<c:url value='/cloud/${file.value.toString()}'><c:param name='action' value='download' /><c:param name='currentPath' value='${pageContext.request.pathInfo}' /></c:url>">${file.value.toString()}</a>
                    </c:otherwise>
                </c:choose>
            </span>
        </li>
    </c:forEach>
</ul>
</div>

<div class="footer">
    <small>© Т.А.В. - 2023</small>
</div>
</body>
</html>
<%!
    public long getFreeDiskSpace() {
        String uploadPath = "F:/";
        File disk = new File(uploadPath);
        long freeSpaceInBytes = disk.getFreeSpace();
        long freeSpaceInGB = freeSpaceInBytes / (1024 * 1024 * 1024);
        return freeSpaceInGB;
    }

    public long getTotalDiskSpace() {
        String uploadPath = "F:/";
        File disk = new File(uploadPath);
        long totalSpaceInBytes = disk.getTotalSpace();
        long totalSpaceInGB = totalSpaceInBytes / (1024 * 1024 * 1024);
        return totalSpaceInGB;
    }
public List<Map<String, String>> generateBreadcrumb(String currentPath) {
    List<Map<String, String>> breadcrumb = new ArrayList<>();
    String[] pathSegments = currentPath.split("/");
    boolean startGenerating = false; // Флаг для начала генерации хлебных крошек
    String fullPath = "";

    for (String segment : pathSegments) {
        if (!segment.isEmpty()) {
            fullPath += "/" + segment;

            // Начать генерацию хлебных крошек, когда достигнут путь "cloud"
            if (segment.equalsIgnoreCase("cloud")) {
                startGenerating = true;
                Map<String, String> crumb = new HashMap<>();
            }

            if (startGenerating) {
                Map<String, String> crumb = new HashMap<>();
                if (!segment.equals("cloud")){
                crumb.put("name", segment);
                crumb.put("path", fullPath);
                breadcrumb.add(crumb);
                }
            }
        }
    }
    return breadcrumb;
}

%>