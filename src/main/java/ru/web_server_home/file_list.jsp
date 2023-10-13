<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList, java.util.HashMap" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Облако</title>
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
        .upload-form {
            display: flex;
            flex-direction: column; /* Stacked elements on mobile */
            gap: 10px;
            align-items: center;
        }
        .upload-form input[type="file"] {
            width: 100%; /* Full width input */
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .upload-form input[type="submit"] {
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px 20px;
            cursor: pointer;
            width: auto; /* Auto width for button */
        }
        .upload-form input[type="submit"]:hover {
            background-color: #0056b3;
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
        .file-links {
            text-decoration: none;
            color: #007bff;
        }
        .file-links:hover {
            text-decoration: underline;
        }
        .file-link {
            background-color: #007bff; /* Синий цвет для кнопки "Удалить и переименовать" */
            color: white;
            border: none;
            border-radius: 4px;
            padding: 3px 8px;
            cursor: pointer;
                    }

        .file-link:hover {
             background-color: #0056b3; /* Цвет при наведении на кнопку "Удалить и переименовать" */
                    }
        .convert-photo-button {
             background-color: #007bff; /* Синий цвет для кнопки "Конвертировать" */
             color: white;
             border: none;
             border-radius: 4px;
             padding: 3px 8px;
             cursor: pointer;
                                   }

        .convert-photo-button:hover {
             background-color: #0056b3; /* Цвет при наведении на кнопку "Конвертировать" */
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

               .create-folder-button {
                   background-color: #007bff; /* Синий цвет для кнопки "Создать папку" */
                   color: white;
                   border: none;
                   border-radius: 4px;
                   padding: 10px 20px;
                   cursor: pointer;
               }

               .create-folder-button:hover {
                   background-color: #0056b3; /* Цвет при наведении на кнопку "Создать папку" */
               }
               .create-folder-form input[type="text"] {
                                  width: 30%;
                                  padding: 8px;
                                  border: 1px solid #ccc;
                                  border-radius: 4px;
                              }
               .find-folder-file-form input[type="text"] {
                                                 width: 87%;
                                                 padding: 8px;
                                                 border: 1px solid #ccc;
                                                 border-radius: 4px;
                                             }
               .search-button {
                   background-color: #007bff;
                   color: white;
                   border: none;
                   border-radius: 4px;
                   padding: 10px 20px;
                   cursor: pointer;
               }

               .search-button:hover {
                   background-color: #0056b3;
               }
    </style>
<script>
 function showRenameDialog(oldFileName) {
     const renameDialog = document.getElementById("renameDialog");
     const newFileNameInput = document.getElementById("newFileName");
     const oldFileNameInput = document.getElementById("oldFileName"); // Получаем элемент скрытого поля oldFileName
     newFileNameInput.value = oldFileName; // Заполняем поле нового имени текущим именем файла
     oldFileNameInput.value = oldFileName; // Заполняем скрытое поле старого имени
     renameDialog.style.display = "block";
 }

    function cancelRename() {
        const renameDialog = document.getElementById("renameDialog");
        renameDialog.style.display = "none";
    }
</script>
</head>
<body>
<div id="renameDialog" class="rename-dialog">
    <div class="dialog-content">
        <h2>Изменение имени</h2>
        <form id="renameForm" action="${pageContext.request.contextPath}/cloud/" method="post" enctype="multipart/form-data"> <!-- Добавлен атрибут action -->
            <label for="newFileName">Новое имя:</label>
            <input type="text" id="newFileName" name="newFileName" required>
            <input type="hidden" name="action" value="rename">
            <input type="hidden" id="oldFileName" name="oldFileName">
            <div class="button-group">
                <button class="btn btn-primary" type="submit">Подтвердить</button>
                <button class="btn btn-secondary" type="button" onclick="cancelRename()">Отмена</button>
            </div>
        </form>
    </div>
</div>
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
            <div class="find-folder-file-form">
                         <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/cloud/" accept-charset="UTF-8">
                             <div class="input-group"> <!-- Добавлен контейнер для поля ввода и кнопки -->
                                 <input type="text" name="findName" placeholder="Поиск по облаку" required>
                                 <button type="submit" class="search-button">Поиск</button> <!-- Кнопка поиска -->
                             </div>
                             <input type="hidden" name="action" value="findFolderFile">
                             <input type="hidden" name="currentPath" value="${pageContext.request.pathInfo}">
                         </form>
                     </div>
                     &nbsp;
<form class="upload-form" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/cloud/">
    <input type="file" name="files" multiple="multiple">
    <input type="hidden" name="action" value="loader">
    <input type="hidden" name="currentPath" value="${pageContext.request.pathInfo}">
    <input type="submit" value="Загрузка">
</form>
<div class="breadcrumb">
<a href="${pageContext.request.contextPath}/cloud/">Главная</a>
        <%
            List<Map<String, String>> breadcrumbList = generateBreadcrumb(request.getAttribute("currentPath").toString());
            request.setAttribute("breadcrumb", breadcrumbList);
        %>
        <c:forEach var="crumb" items="${breadcrumb}" varStatus="status">
            <span>&gt;</span>
            <c:choose>
                <c:when test="${status.last}">
                    ${crumb.name}
                </c:when>
                <c:otherwise>
                    <a href="${crumb.path}/">${crumb.name}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>
   <p>Свободное место на диске: <%= freeSpace %> ГБ из <%= totalSpace %> ГБ (<%= (int) usedPercentage %>%)  <%= battery.toString() %></p>
    <div class="create-folder-form">
        <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/cloud/" accept-charset="UTF-8">
            <div class="input-group"> <!-- Добавлен контейнер для поля ввода и кнопки -->
                <input type="text" name="newFolderNameCreate" placeholder="Имя новой папки" required>
                <button type="submit" class="create-folder-button">Создать папку</button> <!-- Кнопка "Создать папку" -->
            </div>
            <input type="hidden" name="action" value="createFolder">
            <input type="hidden" name="currentPath" value="${pageContext.request.pathInfo}">
        </form>
    </div>
<ul class="file-list">
    <c:forEach var="file" items="${files}">
        <li class="file-item">
            <span class="file-icon">
                <!-- Иконка файла или папки -->
                <i class="<c:choose>
                            <c:when test='${file.directory}'>fas fa-folder'</c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test='${file.name.toLowerCase().endsWith(".jpg") or file.name.toLowerCase().endsWith(".png") or file.name.toLowerCase().endsWith(".jpeg")}'>fas fa-image'</c:when>
                                    <c:when test='${file.name.toLowerCase().endsWith(".txt")}'>far fa-file-alt'</c:when>
                                    <c:when test='${file.name.toLowerCase().endsWith(".pdf")}'>far fa-file-pdf'</c:when>
                                    <c:when test='${file.name.toLowerCase().endsWith(".doc") or file.name.toLowerCase().endsWith(".docx")}'>far fa-file-word'</c:when>
                                    <c:when test='${file.name.toLowerCase().endsWith(".mp4") or file.name.toLowerCase().endsWith(".avi") or file.name.toLowerCase().endsWith(".mkv")}'>far fa-file-video'</c:when>
                                    <c:when test='${file.name.toLowerCase().endsWith(".exe")}'>far fa-file-exe'</c:when>
                                    <c:when test='${file.name.toLowerCase().endsWith(".jar")}'>far fa-file-code'</c:when>
                                    <c:when test='${file.name.toLowerCase().endsWith(".heic")}'>far fa-file-image'</c:when>
                                    <c:when test='${file.directory}'>fas fa-folder'</c:when>
                                    <c:otherwise>far fa-file'</c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>"></i>
            </span>
            <span class="file-preview">
                <!-- Предпросмотр или иконка для файла или папки -->
                <c:choose>
                    <c:when test="${file.name.toLowerCase().endsWith('.jpg') or file.name.toLowerCase().endsWith('.png') or file.name.toLowerCase().endsWith('.jpeg') or file.name.toLowerCase().endsWith('.gif')}">
                        <img class="file-image" src="<c:url value='/cloud/${file.name}'><c:param name='action' value='view' /><c:param name='currentPath' value='${pageContext.request.pathInfo}' /></c:url>" alt="${file.name}" style="max-width: 100px; max-height: 100px;" />
                    </c:when>
                    <c:when test="${file.directory}">
                        <i class="fas fa-folder"></i>
                    </c:when>
                    <c:when test="${file.name.toLowerCase().endsWith('.txt')}">
                        <i class="far fa-file-alt"></i>
                    </c:when>
                    <c:when test="${file.name.toLowerCase().endsWith('.pdf')}">
                        <i class="far fa-file-pdf"></i>
                    </c:when>
                    <c:when test="${file.name.toLowerCase().endsWith('.doc') or file.name.toLowerCase().endsWith('.docx')}">
                        <i class="far fa-file-word"></i>
                    </c:when>
                    <c:when test="${file.name.toLowerCase().endsWith('.mp4') or file.name.toLowerCase().endsWith('.avi') or file.name.toLowerCase().endsWith('.mkv') or file.name.toLowerCase().endsWith('.mov') or file.name.toLowerCase().endsWith('.wmv')}">
                        <i class="far fa-file-video"></i>
                    </c:when>
                    <c:when test="${file.name.toLowerCase().endsWith('.rar') or file.name.toLowerCase().endsWith('.zip')}">
                    <i class="far fa-file-archive"></i>
                    </c:when>
                    <c:when test="${file.name.toLowerCase().endsWith('.jar')}">
                        <i class="far fa-file-code"></i>
                    </c:when>
                     <c:when test="${file.name.toLowerCase().endsWith('.heic')}">
                     <i class="far fa-file-image"></i>
                    </c:when>
                    <c:otherwise>
                        <i class="far fa-file"></i>
                    </c:otherwise>
                </c:choose>
            </span>
            <span class="file-name">
                <!-- Имя файла -->
                &nbsp;
               <c:choose>
                    <c:when test="${file.directory}">
                        <a class="file-links" href="<c:url value='/cloud/${file.name}/'><c:param name='action' value='download' /><c:param name='currentPath' value='${pageContext.request.pathInfo}' /></c:url>">${file.name}</a>
                    </c:when>
                    <c:otherwise>
                        <a class="file-links" href="<c:url value='/cloud/${file.name}'><c:param name='action' value='download' /><c:param name='currentPath' value='${pageContext.request.pathInfo}' /></c:url>">${file.name}</a>
                    </c:otherwise>
                </c:choose>
                <p style="font-size: 10px">Изменено: <%= request.getAttribute("creationDate") %></p>
            </span>
<span class="file-actions">
    <button type="button" class="file-link" onclick="showRenameDialog('${file.name}')">Переименовать</button>
    <c:url var="deleteUrl" value="/cloud/${file.name}">
        <c:param name="action" value="delete" />
    </c:url>
    <button type="button" class="file-link" onclick="location.href='${deleteUrl}'">Удалить</button>
    <c:choose>
            <c:when test="${fn:endsWith(file.name, '.HEIC') or fn:endsWith(file.name, '.heic')}">
            <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/cloud/" accept-charset="UTF-8">
                    <input type="hidden" name="action" value="convert">
                    <input type="hidden" name="fileName" value="${file.name}">
                    <button type="submit" class="convert-photo-button">Конвертировать</button>
                </form>
            </c:when>
        </c:choose>
    </span>
        </li>
    </c:forEach>
</ul>
</div>
<div class="pagination">
    <c:choose>
        <c:when test="${currentPage > 1}">
            <a href="<c:url value=''><c:param name='page' value='${currentPage - 1}' /><c:param name='currentPath' value='${currentPath}' /><c:param name='action' value='download' /></c:url>">Предыдущая</a>
        </c:when>
        <c:otherwise>
            <span class="disabled">Предыдущая</span>
        </c:otherwise>
    </c:choose>

    <span class="current-page">${currentPage}</span>

    <c:choose>
        <c:when test="${files.size() >= 15}">
            <a href="<c:url value=''><c:param name='page' value='${currentPage + 1}' /><c:param name='action' value='download' /></c:url>">Следующая</a>
        </c:when>
        <c:otherwise>
            <span class="disabled">Следующая</span>
        </c:otherwise>
    </c:choose>
</div>

<div class="footer">
    <small>© Т.А.В. - 2023</small>
</div>
</body>
</html>
<%!
    public long getFreeDiskSpace() {
        String uploadPath = "D:/";
        File disk = new File(uploadPath);
        long freeSpaceInBytes = disk.getFreeSpace();
        long freeSpaceInGB = freeSpaceInBytes / (1024 * 1024 * 1024);
        return freeSpaceInGB;
    }

    public long getTotalDiskSpace() {
        String uploadPath = "D:/";
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
