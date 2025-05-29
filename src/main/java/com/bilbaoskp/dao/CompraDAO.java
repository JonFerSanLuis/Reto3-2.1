package com.bilbaoskp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.bilbaoskp.model.Compra;
import com.bilbaoskp.model.Cupon;

import db.AccesoBD;

public class CompraDAO {
	
	private Compra mapResultSetToCupon(ResultSet rs) throws SQLException {
        Compra compra = new Compra();
        compra.setProducto(rs.getString("producto"));
        compra.setCodCompra(rs.getInt("cod_compra"));
        compra.setFecha(rs.getDate("fecha"));
        compra.setIdSuscriptor(rs.getInt("id_suscriptor"));
        
        return compra;
    }
	
	public List<Compra> getComprasByIdSus(int id) {
        List<Compra> compras = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = AccesoBD.getConnection();
            String sql = "SELECT * FROM compra WHERE id_suscriptor = (SELECT id_suscriptor FROM suscriptores WHERE id_suscriptor = ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Compra compra = mapResultSetToCupon(rs);
                compras.add(compra);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            AccesoBD.closeConnection(rs, ps, con);
        }
        
        return compras;
    }

}
