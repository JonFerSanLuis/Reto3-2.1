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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="cupon.titulo" /></title>
    <!-- Google Fonts -->
    <link
        href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Poppins:wght@300;400;500;600;700&display=swap"
        rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- CSS -->
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/pages/comprar-cupon.css">
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
			<%   if (username != null) { 
			%>
			<a href="PerfilServlet" class="btn">Perfil</a>
			<% 
			    } else { 
			%>
			<a href="login.jsp" class="btn">Iniciar sesión</a>
			<% 
			    } 
			%>
			<%   if (username != null) { 
			%>
			<!-- No se muestra el botón descargar si no hay cookie -->
			<% 
			    } else { 
			%>
			<a href="suscribirse.jsp" class="btn"><fmt:message
					key="menu.suscribirse" /></a>
			<% 
			    } 
			%>
			<%   if (username != null) { 
			%>
			<a href="private/descargarJuego.jsp" class="btn"><fmt:message
					key="menu.descargar" /></a>
			<% 
			    } else { 
			%>
			<!-- No se muestra el botón descargar si no hay cookie -->
			<% 
			    } 
			%>
		</div>
	</header>
	<main>
		<section>
			<h2>Mis Compras</h2>
			<section class="ranking-table-section">
				<h2 class="ranking-table-title">
					<fmt:message key="ranking.topJugadores" />
				</h2>
				<table class="users-table">
					<thead>
						<tr>
							<th>PRODUCTO</th>
							<%-- Reverted --%>
							<th>FECHA</th>
							<%-- Reverted --%>
							<th>PRECIO</th>
							<%-- Reverted --%>
							<th>DEVOLVER</th>
							<%-- Reverted --%>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${empty listaCompras}">
								<tr>
									<td colspan="5" class="no-results"><fmt:message
											key="admin.noResultados" /></td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="compra" items="${listaCompra}">
									<tr>
										<td>${compra.producto}</td>
										<td><fmt:formatDate value="${compra.fecha}"
												pattern="dd/MM/yyyy" /></td>
										<td>${compra.precio}</td>
										<td>
											<!-- Formulario para borrar el cupón -->
											<form action="DevolverCompra" method="post">
												<input type="hidden" name="idCupon"
													value="${compra.idCompra}">
												<button type="submit" class="btn btn-danger">DEVOLVER</button>
											</form>
										</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</section>
		</section>
	</main>

	<footer>
		<p>&copy; 2025 Mi Tienda</p>
	</footer>
</body>
</html>
