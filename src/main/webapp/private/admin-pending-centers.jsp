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
    <title>Gestionar Centros Pendientes - Escape Room</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- CSS -->
    <link rel="stylesheet" href="css/pages/perfil.css">
    <link rel="stylesheet" href="css/admin-pending-centers.css">
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
                    <li><a href="AdminUsuarios?action=listarPendientes" class="active"><i class="fas fa-user-plus"></i> Centros Pendientes</a></li>
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
                    <span>Centros Pendientes</span>
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
                <h1 class="page-title">Gestionar Centros Pendientes</h1>

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
                            <i class="fas fa-school"></i> Centros Pendientes de Aprobación
                        </h2>
                    </div>
                    <div class="card-body">
                        <p class="section-description" style="text-align: center; margin-bottom: 20px;">
                            Revisa y gestiona las solicitudes de registro de centros educativos
                        </p>

                        <c:choose>
                            <c:when test="${empty listaCentrosPendientes}">
                                <div class="empty-state">
                                    <i class="fas fa-inbox"></i>
                                    <h3>No hay centros pendientes</h3>
                                    <p>Actualmente no hay solicitudes de centros pendientes de aprobación.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-container">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th><i class="fas fa-hashtag"></i> ID</th>
                                                <th><i class="fas fa-user"></i> Responsable</th>
                                                <th><i class="fas fa-envelope"></i> Correo Electrónico</th>
                                                <th><i class="fas fa-tag"></i> Tipo</th>
                                                <th><i class="fas fa-circle"></i> Estado</th>
                                                <th><i class="fas fa-calendar"></i> Fecha Solicitud</th>
                                                <th><i class="fas fa-cogs"></i> Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="centro" items="${listaCentrosPendientes}">
                                                <tr>
                                                    <td><span class="badge">${centro.idSuscriptor}</span></td>
                                                    <td>
                                                        <div class="user-info">
                                                            <div class="user-avatar">
                                                                <i class="fas fa-user-tie"></i>
                                                            </div>
                                                            <span class="user-name">${centro.username}</span>
                                                        </div>
                                                    </td>
                                                    <td>${centro.correo}</td>
                                                    <td><span class="badge badge-info">${centro.tipo}</span></td>
                                                    <td><span class="badge badge-warning">${centro.estado}</span></td>
                                                    <td>
                                                        <fmt:formatDate value="${centro.fechaAlta}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td class="actions">
                                                        <form action="AdminUsuarios" method="post" style="display: inline;">
                                                            <input type="hidden" name="action" value="aceptarCentro">
                                                            <input type="hidden" name="id" value="${centro.idSuscriptor}">
                                                            <button type="submit" class="action-btn accept-btn" title="Aceptar Centro">
                                                                <i class="fas fa-check"></i>
                                                            </button>
                                                        </form>
                                                        <button onclick="confirmarRechazarCentro(${centro.idSuscriptor}, '${centro.username}')" 
                                                                class="action-btn reject-btn" title="Rechazar Centro">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                        <a href="AdminUsuarios?action=detalles&id=${centro.idSuscriptor}" 
                                                           class="action-btn details-btn" title="Ver Detalles">
                                                            <i class="fas fa-info-circle"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
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

    <!-- Modal de confirmación para rechazar centro -->
    <div id="modal-rechazar-centro" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>
                    <i class="fas fa-exclamation-triangle"></i> Confirmar Rechazo
                </h2>
                <span class="close-modal-rechazar-centro">&times;</span>
            </div>
            <div class="modal-body">
                <p id="mensaje-confirmacion-rechazo"></p>
                <div class="warning-note">
                    <i class="fas fa-info-circle"></i> Esta acción no se puede deshacer. El centro será eliminado permanentemente.
                </div>
            </div>
            <div class="modal-footer">
                <button id="btn-cancelar-rechazar-centro" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Cancelar
                </button>
                <form id="form-rechazar-centro" action="AdminUsuarios" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="rechazarCentro">
                    <input type="hidden" id="id-rechazar-centro" name="id" value="">
                    <button type="submit" class="btn-danger">
                        <i class="fas fa-trash"></i> Rechazar
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function cambiarIdioma(idioma) {
            window.location.href = 'CambiarIdioma?idioma=' + idioma + '&redirect=AdminUsuarios?action=listarPendientes';
        }
        
        // Script para el modal de confirmación de rechazo de centro
        const modalRechazar = document.getElementById('modal-rechazar-centro');
        const mensajeConfirmacionRechazo = document.getElementById('mensaje-confirmacion-rechazo');
        
        function confirmarRechazarCentro(id, nombre) {
            if (modalRechazar) {
                document.getElementById('id-rechazar-centro').value = id;
                mensajeConfirmacionRechazo.innerHTML = `¿Está seguro de que desea rechazar la solicitud del centro <strong>${nombre}</strong>?`;
                modalRechazar.style.display = 'flex';
            }
        }

        const closeModalRechazarBtn = document.querySelector('.close-modal-rechazar-centro');
        if(closeModalRechazarBtn) {
            closeModalRechazarBtn.addEventListener('click', function() {
                if (modalRechazar) modalRechazar.style.display = 'none';
            });
        }

        const btnCancelarRechazarCentro = document.getElementById('btn-cancelar-rechazar-centro');
        if (btnCancelarRechazarCentro) {
            btnCancelarRechazarCentro.addEventListener('click', function() {
                if (modalRechazar) modalRechazar.style.display = 'none';
            });
        }

        window.addEventListener('click', function(event) {
            if (event.target == modalRechazar) {
                if (modalRechazar) modalRechazar.style.display = 'none';
            }
        });
    </script>
</body>
</html>
