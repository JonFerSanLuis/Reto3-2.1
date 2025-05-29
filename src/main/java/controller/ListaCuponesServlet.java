package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bilbaoskp.model.Cupon;
import service.CuponService;

/**
 * Servlet implementation class ListaCuponesServlet
 */
@WebServlet("/ListaCuponesServlet")
public class ListaCuponesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    CuponService cuponService;

    public void init() {
        cuponService = new CuponService();
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
            request.setAttribute("username", username);
            
            // Redirigir a la JSP de lista de cupones
            request.getRequestDispatcher("lista-cupones.jsp").forward(request, response);
        } else {
            // Si el usuario no está logueado, redirigir al login
            response.sendRedirect("login.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
