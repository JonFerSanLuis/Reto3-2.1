// Servlet corregido para usar centros pendientes

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

/**
 * Servlet implementation class PerfilServlet
 */
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

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            // Obtener los cupones del suscriptor
            java.util.List<Cupon> cupones = cuponService.getCuponesPorSuscriptor(username);
            request.setAttribute("listaCupones", cupones);
            
            // Verificar si el usuario es administrador
            Boolean isAdmin = (Boolean) request.getSession().getAttribute("isAdmin");
            
            if (isAdmin != null && isAdmin) {
                // Datos para el dashboard de administrador
                try {
                    int usuariosActivos = suscriptorDAO.contarUsuariosActivos();
                    int usuariosInactivos = suscriptorDAO.contarUsuariosInactivos();
                    int centrosPendientes = suscriptorDAO.contarCentrosPendientes(); // Cambiado aquí
                    int totalCupones = cuponDAO.contarCuponesTotales();
                    
                    // Establecer atributos para el JSP
                    request.setAttribute("usuariosActivos", usuariosActivos);
                    request.setAttribute("usuariosInactivos", usuariosInactivos);
                    request.setAttribute("centrosPendientes", centrosPendientes); // Cambiado aquí
                    request.setAttribute("totalCupones", totalCupones);
                } catch (Exception e) {
                    // En caso de error, usar valores predeterminados
                    request.setAttribute("usuariosActivos", 0);
                    request.setAttribute("usuariosInactivos", 0);
                    request.setAttribute("centrosPendientes", 0); // Cambiado aquí
                    request.setAttribute("totalCupones", 0);
                    e.printStackTrace();
                }
            } else {
                // Obtener estadísticas para usuarios normales (no administradores)
                try {
                    com.bilbaoskp.model.Suscriptor suscriptor = suscriptorService.getSuscriptorByNombreService(username);
                    if (suscriptor != null) {
                        // Contar cupones del usuario
                        int totalCuponesUsuario = cupones.size();
                        int cuponesDisponibles = 0;
                        int cuponesUsados = 0;
                        
                        for (com.bilbaoskp.model.Cupon cupon : cupones) {
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
                        
                        // Debug: imprimir el ranking para verificar
                        System.out.println("=== DEBUG RANKING ===");
                        System.out.println("Buscando usuario: '" + username + "'");
                        
                        for (com.bilbaoskp.model.RankingUsuario usuario : ranking) {
                            System.out.println("Usuario en ranking: '" + usuario.getNombre() + "' - Puntos: " + usuario.getPuntuacion() + " - Partidas: " + usuario.getPartidas());
                            
                            // Comparación más robusta (trim y equalsIgnoreCase)
                            if (usuario.getNombre() != null && usuario.getNombre().trim().equalsIgnoreCase(username.trim())) {
                                partidasJugadas = usuario.getPartidas();
                                puntosTotales = usuario.getPuntuacion();
                                System.out.println("¡ENCONTRADO! Partidas: " + partidasJugadas + ", Puntos: " + puntosTotales);
                                break;
                            }
                        }
                        
                        System.out.println("Resultado final - Partidas: " + partidasJugadas + ", Puntos: " + puntosTotales);
                        System.out.println("=== FIN DEBUG ===");
                        
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

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
