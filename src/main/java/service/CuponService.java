package service;

import java.util.List;

import com.bilbaoskp.dao.CuponDAO;
import com.bilbaoskp.model.Cupon;

public class CuponService {
	
	public boolean asignarCuponService(Cupon cupon) {
		CuponDAO c = new CuponDAO();
		return c.asignarCupon(cupon);
	}
	
	public List<Cupon> getCuponesDisponiblesService (int id) {
		CuponDAO c = new CuponDAO();
		return c.getCuponesDisponibles(id);
	}
	
	public boolean updateEstadoCuponService(int id, String estado) {
		CuponDAO c = new CuponDAO();
		return c.updateCuponEstado(id, estado);
	}
	
	public List<Cupon> getCuponesByIdSus(int id) {
		CuponDAO c = new CuponDAO();
		return c.getCuponesByIdSus(id);
	}
	
	public List<Cupon> getCuponesPorSuscriptor(String username){
		CuponDAO c = new CuponDAO();
		return c.obtenerCuponesPorSuscriptor(username);
	}
	
	public boolean eliminarCuponRandom(int idsuscriptor) {
		CuponDAO c = new CuponDAO();
		return c.eliminarCuponbySus(idsuscriptor);
	}
	
	public boolean eliminarCupon(int idCupon) {
		CuponDAO c = new CuponDAO();
        return c.eliminarCupon(idCupon);  // Llama al DAO para eliminar el cup�n
    }
	
	public int getLastIdService() {
		CuponDAO c = new CuponDAO();
		return c.getLastID();
	}
	
	public Cupon getCuponByIdCuponService(int id) {
		CuponDAO c = new CuponDAO();
		return c.getCuponByCuponId(id);
	}
}
