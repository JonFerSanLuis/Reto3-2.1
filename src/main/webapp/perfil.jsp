<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard - Escape Room</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- CSS -->
    <link rel="stylesheet" href="css/pages/perfil.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
    <div class="sidebar-header">
        <a href="index.jsp" class="sidebar-logo">
            <div class="logo">
                <img src="img/BILBAOSKP.png" alt="${sidebar.logoAlt}" width="200" height="150">
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
                <li><a href="PerfilServlet" class="active"><i class="fas fa-tachometer-alt"></i> <fmt:message key="sidebar.perfil"/></a></li>
                <li><a href="AdminUsuarios?action=listar"><i class="fas fa-users"></i> <fmt:message key="sidebar.gestionarUsuarios"/></a></li>
                <li><a href="AdminUsuarios?action=listarPendientes"><i class="fas fa-user-plus"></i> <fmt:message key="sidebar.centrosPendientes"/></a></li>
                <li><a href="AdminUsuarios?action=listarSolicitudesBaja"><i class="fas fa-user-minus"></i> <fmt:message key="sidebar.solicitudesBaja"/></a></li>
                <li><a href="finalizar-ranking.jsp"><i class="fas fa-flag-checkered"></i> <fmt:message key="sidebar.finalizarRanking"/></a></li>                        
            </c:if>
            <c:if test="${!sessionScope.isAdmin}">
                <li><a href="PerfilServlet" class="active"><i class="fas fa-tachometer-alt"></i> <fmt:message key="sidebar.perfil"/></a></li>
                <li><a href="Ranking"><i class="fas fa-trophy"></i> <fmt:message key="sidebar.ranking"/></a></li>
                <li><a href="comprarCupon.jsp"><i class="fas fa-shopping-cart"></i> <fmt:message key="sidebar.comprarCupones"/></a></li>
                <li><a href="CompraServlet"><i class="fas fa-eye"></i> <fmt:message key="sidebar.verCompras"/></a></li>
                <li><a href="organizarPartida.jsp"><i class="fas fa-calendar-plus"></i> <fmt:message key="sidebar.organizarPartida"/></a></li>                        
                <li><a href="valorar-experiencia.jsp"><i class="fas fa-star"></i> <fmt:message key="sidebar.valorarExperiencia"/></a></li>
                <li><a href="private/descargarJuego.jsp"><i class="fas fa-download"></i> <fmt:message key="sidebar.descargarJuego"/></a></li>
            </c:if>
        </ul>
    </nav>
</aside>

        <!-- Contenido principal -->
        <main class="main-content">
            <!-- Header superior -->
            <header class="top-header">
    <div class="breadcrumb">
        <a href="index.jsp"><fmt:message key="header.inicio"/></a>
        <span>/</span>
        <span><fmt:message key="header.perfil"/></span>
    </div>

    <div class="header-actions">
        <div class="language-selector">
            <i class="fas fa-globe"></i>
            <select onchange="cambiarIdioma(this.value)">
                <option value="es" ${idioma == 'es' ? 'selected' : ''}><fmt:message key="header.idioma.es"/></option>
                <option value="en" ${idioma == 'en' ? 'selected' : ''}><fmt:message key="header.idioma.en"/></option>
                <option value="eu" ${idioma == 'eu' ? 'selected' : ''}><fmt:message key="header.idioma.eu"/></option>
            </select>
        </div>
        <form action="CerrarSesionServlet" method="post" style="display: inline;">
            <button type="submit" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i> <fmt:message key="header.cerrarSesion"/>
            </button>
        </form>
    </div>
</header>


            <!-- Área de contenido -->
            <div class="content-area">
               <h1 class="page-title"><fmt:message key="page.dashboard"/></h1>


                <!-- Mensajes de éxito o error -->
                <c:if test="${not empty sessionScope.mensaje}">
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i> <fmt:message key="alert.success"/> ${sessionScope.mensaje}
        <c:remove var="mensaje" scope="session" />
    </div>
</c:if>

<c:if test="${not empty sessionScope.error}">
    <div class="alert alert-danger">
        <i class="fas fa-exclamation-triangle"></i> <fmt:message key="alert.error"/> ${sessionScope.error}
        <c:remove var="error" scope="session" />
    </div>
</c:if>


                <!-- Admin Dashboard -->
                <c:if test="${sessionScope.isAdmin}">
                    <div class="stats-grid">
                        <div class="stat-card primary">
    <div class="stat-header">
        <div>
            <div class="stat-number">${usuariosActivos}</div>
            <div class="stat-label"><fmt:message key="stats.usuariosActivos"/></div>
        </div>
        <div class="stat-icon">
            <i class="fas fa-users"></i>
        </div>
    </div>
    <a href="AdminUsuarios?action=listar" class="stat-more">
        <fmt:message key="stats.masInformacion"/> <i class="fas fa-arrow-right"></i>
    </a>
</div>

<div class="stat-card warning">
    <div class="stat-header">
        <div>
            <div class="stat-number">${solicitudesBaja}</div>
            <div class="stat-label"><fmt:message key="stats.solicitudesBaja"/></div>
        </div>
        <div class="stat-icon">
            <i class="fas fa-user-times"></i>
        </div>
    </div>
    <a href="AdminUsuarios?action=listarSolicitudesBaja" class="stat-more">
        <fmt:message key="stats.masInformacion"/> <i class="fas fa-arrow-right"></i>
    </a>
</div>

                        
                        <div class="stat-card success">
    <div class="stat-header">
        <div>
            <div class="stat-number">${centrosPendientes}</div>
            <div class="stat-label"><fmt:message key="stats.centrosPendientes"/></div>
        </div>
        <div class="stat-icon">
            <i class="fas fa-school"></i>
        </div>
    </div>
    <a href="AdminUsuarios?action=listarPendientes" class="stat-more">
        <fmt:message key="stats.masInformacion"/> <i class="fas fa-arrow-right"></i>
    </a>
</div>

<div class="stat-card danger">
    <div class="stat-header">
        <div>
            <div class="stat-number">${totalCupones}</div>
            <div class="stat-label"><fmt:message key="stats.cuponesTotales"/></div>
        </div>
        <div class="stat-icon">
            <i class="fas fa-ticket-alt"></i>
        </div>
    </div>
    <a href="ListaCuponesServlet" class="stat-more">
        <fmt:message key="stats.masInformacion"/> <i class="fas fa-arrow-right"></i>
    </a>
</div>

                    </div>
                </c:if>

                <!-- User Dashboard -->
                <c:if test="${!sessionScope.isAdmin}">
                    <div class="stats-grid">
                       <div class="stat-card primary">
    <div class="stat-header">
        <div>
            <div class="stat-number">${totalCuponesUsuario}</div>
            <div class="stat-label"><fmt:message key="stats.cuponesTotales"/></div>
        </div>
        <div class="stat-icon">
            <i class="fas fa-ticket-alt"></i>
        </div>
    </div>
    <a href="#cupones" class="stat-more">
        <fmt:message key="stats.verCupones"/> <i class="fas fa-arrow-right"></i>
    </a>
</div>

<div class="stat-card success">
    <div class="stat-header">
        <div>
            <div class="stat-number">${cuponesDisponibles}</div>
            <div class="stat-label"><fmt:message key="stats.cuponesDisponibles"/></div>
        </div>
        <div class="stat-icon">
            <i class="fas fa-check-circle"></i>
        </div>
    </div>
    <a href="organizarPartida.jsp" class="stat-more">
        <fmt:message key="stats.usarCupones"/> <i class="fas fa-arrow-right"></i>
    </a>
</div>

                        
                        <div class="stat-card warning">
    <div class="stat-header">
        <div>
            <div class="stat-number">${partidasJugadas}</div>
            <div class="stat-label"><fmt:message key="stats.partidasJugadas"/></div>
        </div>
        <div class="stat-icon">
            <i class="fas fa-gamepad"></i>
        </div>
    </div>
    <a href="Ranking" class="stat-more">
        <fmt:message key="stats.verRanking"/> <i class="fas fa-arrow-right"></i>
    </a>
</div>

<div class="stat-card danger">
    <div class="stat-header">
        <div>
            <div class="stat-number">${puntosTotales}</div>
            <div class="stat-label"><fmt:message key="stats.puntosTotales"/></div>
        </div>
        <div class="stat-icon">
            <i class="fas fa-trophy"></i>
        </div>
    </div>
    <a href="Ranking" class="stat-more">
        <fmt:message key="stats.verRanking"/> <i class="fas fa-arrow-right"></i>
    </a>
</div>

                    </div>
                    
                    <!-- Cupones del usuario -->
                    <div class="content-card" id="cupones">
                       <div class="card-header">
    <h2 class="card-title">
        <i class="fas fa-ticket-alt"></i> <fmt:message key="cupones.misCupones"/>
        <c:if test="${totalCupones > 0}">
            <span style="font-size: 0.8rem; font-weight: normal; color: #7f8c8d;">
                (${totalCupones} <fmt:message key="cupones.enTotal"/>)
            </span>
        </c:if>
    </h2>
</div>

                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty listaCupones}">
    <div class="empty-state">
        <i class="fas fa-ticket-alt"></i>
        <h3><fmt:message key="cupones.noDisponibles"/></h3>
        <p><fmt:message key="cupones.comprarParaJugar"/></p>
    </div>
</c:when>

                                <c:otherwise>
                                    <!-- Controles de paginación superior -->
                                    <c:if test="${totalPages > 1}">
    <div class="pagination-controls" style="margin-bottom: 1rem;">
        <div class="pagination-info">
            <fmt:message key="paginacion.mostrando"/>
            ${(currentPage - 1) * pageSize + 1} - ${(currentPage - 1) * pageSize + listaCupones.size()} 
            <fmt:message key="paginacion.de"/> ${totalCupones} <fmt:message key="paginacion.cupones"/>
        </div>
        <div class="pagination-size">
            <label for="pageSize"><fmt:message key="paginacion.mostrar"/>:</label>
            <select id="pageSize" onchange="changePageSize(this.value)">
                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
            </select>
            <fmt:message key="paginacion.porPagina"/>
        </div>
    </div>
</c:if>


                                   <div class="table-container">
    <table class="table">
        <thead>
            <tr>
                <th><i class="fas fa-hashtag"></i> <fmt:message key="tabla.id"/></th>
                <th><i class="fas fa-tag"></i> <fmt:message key="tabla.tipo"/></th>
                <th><i class="fas fa-circle"></i> <fmt:message key="tabla.estado"/></th>
                <th><i class="fas fa-calendar"></i> <fmt:message key="tabla.fechaCaducidad"/></th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="cupon" items="${listaCupones}">
                <tr>
                    <td><strong>#${cupon.idCupon}</strong></td>
                    <td>${cupon.tipo}</td>
                    <td>
                        <c:choose>
                            <c:when test="${cupon.estado eq 'disponible'}">
                                <span class="badge badge-success"><fmt:message key="tabla.disponible"/></span>
                            </c:when>
                            <c:when test="${cupon.estado eq 'usado'}">
                                <span class="badge badge-secondary"><fmt:message key="tabla.usado"/></span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-info">${cupon.estado}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <fmt:formatDate value="${cupon.fechaCaducidad}" pattern="dd/MM/yyyy" />
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>


                                    <!-- Controles de paginación inferior -->
                                   <c:if test="${totalPages > 1}">
    <div class="pagination-controls" style="margin-top: 1rem;">
        <div class="pagination-buttons">
            <c:if test="${hasPreviousPage}">
                <a href="PerfilServlet?page=1&size=${pageSize}" class="pagination-btn">
                    <i class="fas fa-angle-double-left"></i> <fmt:message key="paginacion.primera"/>
                </a>
                <a href="PerfilServlet?page=${currentPage - 1}&size=${pageSize}" class="pagination-btn">
                    <i class="fas fa-angle-left"></i> <fmt:message key="paginacion.anterior"/>
                </a>
            </c:if>

            <span class="pagination-current">
                <fmt:message key="paginacion.pagina"/> ${currentPage} <fmt:message key="paginacion.de"/> ${totalPages}
            </span>

            <c:if test="${hasNextPage}">
                <a href="PerfilServlet?page=${currentPage + 1}&size=${pageSize}" class="pagination-btn">
                    <fmt:message key="paginacion.siguiente"/> <i class="fas fa-angle-right"></i>
                </a>
                <a href="PerfilServlet?page=${totalPages}&size=${pageSize}" class="pagination-btn">
                    <fmt:message key="paginacion.ultima"/> <i class="fas fa-angle-double-right"></i>
                </a>
            </c:if>
        </div>
    </div>
</c:if>

                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Opciones de cuenta -->
                    <div class="content-card">
    <div class="card-header">
        <h2 class="card-title">
            <i class="fas fa-cog"></i> <fmt:message key="account.options"/>
        </h2>
    </div>
    <div class="card-body">
        <p style="margin-bottom: 1.5rem; color: #7f8c8d;">
            <strong><fmt:message key="account.status"/></strong> 
            <span class="badge badge-success">${estadoSuscripcion}</span>
        </p>
        <form action="EliminarSuscripcionServlet" method="post" 
              onsubmit="return confirm('<fmt:message key="account.unsubscribe.confirm"/>');">
            <button type="submit" class="btn btn-danger">
                <i class="fas fa-user-times"></i> <fmt:message key="account.unsubscribe"/>
            </button>
        </form>
    </div>
</div>

                </c:if>
            </div>

            <!-- Footer -->
            <footer class="footer">
    <fmt:message key="footer.copyright"/>
    <a href="#">Escape Room Educativo</a>. 
    <fmt:message key="footer.derechos"/>
    <span style="float: right;"> <fmt:message key="footer.version"/> </span>
</footer>

        </main>
    </div>

    <script>
        function cambiarIdioma(idioma) {
            window.location.href = 'CambiarIdioma?idioma=' + idioma + '&redirect=PerfilServlet';
        }

        function changePageSize(size) {
            window.location.href = 'PerfilServlet?page=1&size=' + size;
        }
    </script>
</body>
</html>
