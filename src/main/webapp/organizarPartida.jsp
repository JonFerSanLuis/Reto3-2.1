<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    HttpSession sesion = request.getSession();
    com.bilbaoskp.model.Centro centro = (com.bilbaoskp.model.Centro) sesion.getAttribute("centro");
    request.setAttribute("centro", centro);
%>

<html>
<head>
<title>Organizar Partida</title>
</head>
<body>
	<c:choose>
		<c:when
			test="${empty cookie.tipo || cookie.tipo.value != 'centro' || empty cookie.usuario}">
			<h2>El centro educativo no está registrado.</h2>
		</c:when>
		<c:otherwise>
			<h2>Organizar Partida - Escape contra el Acoso y Ciberbullying</h2>
			<form action="ProcesarPartidaServlet" method="post">
				<label for="fecha">Fecha de activación:</label> <input type="date"
					id="fecha" name="fechaActivacion" required /><br>
				<br> <label for="nombreClase">Nombre de la clase:</label> <input
					type="text" id="nombreClase" name="nombreClase" maxlength="100"
					required /><br>
				<br> <label for="cantidad">Cantidad:</label> <input
					type="number" id="cantidad" name="cantidad" min="1" required /><br>
				<br> <label for="idioma">Idioma:</label> <select id="idioma"
					name="idioma">
					<option value="es">Español</option>
					<option value="en">Inglés</option>
					<option value="eu">Euskera</option>
				</select><br>
				<br>

				<c:if test="${not empty errorCupones}">
					<p style="color: red;">${errorCupones}</p>
				</c:if>

				<input type="submit" value="Generar Código de Acceso" />
			</form>

		</c:otherwise>
	</c:choose>
</body>
</html>
