package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.bilbaoskp.dao.PartidaDAO;
import com.bilbaoskp.model.Centro;
import com.bilbaoskp.model.Cupon;
import com.bilbaoskp.model.Partida;

import service.CentroService;
import service.CuponService;
import service.PartidasService;
import service.SuscriptorService;

@WebServlet("/ProcesarPartidaServlet")
public class ProcesarPartidaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	Cookie[] cookies = request.getCookies();
    	String username = null;
    	String cookieType = null;
    	
    	if (cookies != null) {
    	    for (Cookie cookie : cookies) {
    	        if ("usuario".equals(cookie.getName())) {
    	            username = cookie.getValue();
    	        }else if ("tipo".equals(cookie.getName())) {
    	        	cookieType = cookie.getValue();
    	        }
    	    }
    	}
    	
    	if (cookieType == null || !cookieType.equals("centro")) {
    	    response.sendRedirect("login.jsp");
    	    return;
    	}
    	
    	int cupones = Integer.parseInt(request.getParameter("cantidad"));
    	System.out.println(cupones);
    	
    	CuponService cs = new CuponService();
    	SuscriptorService s = new SuscriptorService();
    	PartidasService p = new PartidasService();
    	CentroService centro = new CentroService();
    	List <Cupon> cuponesDisponibles;
    	cuponesDisponibles = cs.getCuponesDisponiblesService(s.getSuscriptorByNombreService(username).getIdSuscriptor());
    	
    	int disponibles = cuponesDisponibles.size();
    	
    	if (cupones > disponibles) {
    		request.setAttribute("errorCupones", "No hay suficientes cupones disponibles.");
    	    request.getRequestDispatcher("organizarPartida.jsp").forward(request, response);
    	}else {
    		for(int a=0; a<cupones; a++) {
    			//cambio estado del cupon
    			cs.updateEstadoCuponService(s.getSuscriptorByNombreService(username).getIdSuscriptor(), "en uso");
    			
    			//se registran las partidas
    			Partida partida = new Partida();
    			System.out.println(request.getParameter("fechaActivacion"));
    			String fechaParam = request.getParameter("fechaActivacion");
    			Date fecha = null;

    			try {
    		    // Parsear el String con formato yyyy-MM-dd a java.util.Date
    				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    				fecha = sdf.parse(fechaParam);
    			} catch (ParseException e) {
    				e.printStackTrace();
    				request.setAttribute("errorFecha", "Fecha inválida.");
    				request.getRequestDispatcher("organizarPartida.jsp").forward(request, response);
    				return;
    			}
    				partida.setFecha(fecha);
    				partida.setIdioma(request.getParameter("idioma"));
    				partida.setNombre("Bullying");
    				partida.setTipoPartida("centro");
    				p.registrarPartida(partida, s.getSuscriptorByNombreService(username).getIdSuscriptor());
    			}
    		
    		

    		response.sendRedirect("PerfilServlet");
    	}
    	
    }

    private String generarCodigo() {
        String letras = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String numeros = "0123456789";
        Random r = new Random();
        return "" + letras.charAt(r.nextInt(26)) + letras.charAt(r.nextInt(26)) + letras.charAt(r.nextInt(26))
                + numeros.charAt(r.nextInt(10)) + numeros.charAt(r.nextInt(10)) + numeros.charAt(r.nextInt(10));
    }
}

