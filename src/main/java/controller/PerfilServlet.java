package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bilbaoskp.model.Cupon;
import com.bilbaoskp.dao.SuscriptorDAO;
import com.bilbaoskp.dao.CuponDAO;
import com.bilbaoskp.dao.RankingDAO;

import service.CuponService;
import service.SuscriptorService;

@WebServlet("/PerfilServlet")
public class PerfilServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    CuponService cuponService;
    SuscriptorService suscriptorService;
    SuscriptorDAO suscriptorDAO;
    CuponDAO cuponDAO;
    RankingDAO rankingDAO;

    public void init() {
        cuponService = new CuponService();
        suscriptorService = new SuscriptorService();
        suscriptorDAO = new SuscriptorDAO();
        cuponDAO = new CuponDAO();
        rankingDAO = new RankingDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Obtener el nombre de usuario desde las cookies
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
        
        if (username != null) {
            // Obtener parámetros de paginación
            String pageParam = request.getParameter("page");
            String sizeParam = request.getParameter("size");

            int page = 1;
            int size = 10; // 10 cupones por página por defecto

            try {
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                }
                if (sizeParam != null && !sizeParam.isEmpty()) {
                    size = Integer.parseInt(sizeParam);
                    if (size < 5) size = 5;
                    if (size > 50) size = 50; // Máximo 50 por página
                }
            } catch (NumberFormatException e) {
                page = 1;
                size = 10;
            }

            // Obtener todos los cupones del suscriptor
            java.util.List<Cupon> todosCupones = cuponService.getCuponesPorSuscriptor(username);
            int totalCupones = todosCupones.size();
            int totalPages = (int) Math.ceil((double) totalCupones / size);

            // Calcular índices para la paginación
            int startIndex = (page - 1) * size;
            int endIndex = Math.min(startIndex + size, totalCupones);

            // Obtener cupones para la página actual
            java.util.List<Cupon> cupones = new java.util.ArrayList<>();
            if (startIndex < totalCupones) {
                cupones = todosCupones.subList(startIndex, endIndex);
            }

            // Establecer atributos para la paginación
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", size);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCupones", totalCupones);
            request.setAttribute("hasNextPage", page < totalPages);
            request.setAttribute("hasPreviousPage", page > 1);
            
            request.setAttribute("listaCupones", cupones);
            
            // Verificar si el usuario es administrador
            Boolean isAdmin = (Boolean) request.getSession().getAttribute("isAdmin");
            
            if (isAdmin != null && isAdmin) {
                // Datos para el dashboard de administrador
                try {
                    int usuariosActivos = suscriptorDAO.contarUsuariosActivos();
                    int solicitudesBaja = suscriptorDAO.contarSolicitudesBaja(); // CAMBIADO
                    int centrosPendientes = suscriptorDAO.contarCentrosPendientes();
                    int totalCuponesAdmin = cuponDAO.contarCuponesTotales();
                    
                    // Establecer atributos para el JSP
                    request.setAttribute("usuariosActivos", usuariosActivos);
                    request.setAttribute("solicitudesBaja", solicitudesBaja); // CAMBIADO
                    request.setAttribute("centrosPendientes", centrosPendientes);
                    request.setAttribute("totalCupones", totalCuponesAdmin);
                } catch (Exception e) {
                    // En caso de error, usar valores predeterminados
                    request.setAttribute("usuariosActivos", 0);
                    request.setAttribute("solicitudesBaja", 0); // CAMBIADO
                    request.setAttribute("centrosPendientes", 0);
                    request.setAttribute("totalCupones", 0);
                    e.printStackTrace();
                }
            } else {
                // Obtener estadísticas para usuarios normales (no administradores)
                try {
                    com.bilbaoskp.model.Suscriptor suscriptor = suscriptorService.getSuscriptorByNombreService(username);
                    if (suscriptor != null) {
                        // Contar cupones del usuario
                        int totalCuponesUsuario = todosCupones.size();
                        int cuponesDisponibles = 0;
                        int cuponesUsados = 0;
                        
                        for (com.bilbaoskp.model.Cupon cupon : todosCupones) {
                            if ("disponible".equals(cupon.getEstado())) {
                                cuponesDisponibles++;
                            } else if ("usado".equals(cupon.getEstado())) {
                                cuponesUsados++;
                            }
                        }
                        
                        // Obtener partidas jugadas desde escape_room
                        java.util.List<com.bilbaoskp.model.RankingUsuario> ranking = rankingDAO.obtenerRanking();
                        int partidasJugadas = 0;
                        int puntosTotales = 0;
                        
                        for (com.bilbaoskp.model.RankingUsuario usuario : ranking) {
                            if (usuario.getNombre() != null && usuario.getNombre().trim().equalsIgnoreCase(username.trim())) {
                                partidasJugadas = usuario.getPartidas();
                                puntosTotales = usuario.getPuntuacion();
                                break;
                            }
                        }
                        
                        // Estado de suscripción
                        String estadoSuscripcion = suscriptor.getEstado();
                        
                        // Establecer atributos para el JSP
                        request.setAttribute("totalCuponesUsuario", totalCuponesUsuario);
                        request.setAttribute("cuponesDisponibles", cuponesDisponibles);
                        request.setAttribute("cuponesUsados", cuponesUsados);
                        request.setAttribute("partidasJugadas", partidasJugadas);
                        request.setAttribute("puntosTotales", puntosTotales);
                        request.setAttribute("estadoSuscripcion", estadoSuscripcion);
                    }
                } catch (Exception e) {
                    // En caso de error, usar valores predeterminados
                    request.setAttribute("totalCuponesUsuario", 0);
                    request.setAttribute("cuponesDisponibles", 0);
                    request.setAttribute("cuponesUsados", 0);
                    request.setAttribute("partidasJugadas", 0);
                    request.setAttribute("puntosTotales", 0);
                    request.setAttribute("estadoSuscripcion", "inactivo");
                    e.printStackTrace();
                }
            }

            // Redirigir a la JSP del perfil
            request.getRequestDispatcher("perfil.jsp").forward(request, response);
        } else {
            // Si el usuario no está en la sesión, redirigir al login
            response.sendRedirect("login.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
