package service;

import com.bilbaoskp.dao.SuscriptorDAO;
import com.bilbaoskp.dao.ValoracionDAO;
import com.bilbaoskp.model.Valoracion;

public class ValoracionService {

	ValoracionDAO valoracionDao;

	public ValoracionService() {
		valoracionDao = new ValoracionDAO();
	}
	
	public boolean addValoracion(Valoracion valoracion) {
		return valoracionDao.addValoracion(valoracion);
	}
}
