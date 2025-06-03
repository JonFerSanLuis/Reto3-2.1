package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bilbaoskp.model.Valoracion;

import service.ValoracionService;

/**
 * Servlet implementation class ValoracionServlet
 */
@WebServlet("/ValoracionServlet")
public class ValoracionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	ValoracionService valoracionService;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ValoracionServlet() {
        super();
        valoracionService = new ValoracionService();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			int puntuacion = Integer.valueOf(request.getParameter("puntuacion"));
			String dificultad = request.getParameter("dificultad");
			String recomendacion = request.getParameter("recomendacion");
			String comentario = request.getParameter("comentario");
			
			Valoracion valoracion = new Valoracion(1, puntuacion, dificultad, recomendacion, comentario);
			
			if (valoracionService.addValoracion(valoracion)) {
				// Éxito - mensaje verde
				request.setAttribute("mensaje", "Valoración enviada correctamente");
				request.setAttribute("tipoMensaje", "success");
			} else {
				// Error - mensaje rojo
				request.setAttribute("mensaje", "Error al enviar la valoración. Inténtalo de nuevo.");
				request.setAttribute("tipoMensaje", "error");
			}
			
		} catch (Exception e) {
			// Error por excepción - mensaje rojo
			request.setAttribute("mensaje", "Error al procesar la valoración. Inténtalo de nuevo.");
			request.setAttribute("tipoMensaje", "error");
		}
		
		// Redirigir de vuelta a la página de valoración
		request.getRequestDispatcher("valorar-experiencia.jsp").forward(request, response);
	}

}
