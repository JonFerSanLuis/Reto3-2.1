package service;

import java.sql.SQLException;

import com.bilbaoskp.dao.PartidaDAO;
import com.bilbaoskp.model.Partida;

public class PartidasService {
	
	public boolean registrarPartida (Partida partida, int codCentro) {
		PartidaDAO p = new PartidaDAO();
		try {
			return p.guardarPartida(partida, codCentro);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}

}
