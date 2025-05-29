package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bilbaoskp.model.Compra;
import com.bilbaoskp.model.RankingUsuario;

import service.CompraService;
import service.RankingService;
import service.SuscriptorService;

/**
 * Servlet para manejar las peticiones relacionadas con el ranking
 */
@WebServlet("/CompraServlet")
public class ComprasServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CompraService c;
    
    public void init() {
        c = new CompraService();
    }
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetro de búsqueda si existe
        String busqueda = request.getParameter("busqueda");
        SuscriptorService s = new SuscriptorService();
        List<Compra> listaCompras;
        String username =null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
    	    for (Cookie cookie : cookies) {
    	        if ("usuario".equals(cookie.getName())) {
    	            username = cookie.getValue();
    	        }
    	    }
    	}

        	listaCompras = c.getComprasService(s.getSuscriptorByNombreService(username).getIdSuscriptor());
        
        // Guardar la lista en el request para usarla en el JSP
        request.setAttribute("listaCompra", listaCompras);
        
        // Redirigir al JSP de ranking
        request.getRequestDispatcher("compras.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}