package com.bilbaoskp.dao;

import java.sql.Connection;
import java.util.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.bilbaoskp.model.Partida;

import db.AccesoBD;

public class PartidaDAO {
	 public boolean guardarPartida(Partida partida, int idSuscriptor) throws SQLException {
	        String sql = """
	            INSERT INTO partida (id_suscriptor, nombre, tipo_partida, fecha, idioma)
	            VALUES (?, ?, ?, ?, ?)
	        			""";

	        try (Connection con = AccesoBD.getConnection();
	                PreparedStatement ps = con.prepareStatement(sql)) {
	        		ps.setInt(1, idSuscriptor);
	        		ps.setString(2, partida.getNombre());
	        		ps.setString(3, partida.getTipoPartida());
	        		ps.setDate(4, new java.sql.Date(partida.getFecha().getTime()));
	        		ps.setString(5, partida.getIdioma());

	               return ps.executeUpdate() == 1;
	           }
	       }
}
