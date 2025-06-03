<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
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
    <meta charset="ISO-8859-1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Valorar Experiencia</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- CSS -->
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/pages/pagina-principal.css">
    <link rel="stylesheet" href="css/pages/valorar-experiencia.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <header class="header">
        <div class="logo">
            <a href="index.jsp"><img src="img/BILBAOSKP.png" alt="Logo Educación Divertida"></a>
        </div>

        <nav class="nav-container">
            <ul class="nav-links">
                <li><a href="informacion.jsp"><fmt:message key="menu.informacion" /></a></li>
                <li><a href="Ranking"><fmt:message key="menu.ranking" /></a></li>
                <li><a href="comprarCupon.jsp"><fmt:message key="menu.comprarCupon" /></a></li>
            </ul>
        </nav>

        <div class="right-section">
            <div class="idiomas">
                <img src="img/idiomas.png" alt="Idioma" class="icono-idioma">
                <ul class="idioma-menu">
                    <li><a href="CambiarIdioma?idioma=es"><fmt:message key="idioma.espanol" /></a></li>
                    <li><a href="CambiarIdioma?idioma=en"><fmt:message key="idioma.ingles" /></a></li>
                    <li><a href="CambiarIdioma?idioma=eu"><fmt:message key="idioma.euskera" /></a></li>
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
			        <a href="suscribirse.jsp" class="btn"><fmt:message key="menu.suscribirse" /></a>
			<% 
			    } 
			%>
            <%   if (username != null) { 
			%>
			        <a href="private/descargarJuego.jsp" class="btn"><fmt:message key="menu.descargar" /></a>
			<% 
			    } else { 
			%>
			        <!-- No se muestra el botón descargar si no hay cookie -->
			<% 
			    } 
			%>
        </div>
    </header>

    <!-- Contenido Principal -->
    <main class="main-content">
        <div class="page-title">Valorar Experiencia</div>
        
        <!-- Mostrar mensaje de éxito o error -->
        <c:if test="${not empty mensaje}">
            <div class="mensaje-container">
                <div class="mensaje ${tipoMensaje}">
                    <c:choose>
                        <c:when test="${tipoMensaje == 'success'}">
                            <i class="fas fa-check-circle"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-exclamation-circle"></i>
                        </c:otherwise>
                    </c:choose>
                    ${mensaje}
                </div>
            </div>
        </c:if>
        
        <div class="rating-container">
            <!-- Formulario de valoración -->
            <div class="rating-form-section">
                <div class="section-header">
                    <h2 class="section-title">
                        <i class="fas fa-star"></i>
                        Tu Valoración
                    </h2>
                    <p class="section-description">
                        Comparte tu experiencia y ayuda a otros jugadores
                    </p>
                </div>

                <form action="ValoracionServlet" method="post" class="rating-form">
                    
                    <!-- Puntuación general -->
                    <div class="form-group">
                        <label for="puntuacion">Puntuación General *</label>
                        <div class="rating-stars">
                            <input type="radio" id="star5" name="puntuacion" value="5" required>
                            <label for="star5" class="star">*</label>
                            <input type="radio" id="star4" name="puntuacion" value="4">
                            <label for="star4" class="star">*</label>
                            <input type="radio" id="star3" name="puntuacion" value="3">
                            <label for="star3" class="star">*</label>
                            <input type="radio" id="star2" name="puntuacion" value="2">
                            <label for="star2" class="star">*</label>
                            <input type="radio" id="star1" name="puntuacion" value="1">
                            <label for="star1" class="star">*</label>
                        </div>
                        <div class="rating-text">
                            <span class="rating-description">Selecciona tu puntuación</span>
                        </div>
                    </div>

                    <!-- Aspectos específicos -->
                    <div class="aspects-grid">
                        <div class="aspect-item">
                            <label for="dificultad">Dificultad</label>
                            <select name="dificultad" id="dificultad" required>
                                <option value="">Seleccionar...</option>
                                <option value="muy facil">Muy Fácil</option>
                                <option value="facil">Fácil</option>
                                <option value="medio">Medio</option>
                                <option value="dificil">Difícil</option>
                                <option value="muy dificil">Muy Difícil</option>
                            </select>
                        </div>

                        <div class="aspect-item">
                            <label for="recomendacion">Lo recomendarias?</label>
                            <select name="recomendacion" id="recomendacion" required>
                                <option value="">Seleccionar...</option>
                                <option value="si">Si, definitivamente</option>
                                <option value="tal vez">Tal vez</option>
                                <option value="no">No lo recomendaría</option>
                            </select>
                        </div>
                    </div>

                    <!-- Comentario -->
                    <div class="form-group">
                        <label for="comentario">Comentario</label>
                        <textarea name="comentario" id="comentario" rows="5" 
                                  placeholder="Cuéntanos tu experiencia... ¿Qué te gustó más? ¿Qué mejorarías? (Opcional)"></textarea>
                    </div>

                    <!-- Botones -->
                    <div class="form-actions">
                        <a href="PerfilServlet" class="btn-volver">
                            <i class="fas fa-arrow-left"></i>
                            Volver
                        </a>
                        <button type="submit" class="btn-enviar">
                            <i class="fas fa-paper-plane"></i>
                            Enviar Valoración
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

   <footer class="footer">
        <div class="footer-container">
            <div class="footer-section">
                <div class="footer-logo">
                    <img src="img/BilbaoLogo.png" alt="Logo Educación Divertida">
                    <img alt="logo webcrafters" src="img/logo.png">
                </div>
                <p class="footer-description"><fmt:message key="footer.descripcion" /></p>
                <div class="social-links">
                    <a href="https://www.facebook.com/TuPagina" target="_blank"><i class="fab fa-facebook-f"></i></a>
                    <a href="https://twitter.com/TuUsuario" target="_blank"><i class="fab fa-twitter"></i></a>
                    <a href="https://instagram.com/TuUsuario" target="_blank"><i class="fab fa-instagram"></i></a>
                    <a href="https://youtube.com/TuCanal" target="_blank"><i class="fab fa-youtube"></i></a>
                </div>
            </div>

            <div class="footer-section">
                <h3 class="footer-title"><fmt:message key="footer.enlacesRapidos" /></h3>
                <ul class="footer-links">
                    <li><a href="#"><fmt:message key="footer.sobreNosotros" /></a></li>
                    <li><a href="#"><fmt:message key="footer.nuestrosCursos" /></a></li>
                    <li><a href="#"><fmt:message key="footer.testimonios" /></a></li>
                    <li><a href="#"><fmt:message key="footer.blogEducativo" /></a></li>
                    <li><a href="#"><fmt:message key="footer.preguntasFrecuentes" /></a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h3 class="footer-title"><fmt:message key="footer.contacto" /></h3>
                <div class="footer-contact">
                    <p><i class="fas fa-map-marker-alt"></i> <fmt:message key="footer.direccion" /></p>
                    <p><i class="fas fa-phone"></i> <fmt:message key="footer.telefono" /></p>
                    <p><i class="fas fa-envelope"></i> <fmt:message key="footer.email" /></p>
                    <p><i class="fas fa-clock"></i> <fmt:message key="footer.horario" /></p>
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
	    
	    document.addEventListener("DOMContentLoaded", function () {
	      const header = document.querySelector(".header");
	      if (header) {
	        header.style.backgroundColor = "#333333";
	      }
	    });
	    
	    // Auto-ocultar mensaje después de 5 segundos
	    document.addEventListener('DOMContentLoaded', function() {
	        const mensaje = document.querySelector('.mensaje');
	        if (mensaje) {
	            setTimeout(function() {
	                mensaje.style.opacity = '0';
	                setTimeout(function() {
	                    mensaje.parentElement.style.display = 'none';
	                }, 300);
	            }, 5000);
	        }
	    });
    </script>
</body>
</html>
