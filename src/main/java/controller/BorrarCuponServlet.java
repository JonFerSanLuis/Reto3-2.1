package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bilbaoskp.model.Cupon;

import service.CuponService;

@WebServlet("/BorrarCuponServlet")
public class BorrarCuponServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    CuponService cuponService;

    public void init() {
        cuponService = new CuponService();  // Inicializa el servicio de cupones
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener el ID del cup�n desde el formulario
        String idCupon = request.getParameter("idCupon");
        System.out.println(idCupon);
        Cupon cupon = cuponService.getCuponByIdCuponService(Integer.parseInt(idCupon));
        if (idCupon != null && cupon.getEstado().equals("disponible")) {
            // Eliminar el cup�n usando el servicio
            boolean eliminado = cuponService.eliminarCupon(Integer.parseInt(idCupon));

            if (eliminado) {
                // Redirigir al perfil con un mensaje de �xito
                request.getSession().setAttribute("mensaje", "Cup�n devuelto correctamente.");
            }else {
                // Redirigir al perfil con un mensaje de error
                request.getSession().setAttribute("error", "Error al devolver el cup�n.");
            }
        } else {
            request.getSession().setAttribute("error", "El cup�n est� en uso o ya ha sido gastado");
        }

        // Redirigir al perfil
        response.sendRedirect("PerfilServlet");
    }
}
