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
    <title><fmt:message key="admin.titulo" /> - Escape Room</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- CSS -->
    <link rel="stylesheet" href="css/pages/perfil.css">
    <link rel="stylesheet" href="css/pages/admin-usuarios.css">
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
                    <span class="user-name2">${username}</span>
                </div>
            </div>
            
            <nav class="sidebar-nav">
                <ul>
                    <li><a href="PerfilServlet"><i class="fas fa-tachometer-alt"></i> Perfil</a></li>
                    <li><a href="AdminUsuarios?action=listar" 
                        <c:if test="${param.action == 'listar' || empty param.action || (param.action == 'editar')}">class="active"</c:if>>
                        <i class="fas fa-users"></i> Gestionar Usuarios</a></li>
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
                    <span><fmt:message key="admin.titulo" /></span>
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
                <h1 class="page-title"><fmt:message key="admin.titulo" /></h1>

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

                <!-- Sección de búsqueda -->
                <div class="content-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-search"></i> <fmt:message key="admin.buscarUsuario" />
                        </h2>
                    </div>
                    <div class="card-body">
                        <form class="search-form" action="AdminUsuarios" method="get">
                            <div class="search-inputs">
                                <div class="search-field">
                                    <label for="busqueda-id">
                                        <i class="fas fa-hashtag"></i> ID:
                                    </label>
                                    <input type="text" id="busqueda-id" name="id" placeholder="ID" value="${param.id}" class="form-control">
                                </div>
                                <div class="search-field">
                                    <label for="busqueda-nombre">
                                        <i class="fas fa-user"></i> <fmt:message key="admin.nombre" />:
                                    </label>
                                    <input type="text" id="busqueda-nombre" name="nombre" 
                                           placeholder="<fmt:message key="admin.nombre" />" 
                                           value="${param.nombre}" class="form-control">
                                </div>
                            </div>
                            <div class="search-actions">
                                <button type="submit" class="btn-primary">
                                    <i class="fas fa-search"></i> <fmt:message key="admin.buscar" />
                                </button>
                                <a href="AdminUsuarios?action=listar" class="btn-secondary">
                                    <i class="fas fa-refresh"></i> Limpiar
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Tabla de usuarios -->
                <div class="content-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-users"></i> <fmt:message key="admin.listaUsuarios" />
                        </h2>
                    </div>
                    <div class="card-body">
                        <div class="table-container">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-hashtag"></i> <fmt:message key="admin.id" /></th>
                                        <th><i class="fas fa-user"></i> <fmt:message key="admin.nombre" /></th>
                                        <th><i class="fas fa-envelope"></i> <fmt:message key="admin.email" /></th>
                                        <th><i class="fas fa-tag"></i> <fmt:message key="admin.tipo" /></th>
                                        <th><i class="fas fa-circle"></i> <fmt:message key="admin.estado" /></th>
                                        <th><i class="fas fa-calendar"></i> <fmt:message key="admin.fechaAlta" /></th>
                                        <th><i class="fas fa-birthday-cake"></i> <fmt:message key="admin.edad" /></th>
                                        <th><i class="fas fa-cogs"></i> <fmt:message key="admin.acciones" /></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty listaUsuarios}">
                                            <tr>
                                                <td colspan="8" class="no-results">
                                                    <div class="empty-state">
                                                        <i class="fas fa-users"></i>
                                                        <h3><fmt:message key="admin.noResultados" /></h3>
                                                        <p>No se encontraron usuarios con los criterios especificados.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="usuario" items="${listaUsuarios}">
                                                <tr>
                                                    <td><span class="badge">${usuario.idSuscriptor}</span></td>
                                                    <td>
                                                        <div class="user-info">
                                                            <div class="user-avatar">
                                                                <i class="fas fa-user"></i>
                                                            </div>
                                                            <span class="user-name">${usuario.username}</span>
                                                        </div>
                                                    </td>
                                                    <td>${usuario.correo}</td>
                                                    <td>
                                                        <span class="badge ${usuario.tipo == 'centro' ? 'badge-info' : 'badge-secondary'}">
                                                            ${usuario.tipo}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="badge ${usuario.estado == 'activo' ? 'badge-success' : 'badge-warning'}">
                                                            ${usuario.estado}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${usuario.fechaAlta}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td>${usuario.edad}</td>
                                                    <td class="actions">
                                                        <a href="AdminUsuarios?action=editar&id=${usuario.idSuscriptor}"
                                                           class="action-btn edit-btn" title="<fmt:message key="admin.editar" />">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button onclick="confirmarEliminar(${usuario.idSuscriptor}, '${usuario.username}')"
                                                                class="action-btn delete-btn" title="<fmt:message key="admin.eliminar" />">
                                                            <i class="fas fa-trash-alt"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
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

    <!-- Modal de confirmación para eliminar usuario -->
    <div id="modal-eliminar" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>
                    <i class="fas fa-exclamation-triangle"></i> <fmt:message key="admin.confirmarEliminacion" />
                </h2>
                <span class="close-modal">&times;</span>
            </div>
            <div class="modal-body">
                <p>
                    <fmt:message key="admin.confirmarEliminarUsuario" />
                    <strong><span id="nombre-usuario-eliminar"></span></strong>?
                </p>
                <div class="warning-note">
                    <i class="fas fa-info-circle"></i> Esta acción no se puede deshacer.
                </div>
            </div>
            <div class="modal-footer">
                <button id="btn-cancelar-eliminar" class="btn btn-secondary">
                    <i class="fas fa-times"></i> <fmt:message key="admin.cancelar" />
                </button>
                <form id="form-eliminar" action="AdminUsuarios" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="eliminar">
                    <input type="hidden" id="id-eliminar" name="id" value="">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash"></i> <fmt:message key="admin.eliminar" />
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function cambiarIdioma(idioma) {
            const currentAction = '${empty param.action ? "listar" : param.action}';
            const currentId = '${param.id}';
            let redirect = 'AdminUsuarios?action=' + currentAction;
            if (currentId) {
                redirect += '&id=' + currentId;
            }
            window.location.href = 'CambiarIdioma?idioma=' + idioma + '&redirect=' + encodeURIComponent(redirect);
        }

        // Script para el modal de confirmación de eliminación
        function confirmarEliminar(id, nombre) {
            document.getElementById('id-eliminar').value = id;
            document.getElementById('nombre-usuario-eliminar').textContent = nombre;
            document.getElementById('modal-eliminar').style.display = 'flex';
        }

        document.querySelector('.close-modal').addEventListener('click', function() {
            document.getElementById('modal-eliminar').style.display = 'none';
        });

        document.getElementById('btn-cancelar-eliminar').addEventListener('click', function() {
            document.getElementById('modal-eliminar').style.display = 'none';
        });

        window.addEventListener('click', function(event) {
            if (event.target == document.getElementById('modal-eliminar')) {
                document.getElementById('modal-eliminar').style.display = 'none';
            }
        });
    </script>
</body>
</html>
