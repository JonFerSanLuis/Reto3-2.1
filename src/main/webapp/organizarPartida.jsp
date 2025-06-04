<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    HttpSession sesion = request.getSession();
    com.bilbaoskp.model.Centro centro = (com.bilbaoskp.model.Centro) sesion.getAttribute("centro");
    request.setAttribute("centro", centro);
    
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

<c:set var="idioma"
    value="${not empty sessionScope.idioma ? sessionScope.idioma : 'es'}"
    scope="session" />
<fmt:setLocale value="${idioma}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${idioma}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Organizar Partida - Escape Room</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- CSS -->
    <link rel="stylesheet" href="css/pages/perfil.css">
    <link rel="stylesheet" href="css/pages/organizarPartida.css">
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
                    <span>Organizar Partida</span>
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
                <h1 class="page-title">Organizar Partida</h1>

                <!-- Mensajes de éxito o error -->
                <c:if test="${not empty sessionScope.mensaje}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${sessionScope.mensaje}
                        <c:remove var="mensaje" scope="session" />
                    </div>
                </c:if>
                <c:if test="${not empty sessionScope.error || not empty errorCupones}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle"></i> ${not empty sessionScope.error ? sessionScope.error : errorCupones}
                        <c:remove var="error" scope="session" />
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${empty cookie.tipo || cookie.tipo.value != 'centro' || empty cookie.usuario}">
                        <div class="content-card">
                            <div class="card-header">
                                <h2 class="card-title">
                                    <i class="fas fa-exclamation-circle"></i> Acceso Restringido
                                </h2>
                            </div>
                            <div class="card-body">
                                <div class="empty-state">
                                    <i class="fas fa-lock"></i>
                                    <h3>Acceso solo para centros educativos</h3>
                                    <p>Esta funcionalidad está disponible únicamente para centros educativos registrados.</p>
                                    <a href="PerfilServlet" class="btn btn-primary" style="margin-top: 20px;">
                                        <i class="fas fa-arrow-left"></i> Volver al Dashboard
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="content-card">
                            <div class="card-header">
                                <h2 class="card-title">
                                    <i class="fas fa-gamepad"></i> Escape contra el Acoso y Ciberbullying
                                </h2>
                            </div>
                            <div class="card-body">
                                <form action="ProcesarPartidaServlet" method="post" class="form-grid">
                                    <div class="form-group">
                                        <label for="fecha">
                                            <i class="fas fa-calendar"></i> Fecha de activación:
                                        </label>
                                        <input type="date" id="fecha" name="fechaActivacion" class="form-control" required />
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="nombreClase">
                                            <i class="fas fa-chalkboard"></i> Nombre de la clase:
                                        </label>
                                        <input type="text" id="nombreClase" name="nombreClase" maxlength="100" class="form-control" required />
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="cantidad">
                                            <i class="fas fa-users"></i> Cantidad de participantes:
                                        </label>
                                        <input type="number" id="cantidad" name="cantidad" min="1" class="form-control" required />
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="idioma">
                                            <i class="fas fa-language"></i> Idioma:
                                        </label>
                                        <select id="idioma" name="idioma" class="form-control">
                                            <option value="es">Español</option>
                                            <option value="en">Inglés</option>
                                            <option value="eu">Euskera</option>
                                        </select>
                                    </div>
                                    
                                    <div class="form-actions">
                                        <a href="PerfilServlet" class="btn-secondary">
                                            <i class="fas fa-arrow-left"></i> Cancelar
                                        </a>
                                        <button type="submit" class="btn-primary">
                                            <i class="fas fa-key"></i> Generar Código de Acceso
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
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
            window.location.href = 'CambiarIdioma?idioma=' + idioma + '&redirect=organizarPartida.jsp';
        }
        
        // Establecer fecha mínima como hoy
        document.addEventListener('DOMContentLoaded', function() {
            const fechaInput = document.getElementById('fecha');
            if (fechaInput) {
                const hoy = new Date();
                const yyyy = hoy.getFullYear();
                const mm = String(hoy.getMonth() + 1).padStart(2, '0');
                const dd = String(hoy.getDate()).padStart(2, '0');
                const fechaHoy = `${yyyy}-${mm}-${dd}`;
                
                fechaInput.setAttribute('min', fechaHoy);
                fechaInput.value = fechaHoy;
            }
        });
    </script>
</body>
</html>
