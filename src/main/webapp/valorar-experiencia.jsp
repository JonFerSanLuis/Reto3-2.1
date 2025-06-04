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
%>

<c:set var="idioma" value="${not empty sessionScope.idioma ? sessionScope.idioma : 'es'}" scope="session" />
<fmt:setLocale value="${idioma}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${idioma}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Valorar Experiencia - Escape Room</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- CSS -->
    <link rel="stylesheet" href="css/pages/perfil.css">
    <link rel="stylesheet" href="css/pages/valorar-experiencia.css">
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
                    <c:if test="${sessionScope.isAdmin}">
                        <li><a href="PerfilServlet" class="active"><i class="fas fa-tachometer-alt"></i> Perfil</a></li>
                        <li><a href="AdminUsuarios?action=listar"><i class="fas fa-users"></i> Gestionar Usuarios</a></li>
                        <li><a href="AdminUsuarios?action=listarPendientes"><i class="fas fa-user-plus"></i> Centros Pendientes</a></li>
                        <li><a href="AdminUsuarios?action=listarSolicitudesBaja"><i class="fas fa-user-minus"></i> Solicitudes de Baja</a></li>
                        <li><a href="finalizar-ranking.jsp"><i class="fas fa-trophy"></i> Finalizar Ranking</a></li>                        
                    </c:if>
                    <c:if test="${!sessionScope.isAdmin}">
                        <li><a href="PerfilServlet" class="active"><i class="fas fa-tachometer-alt"></i> Perfil</a></li>
                        <li><a href="Ranking"><i class="fas fa-trophy"></i> Ranking</a></li>
                        <li><a href="comprarCupon.jsp"><i class="fas fa-shopping-cart"></i> Comprar Cupones</a></li>
                        <li><a href="CompraServlet"><i class="fas fa-eye"></i>Ver Compras</a></li>
                        <li><a href="organizarPartida.jsp"><i class="fas fa-calendar-plus"></i>Organizar Partida</a></li>                        
                        <li><a href="valorar-experiencia.jsp"><i class="fas fa-star"></i> Valorar Experiencia</a></li>
                    </c:if>
                    <li><a href="private/descargarJuego.jsp"><i class="fas fa-download"></i> Descargar Juego</a></li>
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
                    <span>Valorar Experiencia</span>
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
                <h1 class="page-title">Valorar Experiencia</h1>

                <!-- Mostrar mensaje de éxito o error -->
                <c:if test="${not empty mensaje}">
                    <div class="alert ${tipoMensaje == 'success' ? 'alert-success' : 'alert-danger'}">
                        <c:choose>
                            <c:when test="${tipoMensaje == 'success'}">
                                <i class="fas fa-check-circle"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-exclamation-triangle"></i>
                            </c:otherwise>
                        </c:choose>
                        ${mensaje}
                    </div>
                </c:if>

                <div class="content-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-star"></i> Tu Valoración
                        </h2>
                    </div>
                    <div class="card-body">
                        <p class="section-description" style="text-align: center; margin-bottom: 20px;">
                            Comparte tu experiencia y ayuda a otros jugadores
                        </p>

                        <form action="ValoracionServlet" method="post" class="form-grid">
                            <!-- Puntuación general -->
                            <div class="form-group">
                                <label for="puntuacion">Puntuación General *</label>
                                <div class="rating-stars">
                                    <input type="radio" id="star5" name="puntuacion" value="5" required>
                                    <label for="star5" class="star">★</label>
                                    <input type="radio" id="star4" name="puntuacion" value="4">
                                    <label for="star4" class="star">★</label>
                                    <input type="radio" id="star3" name="puntuacion" value="3">
                                    <label for="star3" class="star">★</label>
                                    <input type="radio" id="star2" name="puntuacion" value="2">
                                    <label for="star2" class="star">★</label>
                                    <input type="radio" id="star1" name="puntuacion" value="1">
                                    <label for="star1" class="star">★</label>
                                </div>
                                <div class="rating-text">
                                    <span class="rating-description">Selecciona tu puntuación</span>
                                </div>
                            </div>

                            <!-- Aspectos específicos -->
                            <div class="aspects-grid">
                                <div class="form-group">
                                    <label for="dificultad">
                                        <i class="fas fa-puzzle-piece"></i> Dificultad
                                    </label>
                                    <select name="dificultad" id="dificultad" class="form-control" required>
                                        <option value="">Seleccionar...</option>
                                        <option value="muy facil">Muy Fácil</option>
                                        <option value="facil">Fácil</option>
                                        <option value="medio">Medio</option>
                                        <option value="dificil">Difícil</option>
                                        <option value="muy dificil">Muy Difícil</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="recomendacion">
                                        <i class="fas fa-thumbs-up"></i> ¿Lo recomendarías?
                                    </label>
                                    <select name="recomendacion" id="recomendacion" class="form-control" required>
                                        <option value="">Seleccionar...</option>
                                        <option value="si">Sí, definitivamente</option>
                                        <option value="tal vez">Tal vez</option>
                                        <option value="no">No lo recomendaría</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Comentario -->
                            <div class="form-group">
                                <label for="comentario">
                                    <i class="fas fa-comment"></i> Comentario
                                </label>
                                <textarea name="comentario" id="comentario" class="form-control" 
                                          placeholder="Cuéntanos tu experiencia... ¿Qué te gustó más? ¿Qué mejorarías? (Opcional)"></textarea>
                            </div>

                            <!-- Botones -->
                            <div class="form-actions">
                                <a href="PerfilServlet" class="btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Volver
                                </a>
                                <button type="submit" class="btn-primary">
                                    <i class="fas fa-paper-plane"></i> Enviar Valoración
                                </button>
                            </div>
                        </form>
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
            window.location.href = 'CambiarIdioma?idioma=' + idioma + '&redirect=valorar-experiencia.jsp';
        }
        
        // Auto-ocultar mensaje después de 5 segundos
        document.addEventListener('DOMContentLoaded', function() {
            const mensaje = document.querySelector('.alert');
            if (mensaje) {
                setTimeout(function() {
                    mensaje.style.opacity = '0';
                    setTimeout(function() {
                        mensaje.style.display = 'none';
                    }, 300);
                }, 5000);
            }
        });
    </script>
</body>
</html>
