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
                   float: right; /* Помещаем элементы справа */
                   margin-left: 10px;
                   display: flex;
                   align-items: center; /* Выравниваем элементы по вертикальному центру */
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

                       .pagination a, .pagination button {
                           padding: 8px 12px;
                           margin: 0 5px;
                           text-align: center;
                           text-decoration: none;
                           border: 1px solid #007bff; /* Измените цвет границы для активных элементов */
                           border-radius: 3px;
                           cursor: pointer;
                           color: #007bff; /* Измените цвет текста для активных элементов */
                           transition: background-color 0.3s, color 0.3s;
                       }

                       .pagination a:hover, .pagination button:hover {
                           background-color: #f2f2f2;
                       }

                       .pagination .current-page {
                           background-color: #007bff;
                           color: white;
                           border: 1px solid #007bff;
                       }

                       .pagination button:disabled {
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
                                                             .video-player-container {
                                                            position: fixed; /* Зафиксированное позиционирование */
                                                           top: 20px; /* Отступ от верхней грани окна браузера */
                                                          right: 10px; /* Отступ от правой грани окна браузера */
                                                          font-size: 15px;

                                                          background-color: #f8f8f8;
                                                          padding: 5px 3px;
                                                          border-radius: 5px;
                                                           width: 260px; /* Установите желаемую ширину здесь */
                                                           box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.1);
                                                                            }
                                                                        /* Ваш стиль для ссылки */
                                                                .link-style {
                                                                color: #0073e6; /* Цвет текста ссылки */
                                                               text-decoration: none; /* Убирает подчеркивание */
                                                                 font-weight: bold; /* Жирный шрифт */
                                                                font-size: 18px; /* Размер шрифта */
                                                                /* Дополнительные стили, если необходимо */
                                                              }
                                 .link-style {
                                                                   display: flex;
                                                                   align-items: center;
                                                                   text-decoration: none;
                                                               }

                                                               .icon-video {
                                                                   display: inline-block;
                                                                   width: 75px; /* Ширина иконки */
                                                                   height: 75px; /* Высота иконки */
                                                                   background: url('/home_cloud/free-icon-video-folder-2200068.png') no-repeat;
                                                                   background-size: cover; /* Масштабирование фона */
                                                                   margin-right: 5px; /* Расстояние между иконкой и текстом */
                                                               }

                                                               .link-text {
                                                                   flex: 1; /* Займет всю доступную ширину */
                                                               }
                          .link-home {
                               display: flex;
                               align-items: center;
                               text-decoration: none;
                                }.link-home {
                                 color: #000000; /* Цвет текста ссылки */
                                 text-decoration: none; /* Убирает подчеркивание */
                                 font-weight: bold; /* Жирный шрифт */
                                 font-size: 33px; /* Размер шрифта */
                                 /* Дополнительные стили, если необходимо */
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
        <a class="link-home" href="${pageContext.request.contextPath}/cloud/">
                <span class="link-text">Частное облако</span>
            </a>
            &nbsp;
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
                <p></p>
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
    </div>
</ul>
        <div class="pagination">
            <button id="prevPage" class="pagination-button">Предыдущая</button>
            <span id="currentPage" class="pagination-current-page">1</span>
            <button id="nextPage" class="pagination-button">Следующая</button>
        </div>
<%
String userAgent = request.getHeader("User-Agent");
boolean isMobile = userAgent.toLowerCase().contains("mobile") || userAgent.toLowerCase().contains("android");
String brawser;
if (isMobile) {
    brawser = "Мобильный браузер";
} else {
   brawser = "Десктопный браузер";
}
%>

<div class="video-player-container" id="videoplayercontainer">
<div class="ip">
<p>Ваш IP-адрес: ${ipAdres}</p>
<p><%=brawser%></p>
</div>
    <a class="link-style" href="<c:url value='/cloud'><c:param name='action' value='redirectToVideos' /></c:url>">
        <i class="icon-video"></i>
        <span class="link-text">YouTube-Home</span>
    </a>
    <div class="video-playlist">
        <!-- Список видео для выбора -->
        <ul id="video-list">
            <!-- Здесь можно добавить элементы списка видео -->
        </ul>
    </div>
</div>
<!-- Погодный информер будет размещен справа вне зоны с файлами -->
<div class="weather-widget" id="weatherWidget">
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
<div class="weather-widget" id="otherWidget">
<!-- Gismeteo informer START -->
<link rel="stylesheet" type="text/css" href="https://nst1.gismeteo.ru/assets/flat-ui/legacy/css/informer.min.css">
<div id="gsInformerID-jd1jkgrl4WWTAR" class="gsInformer" style="width:244px;height:460px">
    <div class="gsIContent">
        <div id="cityLink">
            <a href="https://www.gismeteo.ru/weather-moscow-4368/" target="_blank" title="Погода в Москве">
                <img src="https://nst1.gismeteo.ru/assets/flat-ui/img/gisloader.svg" width="24" height="24" alt="Погода в Москве">
            </a>
            </div>
        <div class="gsLinks">
            <table>
                <tr>
                    <td>
                        <div class="leftCol">
                            <a href="https://www.gismeteo.ru/" target="_blank" title="Погода">
                                <img alt="Погода" src="https://nst1.gismeteo.ru/assets/flat-ui/img/logo-mini2.png" align="middle" border="0" width="11" height="16" />
                                <img src="https://nst1.gismeteo.ru/assets/flat-ui/img/informer/gismeteo.svg" border="0" align="middle" style="left: 5px; top:1px">
                            </a>
                            </div>
                            <div class="rightCol">
                                <a href="https://www.gismeteo.ru/" target="_blank" title="Погода в Москве на 2 недели">
                                    <img src="https://nst1.gismeteo.ru/assets/flat-ui/img/informer/forecast-2weeks.ru.svg" border="0" align="middle" style="top:auto" alt="Погода в Москве на 2 недели">
                                </a>
                            </div>
                        </td>
                </tr>
            </table>
        </div>
    </div>
</div>
<script async src="https://www.gismeteo.ru/api/informer/getinformer/?hash=jd1jkgrl4WWTAR"></script>
<!-- Gismeteo informer END -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        function checkDeviceType() {
        // Определите текущий URL и покажите соответствующий информер
            var currentURL = window.location.href;
            var isMobile = "<%=isMobile%>"; // Задаем значение brawser на стороне клиента
               if (currentURL.startsWith("https://192.168.88.47/home_cloud/cloud/")) {
               if (window.innerWidth <= 885 || isMobile === "true") {
               document.getElementById("weatherWidget").style.display = "none";
               document.getElementById("otherWidget").style.display = "none";
               } else {
                       document.getElementById("weatherWidget").style.display = "none";
                       document.getElementById("otherWidget").style.display = "block";
                       }
                   } else {
                   if (window.innerWidth <= 885) {
                   document.getElementById("weatherWidget").style.display = "none";
                   document.getElementById("otherWidget").style.display = "none";
                   } else {
                       document.getElementById("weatherWidget").style.display = "block";
                       document.getElementById("otherWidget").style.display = "none";
                       }
                   }
        }

        window.addEventListener("load", checkDeviceType);
        window.addEventListener("resize", checkDeviceType);

        checkDeviceType(); // Вызовем функцию при загрузке страницы
    });
        document.addEventListener("DOMContentLoaded", function() {
            function checkDeviceType() {
                currentURL = window.location.href;
                   if (window.innerWidth <= 885) {

                           document.getElementById("videoplayercontainer").style.display = "none";
                       } else {

                           document.getElementById("videoplayercontainer").style.display = "block";
                       }
            }

            window.addEventListener("load", checkDeviceType);
            window.addEventListener("resize", checkDeviceType);

            checkDeviceType(); // Вызовем функцию при загрузке страницы
        });

            const videoList = document.querySelector(".file-list");
            const prevPageButton = document.getElementById("prevPage");
            const nextPageButton = document.getElementById("nextPage");

            // Настройка пагинации
            const videosPerPage = 10;
            let currentPage = 1;

            let totalVideos = ${fn:length(files)};
            let totalPages = Math.ceil(totalVideos / videosPerPage);

           // Найдите элемент, в котором будет отображаться текущая страница
           const currentPageElement = document.getElementById("currentPage");

           // Функция для обновления текущей страницы
           function updateCurrentPage() {
               currentPageElement.textContent = currentPage;
           }

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

            // Обработчик нажатия на кнопку "Предыдущая"
            prevPageButton.addEventListener("click", function () {
                if (currentPage > 1) {
                    currentPage--;
                    showVideosForPage(currentPage);
                    updatePaginationButtons();
                    updateCurrentPage(); // Обновляем номер текущей страницы
                }
            });

            // Обработчик нажатия на кнопку "Следующая"
            nextPageButton.addEventListener("click", function () {
                if (currentPage < totalPages) {
                    currentPage++;
                    showVideosForPage(currentPage);
                    updatePaginationButtons();
                    updateCurrentPage(); // Обновляем номер текущей страницы
                }

        });
// Вызов функции для инициализации значения текущей страницы
        updateCurrentPage();
</script>
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
