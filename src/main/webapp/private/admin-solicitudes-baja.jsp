<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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

<c:set var="idioma"
	value="${not empty sessionScope.idioma ? sessionScope.idioma : 'es'}"
	scope="session" />
<fmt:setLocale value="${idioma}" />
<fmt:setBundle basename="resources.messages" />

<!DOCTYPE html>
<html lang="${idioma}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Gestionar Solicitudes de Baja</title>
<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Poppins:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<!-- CSS -->
<link rel="stylesheet" href="css/global.css">
<link rel="stylesheet" href="css/pages/admin-usuarios.css">
<link rel="stylesheet" href="css/pages/admin-pending-centers.css">
</head>
<body>
	<header class="header">
		<div class="logo">
			<a href="index.jsp"><img src="img/logo.png" alt="Logo"></a>
		</div>
		<nav class="nav-container">
			<ul class="nav-links">
				<li><a href="PerfilServlet">Volver al Panel</a></li>
				<li><a href="AdminUsuarios?action=listar">Gestionar Usuarios</a></li>
				<li><a href="AdminUsuarios?action=listarPendientes">Centros Pendientes</a></li>
				<li><a href="AdminUsuarios?action=listarSolicitudesBaja" class="active">Solicitudes de Baja</a></li>
			</ul>
		</nav>

		<div class="right-section">
			<div class="idiomas">
				<img src="img/idiomas.png" alt="Idiomas">
				<ul class="idioma-menu">
					<li><a href="CambiarIdioma?idioma=es&redirect=AdminUsuarios?action=listarSolicitudesBaja">Español</a></li>
					<li><a href="CambiarIdioma?idioma=en&redirect=AdminUsuarios?action=listarSolicitudesBaja">English</a></li>
					<li><a href="CambiarIdioma?idioma=eu&redirect=AdminUsuarios?action=listarSolicitudesBaja">Euskera</a></li>
				</ul>
			</div>
			<%
			if (username != null) {
			%>
			<a href="PerfilServlet" class="btn">Perfil</a> 
			<a href="private/descargarJuego.jsp" class="btn">Descargar</a>
			<div class="action-buttons">
				<form action="CerrarSesionServlet" method="post">
					<button type="submit" class="btn btn-logout">Cerrar Sesión</button>
				</form>
			</div>
			<%
			} else {
			%>
			<a href="login.jsp" class="btn">Iniciar Sesión</a>
			<%
			}
			%>
		</div>
	</header>

	<div class="main-content">
		<h1 class="page-title">Gestionar Solicitudes de Baja</h1>

		<!-- Mensajes de éxito o error -->
		<c:if test="${not empty sessionScope.mensaje}">
			<div class="alert alert-success">
				${sessionScope.mensaje}
				<c:remove var="mensaje" scope="session" />
			</div>
		</c:if>
		<c:if test="${not empty sessionScope.error}">
			<div class="alert alert-danger">
				${sessionScope.error}
				<c:remove var="error" scope="session" />
			</div>
		</c:if>

		<div class="admin-container">
			<section class="pending-centers-section">
				<div class="section-header">
					<h2 class="section-title">
						<i class="fas fa-user-times"></i> Solicitudes de Baja de Centros
					</h2>
					<p class="section-description">Revisa y gestiona las solicitudes de baja de centros educativos</p>
				</div>

				<c:choose>
					<c:when test="${empty listaSolicitudesBaja}">
						<div class="empty-state">
							<div class="empty-state-icon">
								<i class="fas fa-inbox"></i>
							</div>
							<h3>No hay solicitudes de baja</h3>
							<p>Actualmente no hay solicitudes de baja pendientes de revisión.</p>
						</div>
					</c:when>
					<c:otherwise>
						<div class="table-container">
							<table class="users-table">
								<thead>
									<tr>
										<th><i class="fas fa-hashtag"></i> ID</th>
										<th><i class="fas fa-user"></i> Centro</th>
										<th><i class="fas fa-envelope"></i> Correo Electrónico</th>
										<th><i class="fas fa-tag"></i> Tipo</th>
										<th><i class="fas fa-circle"></i> Estado</th>
										<th><i class="fas fa-calendar"></i> Fecha Registro</th>
										<th><i class="fas fa-cogs"></i> Acciones</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="centro" items="${listaSolicitudesBaja}">
										<tr>
											<td><span class="id-badge">${centro.idSuscriptor}</span></td>
											<td>
												<div class="user-info">
													<div class="user-avatar">
														<i class="fas fa-school"></i>
													</div>
													<span class="user-name">${centro.username}</span>
												</div>
											</td>
											<td><span class="email">${centro.correo}</span></td>
											<td><span class="type-badge type-centro">${centro.tipo}</span></td>
											<td>
												<span class="status-badge" style="background-color: #ffc107; color: #856404;">
													<i class="fas fa-exclamation-triangle"></i> Solicitud de Baja
												</span>
											</td>
											<td>
												<span class="date">
													<fmt:formatDate value="${centro.fechaAlta}" pattern="dd/MM/yyyy" />
												</span>
											</td>
											<td class="actions">
												<button onclick="confirmarBaja(${centro.idSuscriptor}, '${centro.username}')"
													class="action-btn accept-btn" title="Confirmar Baja">
													<i class="fas fa-check"></i>
												</button>
												<button onclick="rechazarBaja(${centro.idSuscriptor}, '${centro.username}')"
													class="action-btn reject-btn" title="Rechazar Baja">
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
			</section>
		</div>
	</div>

	<!-- Modal de confirmación para confirmar baja -->
	<div id="modal-confirmar-baja" class="modal">
		<div class="modal-content">
			<div class="modal-header">
				<h2>
					<i class="fas fa-exclamation-triangle"></i> Confirmar Baja de Centro
				</h2>
				<span class="close-modal-confirmar-baja">&times;</span>
			</div>
			<div class="modal-body">
				<p id="mensaje-confirmacion-baja"></p>
				<div class="warning-note">
					<i class="fas fa-info-circle"></i> Esta acción eliminará permanentemente el centro y todos sus datos asociados.
				</div>
			</div>
			<div class="modal-footer">
				<button id="btn-cancelar-confirmar-baja" class="btn-secondary">
					<i class="fas fa-times"></i> Cancelar
				</button>
				<form id="form-confirmar-baja" action="AdminUsuarios" method="post" style="display: inline;">
					<input type="hidden" name="action" value="confirmarBaja">
					<input type="hidden" id="id-confirmar-baja" name="id" value="">
					<button type="submit" class="btn-danger">
						<i class="fas fa-trash"></i> Confirmar Baja
					</button>
				</form>
			</div>
		</div>
	</div>

	<!-- Modal de confirmación para rechazar baja -->
	<div id="modal-rechazar-baja" class="modal">
		<div class="modal-content">
			<div class="modal-header">
				<h2>
					<i class="fas fa-question-circle"></i> Rechazar Solicitud de Baja
				</h2>
				<span class="close-modal-rechazar-baja">&times;</span>
			</div>
			<div class="modal-body">
				<p id="mensaje-rechazo-baja"></p>
				<div class="warning-note" style="background-color: #d1ecf1; border-color: #bee5eb; color: #0c5460;">
					<i class="fas fa-info-circle"></i> El centro volverá a estar activo y podrá seguir usando la plataforma.
				</div>
			</div>
			<div class="modal-footer">
				<button id="btn-cancelar-rechazar-baja" class="btn-secondary">
					<i class="fas fa-times"></i> Cancelar
				</button>
				<form id="form-rechazar-baja" action="AdminUsuarios" method="post" style="display: inline;">
					<input type="hidden" name="action" value="rechazarBaja">
					<input type="hidden" id="id-rechazar-baja" name="id" value="">
					<button type="submit" class="btn" style="background-color: #17a2b8; color: white;">
						<i class="fas fa-undo"></i> Rechazar Solicitud
					</button>
				</form>
			</div>
		</div>
	</div>

	<!-- Footer -->
	<footer class="footer">
		<div class="footer-container">
			<div class="footer-section">
				<div class="footer-logo">
					<img src="img/logo.png" alt="Logo Educación Divertida">
				</div>
				<p class="footer-description">Transformamos la educación en una experiencia divertida y memorable.</p>
				<div class="social-links">
					<a href="#"><i class="fab fa-facebook-f"></i></a>
					<a href="#"><i class="fab fa-twitter"></i></a>
					<a href="#"><i class="fab fa-instagram"></i></a>
					<a href="#"><i class="fab fa-youtube"></i></a>
				</div>
			</div>

			<div class="footer-section">
				<h3 class="footer-title">Enlaces rápidos</h3>
				<ul class="footer-links">
					<li><a href="index.jsp">Inicio</a></li>
					<li><a href="informacion.jsp">Sobre nosotros</a></li>
					<li><a href="contacto-exito.jsp">Contacto</a></li>
				</ul>
			</div>

			<div class="footer-section">
				<h3 class="footer-title">Contacto</h3>
				<div class="footer-contact">
					<p><i class="fas fa-map-marker-alt"></i> Calle Educación 123, Madrid, España</p>
					<p><i class="fas fa-phone"></i> +34 912 345 678</p>
					<p><i class="fas fa-envelope"></i> info@educaciondivertida.com</p>
					<p><i class="fas fa-clock"></i> Lunes-Viernes: 9:00 - 18:00</p>
				</div>
			</div>
		</div>

		<div class="footer-container">
			<div class="copyright">© 2025 Educación Divertida. Todos los derechos reservados.</div>
		</div>
	</footer>

	<script>
        // Script para el menú de idiomas
        document.addEventListener('DOMContentLoaded', function() {
            const idiomas = document.querySelector('.idiomas');
            if (idiomas) {
                document.addEventListener('click', function(e) {
                    if (idiomas.contains(e.target)) {
                        idiomas.classList.toggle('activo');
                    } else {
                        idiomas.classList.remove('activo');
                    }
                });
            }
        });

        // Scripts para modales
        const modalConfirmarBaja = document.getElementById('modal-confirmar-baja');
        const modalRechazarBaja = document.getElementById('modal-rechazar-baja');
        
        function confirmarBaja(id, nombre) {
            if (modalConfirmarBaja) {
                document.getElementById('id-confirmar-baja').value = id;
                document.getElementById('mensaje-confirmacion-baja').innerHTML = 
                    `¿Está seguro de que desea confirmar la baja del centro <strong>${nombre}</strong>?`;
                modalConfirmarBaja.style.display = 'flex';
            }
        }

        function rechazarBaja(id, nombre) {
            if (modalRechazarBaja) {
                document.getElementById('id-rechazar-baja').value = id;
                document.getElementById('mensaje-rechazo-baja').innerHTML = 
                    `¿Está seguro de que desea rechazar la solicitud de baja del centro <strong>${nombre}</strong>?`;
                modalRechazarBaja.style.display = 'flex';
            }
        }

        // Cerrar modales
        document.querySelector('.close-modal-confirmar-baja')?.addEventListener('click', function() {
            modalConfirmarBaja.style.display = 'none';
        });

        document.querySelector('.close-modal-rechazar-baja')?.addEventListener('click', function() {
            modalRechazarBaja.style.display = 'none';
        });

        document.getElementById('btn-cancelar-confirmar-baja')?.addEventListener('click', function() {
            modalConfirmarBaja.style.display = 'none';
        });

        document.getElementById('btn-cancelar-rechazar-baja')?.addEventListener('click', function() {
            modalRechazarBaja.style.display = 'none';
        });

        // Cerrar modal al hacer clic fuera
        window.addEventListener('click', function(event) {
            if (event.target == modalConfirmarBaja) {
                modalConfirmarBaja.style.display = 'none';
            }
            if (event.target == modalRechazarBaja) {
                modalRechazarBaja.style.display = 'none';
            }
        });
    </script>
</body>
</html>
