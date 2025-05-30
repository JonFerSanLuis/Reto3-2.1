package com.bilbaoskp.model;

import java.util.Date;

public class Compra {
	private String producto;
    private int codCompra;
    private double pago;
    private Date fecha;
    private int idCupon;
    private int idSuscriptor;

    // Constructores
    public Compra() {
    }

    public Compra(String producto, int codCompra, double pago, Date fecha, int idCupon, int idSuscriptor) {
    	this.producto = producto;
        this.codCompra = codCompra;
        this.pago = pago;
        this.fecha = fecha;
        this.idCupon = idCupon;
        this.idSuscriptor = idSuscriptor;
    }

    // Getters y Setters
    
    
    public int getCodCompra() {
        return codCompra;
    }

    public int getIdSuscriptor() {
		return idSuscriptor;
	}

	public void setIdSuscriptor(int idSuscriptor) {
		this.idSuscriptor = idSuscriptor;
	}

	public String getProducto() {
		return producto;
	}

	public void setProducto(String producto) {
		this.producto = producto;
	}

	public void setCodCompra(int codCompra) {
        this.codCompra = codCompra;
    }

    public double getPago() {
        return pago;
    }

    public void setPago(double pago) {
        this.pago = pago;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public int getIdCupon() {
        return idCupon;
    }

    public void setIdCupon(int idSuscriptor) {
        this.idCupon = idSuscriptor;
    }

    @Override
    public String toString() {
        return "Compra{" +
                "codCompra=" + codCompra +
                ", pago=" + pago +
                ", fecha=" + fecha +
                ", idCupon=" + idCupon +
                '}';
    }
}