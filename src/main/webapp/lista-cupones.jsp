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
<title>Mis Cupones</title>
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
<link rel="stylesheet" href="css/admin-dashboard.css">
<style>
.btn-volver {
	background-color: #6c757d;
	color: white;
	border: none;
	padding: 10px 20px;
	border-radius: 5px;
	cursor: pointer;
	transition: all 0.3s;
	text-decoration: none;
	display: inline-block;
	margin-bottom: 20px;
}

.btn-volver:hover {
	background-color: #5a6268;
	transform: translateY(-2px);
}

.btn-volver i {
	margin-right: 8px;
}

.cupones-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

.cupones-stats {
	display: flex;
	gap: 20px;
	margin-bottom: 30px;
}

.stat-card {
	background-color: #fff;
	border-radius: 8px;
	padding: 20px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
	text-align: center;
	flex: 1;
}

.stat-number {
	font-size: 24px;
	font-weight: 700;
	color: #333;
	margin-bottom: 5px;
}

.stat-label {
	font-size: 14px;
	color: #666;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.stat-disponible {
	border-left: 4px solid #28a745;
}

.stat-usado {
	border-left: 4px solid #dc3545;
}

.stat-total {
	border-left: 4px solid #17a2b8;
}
</style>
</head>
<body>
	<header class="header">
		<div class="logo">
			<a href="index.jsp"><img src="img/logo.png" alt="Logo"></a>
		</div>
		<nav class="nav-container">
			<ul class="nav-links">
				<li><a href="informacion.jsp"><fmt:message
							key="menu.informacion" /></a></li>
				<li><a href="Ranking"><fmt:message key="menu.ranking" /></a></li>
				<li><a href="comprarCupon.jsp"><fmt:message
							key="menu.comprarCupon" /></a></li>
			</ul>
		</nav>

		<div class="right-section">
			<div class="idiomas">
				<img src="img/idiomas.png" alt="Idiomas">
				<ul class="idioma-menu">
					<li><a href="CambiarIdioma?idioma=es"><fmt:message
								key="idioma.espanol" /></a></li>
					<li><a href="CambiarIdioma?idioma=en"><fmt:message
								key="idioma.ingles" /></a></li>
					<li><a href="CambiarIdioma?idioma=eu"><fmt:message
								key="idioma.euskera" /></a></li>
				</ul>
			</div>
			<%
			if (username != null) {
			%>
			<a href="PerfilServlet" class="btn">Perfil</a>
			<%
			} else {
			%>
			<a href="login.jsp" class="btn">Iniciar sesión</a>
			<%
			}
			%>
			<%
			if (username != null) {
			%>
			<a href="private/descargarJuego.jsp" class="btn"><fmt:message
					key="menu.descargar" /></a>
			<%
			} else {
			%>
			<a href="suscribirse.jsp" class="btn"><fmt:message
					key="menu.suscribirse" /></a>
			<%
			}
			%>
		</div>
	</header>

	<div class="main-content">
		<div class="admin-container">
			<div class="cupones-header">
				<h1 class="page-title">Mis Cupones</h1>
				<a href="PerfilServlet" class="btn-volver">
					<i class="fas fa-arrow-left"></i> Volver al Perfil
				</a>
			</div>

			<!-- Estadísticas de cupones -->
			<div class="cupones-stats">
				<div class="stat-card stat-total">
					<div class="stat-number">
						<c:out value="${listaCupones.size()}" />
					</div>
					<div class="stat-label">Total Cupones</div>
				</div>
				<div class="stat-card stat-disponible">
					<div class="stat-number">
						<c:set var="disponibles" value="0" />
						<c:forEach var="cupon" items="${listaCupones}">
							<c:if test="${cupon.estado == 'disponible'}">
								<c:set var="disponibles" value="${disponibles + 1}" />
							</c:if>
						</c:forEach>
						<c:out value="${disponibles}" />
					</div>
					<div class="stat-label">Disponibles</div>
				</div>
				<div class="stat-card stat-usado">
					<div class="stat-number">
						<c:set var="usados" value="0" />
						<c:forEach var="cupon" items="${listaCupones}">
							<c:if test="${cupon.estado == 'usado'}">
								<c:set var="usados" value="${usados + 1}" />
							</c:if>
						</c:forEach>
						<c:out value="${usados}" />
					</div>
					<div class="stat-label">Usados</div>
				</div>
			</div>

			<!-- Lista de cupones -->
			<section class="users-table-section">
				<h2 class="users-table-title">Detalle de Cupones</h2>
				<div class="table-container">
					<table class="users-table">
						<thead>
							<tr>
								<th>ID CUPÓN</th>
								<th>TIPO</th>
								<th>FECHA CADUCIDAD</th>
								<th>ESTADO</th>
								<th>ACCIÓN</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${empty listaCupones}">
									<tr>
										<td colspan="5" class="no-results">No tienes cupones disponibles</td>
									</tr>
								</c:when>
								<c:otherwise>
									<c:forEach var="cupon" items="${listaCupones}">
										<tr>
											<td>${cupon.idCupon}</td>
											<td>${cupon.tipo}</td>
											<td><fmt:formatDate value="${cupon.fechaCaducidad}"
													pattern="dd/MM/yyyy" /></td>
											<td><span
												class="status-badge ${cupon.estado == 'disponible' ? 'status-active' : 'status-inactive'}">
													${cupon.estado} </span></td>
											<td>
												<c:if test="${cupon.estado == 'disponible'}">
													<!-- Formulario para devolver el cupón -->
													<form action="BorrarCuponServlet" method="post">
														<input type="hidden" name="idCupon"
															value="${cupon.idCupon}">
														<button type="submit" class="btn btn-danger">DEVOLVER</button>
													</form>
												</c:if>
												<c:if test="${cupon.estado != 'disponible'}">
													<span class="text-muted">No disponible</span>
												</c:if>
											</td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
			</section>

			<!-- Botón para comprar más cupones -->
			<div style="text-align: center; margin-top: 30px;">
				<a href="comprarCupon.jsp" class="btn admin-btn" style="background-color: #28a745; color: white; padding: 15px 30px; font-size: 16px;">
					<i class="fas fa-plus"></i> Comprar Más Cupones
				</a>
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
				<p class="footer-description">
					<fmt:message key="footer.descripcion" />
				</p>
				<div class="social-links">
					<a href="#"><i class="fab fa-facebook-f"></i></a> <a href="#"><i
						class="fab fa-twitter"></i></a> <a href="#"><i
						class="fab fa-instagram"></i></a> <a href="#"><i
						class="fab fa-youtube"></i></a>
				</div>
			</div>

			<div class="footer-section">
				<h3 class="footer-title">
					<fmt:message key="footer.enlacesRapidos" />
				</h3>
				<ul class="footer-links">
					<li><a href="#"><fmt:message key="footer.sobreNosotros" /></a></li>
					<li><a href="#"><fmt:message key="footer.nuestrosCursos" /></a></li>
					<li><a href="#"><fmt:message key="footer.testimonios" /></a></li>
					<li><a href="#"><fmt:message key="footer.blogEducativo" /></a></li>
					<li><a href="#"><fmt:message key="footer.preguntasFrecuentes" /></a></li>
				</ul>
			</div>

			<div class="footer-section">
				<h3 class="footer-title">
					<fmt:message key="footer.contacto" />
				</h3>
				<div class="footer-contact">
					<p>
						<i class="fas fa-map-marker-alt"></i>
						<fmt:message key="footer.direccion" />
					</p>
					<p>
						<i class="fas fa-phone"></i>
						<fmt:message key="footer.telefono" />
					</p>
					<p>
						<i class="fas fa-envelope"></i>
						<fmt:message key="footer.email" />
					</p>
					<p>
						<i class="fas fa-clock"></i>
						<fmt:message key="footer.horario" />
					</p>
				</div>
			</div>
		</div>

		<div class="footer-container">
			<div class="copyright">
				<fmt:message key="footer.copyright" />
			</div>
		</div>
	</footer>

	<script>
		document.addEventListener('DOMContentLoaded', function() {
			const idiomas = document.querySelector('.idiomas');
			document.addEventListener('click', function(e) {
				if (idiomas.contains(e.target)) {
					idiomas.classList.toggle('activo');
				} else {
					idiomas.classList.remove('activo');
				}
			});
		});
	</script>
</body>
</html>
