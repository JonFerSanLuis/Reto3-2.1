package service;

import java.util.List;

import com.bilbaoskp.dao.RankingDAO;
import com.bilbaoskp.model.RankingUsuario;

/**
 * Servicio para manejar la l�gica de negocio del ranking
 */
public class RankingService {
    
    private RankingDAO rankingDAO;
    
    public RankingService() {
        rankingDAO = new RankingDAO();
    }
    
    /**
     * Obtiene la lista completa del ranking
     * @return Lista de usuarios ordenados por puntuaci�n
     */
    public List<RankingUsuario> obtenerRanking() {
        return rankingDAO.obtenerRanking();
    }
    
    /**
     * Busca usuarios en el ranking por nombre
     * @param nombreBusqueda Nombre o parte del nombre a buscar
     * @return Lista de usuarios que coinciden con la b�squeda
     */
    public List<RankingUsuario> buscarUsuariosPorNombre(String nombreBusqueda) {
        return rankingDAO.buscarUsuariosPorNombre(nombreBusqueda);
    }
}