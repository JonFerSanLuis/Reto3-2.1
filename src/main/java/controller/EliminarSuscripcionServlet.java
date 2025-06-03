package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bilbaoskp.dao.SuscriptorDAO;
import com.bilbaoskp.model.Suscriptor;
import service.SuscriptorService;

@WebServlet("/EliminarSuscripcionServlet")
public class EliminarSuscripcionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    SuscriptorService suscriptorService;
    SuscriptorDAO suscriptorDAO;
       
    public EliminarSuscripcionServlet() {
        super();
        suscriptorService = new SuscriptorService();
        suscriptorDAO = new SuscriptorDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Obtener username de las cookies
        String username = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("usuario".equals(cookie.getName())) {
                    username = java.net.URLDecoder.decode(cookie.getValue(), "UTF-8");
                    break;
                }
            }
        }
        
        if (username != null) {
            try {
                // Obtener el suscriptor para verificar su tipo
                Suscriptor suscriptor = SuscriptorDAO.getSuscriptorByNombre(username);
                
                if (suscriptor != null) {
                    // Verificar si es un centro o usuario normal
                    if ("centro".equals(suscriptor.getTipo())) {
                        // Si es centro: marcar como solicitud de baja
                        suscriptor.setEstado("solicitud_baja");
                        boolean actualizado = suscriptorDAO.updateSuscriptor(suscriptor);
                        
                        if (actualizado) {
                            request.getSession().setAttribute("mensaje", 
                                "Solicitud de baja enviada correctamente. El administrador revisará tu solicitud.");
                            response.sendRedirect("PerfilServlet");
                        } else {
                            request.getSession().setAttribute("error", 
                                "Error al procesar la solicitud de baja.");
                            response.sendRedirect("PerfilServlet");
                        }
                    } else {
                        // Si es usuario normal: eliminar directamente (funcionalidad original)
                        if (suscriptorService.deleteSuscriptor(username)) {
                            // Eliminar cookies
                            if (cookies != null) {
                                for (Cookie cookie : cookies) {
                                    if ("usuario".equals(cookie.getName()) || "tipo".equals(cookie.getName())) {
                                        cookie.setMaxAge(0);
                                        cookie.setPath("/");
                                        response.addCookie(cookie);
                                    }
                                }
                            }
                            request.getSession().invalidate();
                            response.sendRedirect("login.jsp?mensaje=Suscripción eliminada correctamente");
                        } else {
                            request.getSession().setAttribute("error", 
                                "Error al eliminar la suscripción.");
                            response.sendRedirect("PerfilServlet");
                        }
                    }
                } else {
                    request.getSession().setAttribute("error", "Usuario no encontrado.");
                    response.sendRedirect("PerfilServlet");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("error", 
                    "Error al procesar la solicitud: " + e.getMessage());
                response.sendRedirect("PerfilServlet");
                e.printStackTrace();
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
