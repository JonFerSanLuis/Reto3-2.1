package service;

import java.util.List;

import com.bilbaoskp.dao.CompraDAO;
import com.bilbaoskp.model.Compra;

public class CompraService {
	
	public List<Compra> getComprasService(int id){
		CompraDAO c = new CompraDAO();
		return c.getComprasByIdSus(id);
	}

}
