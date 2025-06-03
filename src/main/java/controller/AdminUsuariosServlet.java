package controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bilbaoskp.dao.SuscriptorDAO;
import com.bilbaoskp.model.Cupon;
import com.bilbaoskp.model.Suscriptor;

import service.CentroService;
import service.CuponService;

@WebServlet("/AdminUsuarios")
public class AdminUsuariosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private SuscriptorDAO suscriptorDAO;
    
    public void init() {
        suscriptorDAO = new SuscriptorDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "listar";
        }
        
        switch (action) {
            case "editar":
                mostrarFormularioEdicion(request, response);
                break;
            case "detalles":
                mostrarDetallesUsuario(request, response);
                break;
            case "listarPendientes":
                listarCentrosPendientes(request, response);
                break;
            case "listarSolicitudesBaja":
                listarSolicitudesBaja(request, response);
                break;
            default:
                listarUsuarios(request, response);
                break;
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "listar";
        }
        
        switch (action) {
            case "actualizar":
                actualizarUsuario(request, response);
                break;
            case "eliminar":
                eliminarUsuario(request, response);
                break;
            case "aceptarCentro":
                aceptarCentro(request, response);
                break;
            case "rechazarCentro":
                rechazarCentro(request, response);
                break;
            case "confirmarBaja":
                confirmarBajaCentro(request, response);
                break;
            case "rechazarBaja":
                rechazarBajaCentro(request, response);
                break;
            default:
                listarUsuarios(request, response);
                break;
        }
    }
    
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idBusqueda = request.getParameter("id");
        String nombreBusqueda = request.getParameter("nombre");
        
        List<Suscriptor> usuarios;
        
        if (idBusqueda != null && !idBusqueda.isEmpty()) {
            try {
                int id = Integer.parseInt(idBusqueda);
                Suscriptor usuario = suscriptorDAO.getSuscriptorById(id);
                usuarios = usuario != null ? List.of(usuario) : List.of();
            } catch (NumberFormatException e) {
                usuarios = List.of();
            }
        } else if (nombreBusqueda != null && !nombreBusqueda.isEmpty()) {
            usuarios = suscriptorDAO.getSuscriptoresByNombre(nombreBusqueda);
        } else {
            usuarios = suscriptorDAO.getAllSuscriptores();
        }
        
        request.setAttribute("listaUsuarios", usuarios);
        request.getRequestDispatcher("private/admin-usuarios.jsp").forward(request, response);
    }
    
    private void listarCentrosPendientes(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Suscriptor> centrosPendientes = suscriptorDAO.getSuscriptoresByTipoAndEstado("centro", "pendiente");
        request.setAttribute("listaCentrosPendientes", centrosPendientes);
        request.getRequestDispatcher("private/admin-pending-centers.jsp").forward(request, response);
    }
    
    // NUEVA FUNCIONALIDAD: Listar solicitudes de baja
    private void listarSolicitudesBaja(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Suscriptor> solicitudesBaja = suscriptorDAO.getSuscriptoresByTipoAndEstado("centro", "solicitud_baja");
        request.setAttribute("listaSolicitudesBaja", solicitudesBaja);
        request.getRequestDispatcher("private/admin-solicitudes-baja.jsp").forward(request, response);
    }
    
    private void mostrarFormularioEdicion(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Suscriptor usuario = suscriptorDAO.getSuscriptorById(id);
            
            if (usuario != null) {
                request.setAttribute("usuario", usuario);
                request.getRequestDispatcher("private/admin-editar-usuario.jsp").forward(request, response);
            } else {
                response.sendRedirect("AdminUsuarios");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("AdminUsuarios");
        }
    }
    
    private void mostrarDetallesUsuario(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Suscriptor usuario = suscriptorDAO.getSuscriptorById(id);
            
            if (usuario != null) {
                request.setAttribute("usuario", usuario);
                request.getRequestDispatcher("private/admin-editar-usuario.jsp").forward(request, response);
            } else {
                response.sendRedirect("AdminUsuarios");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("AdminUsuarios");
        }
    }
    
    private void actualizarUsuario(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Suscriptor usuario = suscriptorDAO.getSuscriptorById(id);
            
            if (usuario != null) {
                usuario.setUsername(request.getParameter("username"));
                usuario.setCorreo(request.getParameter("correo"));
                usuario.setTipo(request.getParameter("tipo"));
                usuario.setEstado(request.getParameter("estado"));
                
                String edadStr = request.getParameter("edad");
                if (edadStr != null && !edadStr.isEmpty()) {
                    try {
                        usuario.setEdad(Integer.parseInt(edadStr));
                    } catch (NumberFormatException e) {
                        // Si hay error en la conversión, se deja el valor actual
                    }
                }
                
                String nuevaPassword = request.getParameter("nuevaPassword");
                if (nuevaPassword != null && !nuevaPassword.isEmpty()) {
                    usuario.setPassword(nuevaPassword);
                }
                
                boolean actualizado = suscriptorDAO.updateSuscriptor(usuario);
                
                if (actualizado) {
                    request.getSession().setAttribute("mensaje", "Usuario actualizado correctamente");
                } else {
                    request.getSession().setAttribute("error", "Error al actualizar el usuario");
                }
            }
            
            response.sendRedirect("AdminUsuarios");
        } catch (NumberFormatException e) {
            response.sendRedirect("AdminUsuarios");
        }
    }
    
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            boolean eliminado = suscriptorDAO.deleteSuscriptor(id);
            
            if (eliminado) {
                request.getSession().setAttribute("mensaje", "Usuario eliminado correctamente");
            } else {
                request.getSession().setAttribute("error", "Error al eliminar el usuario");
            }
            
            response.sendRedirect("AdminUsuarios");
        } catch (NumberFormatException e) {
            response.sendRedirect("AdminUsuarios");
        }
    }
    
    private void aceptarCentro(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Suscriptor suscriptor = suscriptorDAO.getSuscriptorById(id);

            if (suscriptor != null) {
                suscriptor.setEstado("activo");
                boolean actualizado = suscriptorDAO.updateSuscriptor(suscriptor);
                CentroService c = new CentroService();
                
                // Asignar cupones al responsable
                int alumnos = 0;
                try {
                    alumnos = c.getCentroByName(suscriptorDAO.getSuscriptorById(id).getUsername()).getNumAlumnos();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                
                for (int a = 0; a < alumnos; a++) {
                    Cupon cupon = new Cupon();
                    cupon.setIdSuscriptor(id);
                    cupon.setTipo("REGALO");

                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date(System.currentTimeMillis()));
                    calendar.add(Calendar.YEAR, 1);
                    Date fechaCaducidad = new Date(calendar.getTimeInMillis());

                    cupon.setFechaCaducidad(fechaCaducidad);
                    cupon.setEstado("disponible");

                    CuponService cup = new CuponService();
                    cup.asignarCuponService(cupon);
                }

                if (actualizado) {
                    request.getSession().setAttribute("mensaje", "Centro aceptado correctamente.");
                } else {
                    request.getSession().setAttribute("error", "Error al aceptar el centro.");
                }
            } else {
                request.getSession().setAttribute("error", "Centro no encontrado.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID de centro inválido.");
        }
        response.sendRedirect("AdminUsuarios?action=listarPendientes");
    }
    
    private void rechazarCentro(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean eliminado = suscriptorDAO.deleteSuscriptor(id);
            
            if (eliminado) {
                request.getSession().setAttribute("mensaje", "Centro rechazado correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al rechazar el centro.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID de centro inválido.");
        }
        response.sendRedirect("AdminUsuarios?action=listarPendientes");
    }
    
    // NUEVAS FUNCIONALIDADES: Confirmar y rechazar bajas
    private void confirmarBajaCentro(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean eliminado = suscriptorDAO.deleteSuscriptor(id);
            
            if (eliminado) {
                request.getSession().setAttribute("mensaje", "Baja de centro confirmada correctamente.");
            } else {
                request.getSession().setAttribute("error", "Error al confirmar la baja del centro.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID de centro inválido.");
        }
        response.sendRedirect("AdminUsuarios?action=listarSolicitudesBaja");
    }
    
    private void rechazarBajaCentro(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Suscriptor suscriptor = suscriptorDAO.getSuscriptorById(id);
            
            if (suscriptor != null) {
                // Volver el estado a "activo"
                suscriptor.setEstado("activo");
                boolean actualizado = suscriptorDAO.updateSuscriptor(suscriptor);
                
                if (actualizado) {
                    request.getSession().setAttribute("mensaje", "Solicitud de baja rechazada. El centro sigue activo.");
                } else {
                    request.getSession().setAttribute("error", "Error al rechazar la solicitud de baja.");
                }
            } else {
                request.getSession().setAttribute("error", "Centro no encontrado.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID de centro inválido.");
        }
        response.sendRedirect("AdminUsuarios?action=listarSolicitudesBaja");
    }
}
