package com.bilbaoskp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.bilbaoskp.model.Valoracion;

import db.AccesoBD;

public class ValoracionDAO {
	public boolean addValoracion(Valoracion valoracion) {
        Connection con = AccesoBD.getConnection();
        PreparedStatement ps = null;

        String sql = "INSERT INTO valoracion (partida, puntuacion, dificultad, recomendar, comentario) VALUES (?, ?, ?, ?, ?);";

        try {
            ps = con.prepareStatement(sql);

            ps.setInt(1, valoracion.getPartida());
            ps.setInt(2, valoracion.getPuntuacion());
            ps.setString(3, valoracion.getDificultad());
            ps.setString(4, valoracion.getRecomendar());
            ps.setString(5, valoracion.getComentario());

            if (ps.executeUpdate() > 0) {
                return true;
            } else {
                return false;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            AccesoBD.closeConnection(null, ps, con);
        }

        return false;
    }
}
