<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    Cookie[] cookies = request.getCookies();
    String username = null;

    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("usuario".equals(cookie.getName())) {
                username = java.net.URLDecoder.decode(cookie.getValue(), "UTF-8");
                break;
            }
        }
    }
    
    // Verificar si el usuario es administrador
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("PerfilServlet");
        return;
    }
%>

<c:set var="idioma" value="${not empty sessionScope.idioma ? sessionScope.idioma : 'es'}" scope="session" />
<fmt:setLocale value="${idioma}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${idioma}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Finalizar Ranking - Escape Room</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- CSS -->
    <link rel="stylesheet" href="css/pages/perfil.css">
    <link rel="stylesheet" href="css/pages/finalizar-ranking.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <a href="index.jsp" class="sidebar-logo">
                	<div class="logo">
                    <img src="img/BILBAOSKP.png" alt="Logo Educación Divertida" width="200" height="150">
                    </div>
                </a>
            </div>
            
            <div class="user-info">
                <div class="user-avatar">
                    <i class="fas fa-user"></i>
                    <span class="user-name">${username}</span>
                </div>
            </div>
            
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="PerfilServlet"><i class="fas fa-tachometer-alt"></i> Perfil</a></li>
                    <li><a href="AdminUsuarios?action=listar"><i class="fas fa-users"></i> Gestionar Usuarios</a></li>
                    <li><a href="AdminUsuarios?action=listarPendientes"><i class="fas fa-user-plus"></i> Centros Pendientes</a></li>
                    <li><a href="AdminUsuarios?action=listarSolicitudesBaja"><i class="fas fa-user-minus"></i> Solicitudes de Baja</a></li>
                    <li><a href="finalizar-ranking.jsp" class="active"><i class="fas fa-flag-checkered"></i> Finalizar Ranking</a></li>
                </ul>
            </nav>
        </aside>

        <!-- Contenido principal -->
        <main class="main-content">
            <!-- Header superior -->
            <header class="top-header">
                <div class="breadcrumb">
                    <a href="index.jsp">Inicio</a>
                    <span>/</span>
                    <a href="PerfilServlet">Perfil</a>
                    <span>/</span>
                    <span>Finalizar Ranking</span>
                </div>
                
                <div class="header-actions">
                    <div class="language-selector">
                        <i class="fas fa-globe"></i>
                        <select onchange="cambiarIdioma(this.value)">
                            <option value="es" ${idioma == 'es' ? 'selected' : ''}>Español</option>
                            <option value="en" ${idioma == 'en' ? 'selected' : ''}>English</option>
                            <option value="eu" ${idioma == 'eu' ? 'selected' : ''}>Euskera</option>
                        </select>
                    </div>
                    <form action="CerrarSesionServlet" method="post" style="display: inline;">
                        <button type="submit" class="btn-logout">
                            <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                        </button>
                    </form>
                </div>
            </header>

            <!-- Área de contenido -->
            <div class="content-area">
                <h1 class="page-title">Finalizar Ranking Actual</h1>

                <div class="content-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-exclamation-triangle"></i> Confirmación de Finalización
                        </h2>
                    </div>
                    <div class="card-body">
                        <div class="warning-alert">
                            <div class="warning-icon">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="warning-content">
                                <h3>¡Atención!</h3>
                                <p>Esta acción no se puede deshacer. Asegúrate de que realmente deseas finalizar el ranking actual.</p>
                            </div>
                        </div>
                        
                        <div class="info-section">
                            <h3>¿Qué sucederá al finalizar el ranking?</h3>
                            <ul class="action-list">
                                <li>
                                    <i class="fas fa-archive"></i>
                                    <span>Se guardará todos los datos actuales del ranking en un histórico</span>
                                </li>
                                <li>
                                    <i class="fas fa-refresh"></i>
                                    <span>Se reiniciará el ranking actual, eliminando todas las puntuaciones</span>
                                </li>
                                <li>
                                    <i class="fas fa-users"></i>
                                    <span>Los usuarios podrán comenzar a acumular puntos desde cero</span>
                                </li>
                            </ul>
                        </div>
                        
                        <div class="form-actions">
                            <a href="PerfilServlet" class="btn-secondary">
                                <i class="fas fa-arrow-left"></i> Cancelar
                            </a>
                            <form action="FinalizarRankingServlet" method="post" style="display: inline;">
                                <button type="submit" class="btn-danger" onclick="return confirm('¿Estás completamente seguro de que deseas finalizar el ranking actual? Esta acción NO se puede deshacer.');">
                                    <i class="fas fa-flag-checkered"></i> Confirmar Finalización
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <footer class="footer">
                Copyright © 2025 <a href="#">Escape Room Educativo</a>. Todos los derechos reservados.
                <span style="float: right;">Versión 1.0</span>
            </footer>
        </main>
    </div>

    <script>
        function cambiarIdioma(idioma) {
            window.location.href = 'CambiarIdioma?idioma=' + idioma + '&redirect=finalizar-ranking.jsp';
        }
    </script>
</body>
</html>
