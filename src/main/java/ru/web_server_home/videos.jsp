<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList, java.util.HashMap" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="ru.web_server_home.FileServlet" %>
<%@ page import="com.google.common.collect.Multimap" %>
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
            margin-left: 280px; /* Левый отступ, который сдвинет содержимое влево */
            margin-right: auto; /* Правый отступ для центрирования */
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
        .video-playlist {
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
        .video-playlist {
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
        .video-playlist {
            text-decoration: none;
            color: #007bff;
        }
        .video-playlist:hover {
            text-decoration: underline;
        }
        .convert-photo-button {
             background-color: #007bff; /* Синий цвет для кнопки "Конвертировать" */
             color: white;
             border: none;
             border-radius: 4px;
             padding: 3px 8px;
             cursor: pointer;
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
               .weather-widget {
                   position: fixed; /* Зафиксированное позиционирование */
                   top: 20px; /* Отступ от верхней грани окна браузера */
                   left: 10px; /* Отступ от правой грани окна браузера */
                   font-size: 12px;
                   color: #888;
                   background-color: #f8f8f8;
                   padding: 5px 10px;
                   border-radius: 5px;
                   box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.1);
               }
               .video-player-container {
                                                          font-size: 15px;
                                                          color: #888;

                                                          padding: 5px 3px;
                                                          border-radius: 5px;
                                                          box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.1);
                                                      }
               .scroll-to-top {
                                                                 position: fixed;
                                                                 bottom: 60px;
                                                                 right: 20px;
                                                                 background-color: #007bff;
                                                                 color: #fff;
                                                                 border: none;
                                                                 border-radius: 50%;
                                                                 width: 40px;
                                                                 height: 40px;
                                                                 font-size: 24px;
                                                                 text-align: center;
                                                                 line-height: 40px;
                                                                 cursor: pointer;
                                                                 display: none;
                                                             }

                                                             .scroll-to-top:hover {
                                                                 background-color: #0056b3;
                                                             }
                                                             #video-player {
                                                                 width: 100%; /* Задайте желаемую ширину видео-плеера, например, 100% */
                                                                 height: auto; /* Автоматическая высота для сохранения соотношения сторон */
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
<div class="scroll-to-top">
    <i class="fas fa-arrow-up"></i>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var scrollToTop = document.querySelector(".scroll-to-top");

        window.addEventListener("scroll", function() {
            if (window.pageYOffset > 100) {
                scrollToTop.style.display = "block";
            } else {
                scrollToTop.style.display = "none";
            }
        });

        scrollToTop.addEventListener("click", function() {
            window.scrollTo({
                top: 0,
                behavior: "smooth"
            });
        });
    });
</script>
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
<div class="breadcrumb">
<a href="${pageContext.request.contextPath}/cloud/">Главная</a>
</div>
   <p>Свободное место на диске: <%= freeSpace %> ГБ из <%= totalSpace %> ГБ (<%= (int) usedPercentage %>%)  <%= battery.toString() %></p>
</div>

    <h2>Видео-плеер</h2>
    <video id="video-player" controls>
        <!-- Место для видео -->
    </video>
    <div class="video-playlist">
        <!-- Список видео для выбора -->
        <ul id="video-list">
            <c:forEach var="entry" items="${FileServlet.getStructureCloudPref('D:/cloud')}" varStatus="loop">
                <li data-src="${entry.value}">Видео ${entry.key}</li>
            </c:forEach>
        </ul>
        <div class="pagination">
            <button id="prevPage">Предыдущая</button>
            <button id="nextPage">Следующая</button>
        </div>
    </div>

<script>
    const videoPlayer = document.getElementById("video-player");
    const videoList = document.getElementById("video-list");
    const prevPageButton = document.getElementById("prevPage");
    const nextPageButton = document.getElementById("nextPage");

    // Настройка пагинации
    const videosPerPage = 10;
    let currentPage = 1;
    let totalVideos = ${FileServlet.getStructureCloudPref('D:/cloud').size()};
    let totalPages = Math.ceil(totalVideos / videosPerPage);

    function showVideosForPage(page) {
        const start = (page - 1) * videosPerPage;
        const end = start + videosPerPage;
        const videoItems = videoList.children;

        for (let i = 0; i < totalVideos; i++) {
            if (i >= start && i < end) {
                videoItems[i].style.display = "block";
            } else {
                videoItems[i].style.display = "none";
            }
        }
    }
    function updatePaginationButtons() {
        prevPageButton.disabled = currentPage === 1;
        nextPageButton.disabled = currentPage === totalPages;
    }
    // Показать видео для первой страницы
    showVideosForPage(currentPage);
    updatePaginationButtons();

    // Обработчик клика по элементам списка видео
    videoList.addEventListener("click", function (e) {
        if (e.target.tagName === "LI") {
            const videoSrc = e.target.getAttribute("data-src");
            videoPlayer.src = videoSrc;
            videoPlayer.load();
            videoPlayer.play();
        }
    });

    // Обработчик нажатия на кнопку "Предыдущая"
    prevPageButton.addEventListener("click", function () {
        if (currentPage > 1) {
            currentPage--;
            showVideosForPage(currentPage);
            updatePaginationButtons();
        }
    });

    // Обработчик нажатия на кнопку "Следующая"
    nextPageButton.addEventListener("click", function () {
        if (currentPage < totalPages) {
            currentPage++;
            showVideosForPage(currentPage);
            updatePaginationButtons();
        }
    });
</script>
<!-- Погодный информер будет размещен справа вне зоны с файлами -->
<div class="weather-widget">
<!-- Gismeteo informer START -->
<link rel="stylesheet" type="text/css" href="https://ost1.gismeteo.ru/assets/flat-ui/legacy/css/informer.min.css">
<div id="gsInformerID-umA38j1kmiOUMV" class="gsInformer" style="width:243px;height:460px">
    <div class="gsIContent">
        <div id="cityLink">
            <a href="https://www.gismeteo.ru/weather-moscow-4368/" target="_blank" title="Погода в Москве">
                <img src="https://ost1.gismeteo.ru/assets/flat-ui/img/gisloader.svg" width="24" height="24" alt="Погода в Москве">
            </a>
            </div>
        <div class="gsLinks">
            <table>
                <tr>
                    <td>
                        <div class="leftCol">
                            <a href="https://www.gismeteo.ru/" target="_blank" title="Погода">
                                <img alt="Погода" src="https://ost1.gismeteo.ru/assets/flat-ui/img/logo-mini2.png" align="middle" border="0" width="11" height="16" />
                                <img src="https://ost1.gismeteo.ru/assets/flat-ui/img/informer/gismeteo.svg" border="0" align="middle" style="left: 5px; top:1px">
                            </a>
                            </div>
                            <div class="rightCol">
                                <a href="https://www.gismeteo.ru/" target="_blank" title="Погода в Москве на 2 недели">
                                    <img src="https://ost1.gismeteo.ru/assets/flat-ui/img/informer/forecast-2weeks.ru.svg" border="0" align="middle" style="top:auto" alt="Погода в Москве на 2 недели">
                                </a>
                            </div>
                        </td>
                </tr>
            </table>
        </div>
    </div>
</div>
<script async src="https://www.gismeteo.ru/api/informer/getinformer/?hash=umA38j1kmiOUMV"></script>
<!-- Gismeteo informer END -->
</div>
<!-- Погодный информер размещен справа вне зоны с файлами -->
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