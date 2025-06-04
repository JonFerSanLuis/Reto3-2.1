<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
    <title><fmt:message key="admin.editarUsuario" /></title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- CSS -->
    <link rel="stylesheet" href="css/pages/perfil.css">
    <link rel="stylesheet" href="css/pages/admin-editar-usuario.css">
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
                    <li><a href="AdminUsuarios?action=listar" class="active"><i class="fas fa-users"></i> Gestionar Usuarios</a></li>
                    <li><a href="AdminUsuarios?action=listarPendientes"><i class="fas fa-user-plus"></i> Centros Pendientes</a></li>
                    <li><a href="AdminUsuarios?action=listarSolicitudesBaja"><i class="fas fa-user-minus"></i> Solicitudes de Baja</a></li>
                    <li><a href="finalizar-ranking.jsp"><i class="fas fa-flag-checkered"></i> Finalizar Ranking</a></li>                                            
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
                    <a href="AdminUsuarios?action=listar">Gestionar Usuarios</a>
                    <span>/</span>
                    <span>Editar Usuario</span>
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
                <h1 class="page-title"><fmt:message key="admin.editarUsuario" /></h1>

                <!-- Mensajes de éxito o error -->
                <c:if test="${not empty sessionScope.mensaje}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${sessionScope.mensaje}
                        <c:remove var="mensaje" scope="session" />
                    </div>
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle"></i> ${sessionScope.error}
                        <c:remove var="error" scope="session" />
                    </div>
                </c:if>

                <div class="content-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-user-edit"></i> <fmt:message key="admin.editarUsuario" />
                        </h2>
                    </div>
                    <div class="card-body">
                        <form class="edit-form" action="AdminUsuarios" method="post">
                            <input type="hidden" name="action" value="actualizar">
                            <input type="hidden" name="id" value="${usuario.idSuscriptor}">

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="username"><i class="fas fa-user"></i> <fmt:message key="admin.nombre" /></label>
                                    <input type="text" id="username" name="username" value="${usuario.username}" required>
                                </div>
                                <div class="form-group">
                                    <label for="correo"><i class="fas fa-envelope"></i> <fmt:message key="admin.email" /></label>
                                    <input type="email" id="correo" name="correo" value="${usuario.correo}" required>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="tipo"><i class="fas fa-tag"></i> <fmt:message key="admin.tipo" /></label>
                                    <select id="tipo" name="tipo" required>
                                        <option value="ordinario" ${usuario.tipo == 'ordinario' ? 'selected' : ''}>
                                            <fmt:message key="admin.tipoOrdinario" />
                                        </option>
                                        <option value="centro" ${usuario.tipo == 'centro' ? 'selected' : ''}>
                                            <fmt:message key="admin.tipoCentro" />
                                        </option>
                                        <option value="admin" ${usuario.tipo == 'admin' ? 'selected' : ''}>
                                            <fmt:message key="admin.tipoAdmin" />
                                        </option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="estado"><i class="fas fa-circle"></i> <fmt:message key="admin.estado" /></label>
                                    <select id="estado" name="estado" required>
                                        <option value="activo" ${usuario.estado == 'activo' ? 'selected' : ''}>
                                            <fmt:message key="admin.estadoActivo" />
                                        </option>
                                        <option value="inactivo" ${usuario.estado == 'inactivo' ? 'selected' : ''}>
                                            <fmt:message key="admin.estadoInactivo" />
                                        </option>
                                        <option value="pendiente" ${usuario.estado == 'pendiente' ? 'selected' : ''}>
                                            <fmt:message key="admin.estadoPendiente" />
                                        </option>
                                        <option value="suspendido" ${usuario.estado == 'suspendido' ? 'selected' : ''}>
                                            <fmt:message key="admin.estadoSuspendido" />
                                        </option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="edad"><i class="fas fa-birthday-cake"></i> <fmt:message key="admin.edad" /></label>
                                    <input type="number" id="edad" name="edad" value="${usuario.edad}" min="0">
                                </div>
                                <div class="form-group">
                                    <label for="fecha-alta"><i class="fas fa-calendar-alt"></i> <fmt:message key="admin.fechaAlta" /></label>
                                    <input type="text" id="fecha-alta" value="<fmt:formatDate value="${usuario.fechaAlta}" pattern="dd/MM/yyyy" />" disabled>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="password"><i class="fas fa-lock"></i> <fmt:message key="admin.nuevaPassword" /></label>
                                <input type="password" id="password" name="password" placeholder="Dejar en blanco para mantener la actual">
                                <small class="form-text">Solo completa este campo si deseas cambiar la contraseña</small>
                            </div>

                            <div class="form-actions">
                                <a href="AdminUsuarios?action=listar" class="btn-secondary">
                                    <i class="fas fa-arrow-left"></i> <fmt:message key="admin.volver" />
                                </a>
                                <button type="submit" class="btn-primary">
                                    <i class="fas fa-save"></i> <fmt:message key="admin.guardarCambios" />
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
            window.location.href = 'CambiarIdioma?idioma=' + idioma + '&redirect=AdminUsuarios?action=editar&id=${usuario.idSuscriptor}';
        }

        // Validación del formulario
        document.querySelector('.edit-form').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const correo = document.getElementById('correo').value.trim();

            if (!username) {
                alert('El nombre de usuario es obligatorio');
                e.preventDefault();
                return;
            }

            if (!correo) {
                alert('El correo electrónico es obligatorio');
                e.preventDefault();
                return;
            }

            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(correo)) {
                alert('Por favor, introduce un correo electrónico válido');
                e.preventDefault();
                return;
            }
        });
    </script>
</body>
</html>
