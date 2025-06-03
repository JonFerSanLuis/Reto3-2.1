package com.bilbaoskp.model;

public class Valoracion {
	int id, partida, puntuacion;
	String dificultad, recomendar, comentario;
	
	public Valoracion(int partida, int puntuacion, String dificultad, String recomendar, String comentario) {
		super();
		this.partida = partida;
		this.puntuacion = puntuacion;
		this.dificultad = dificultad;
		this.recomendar = recomendar;
		this.comentario = comentario;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getPartida() {
		return partida;
	}

	public void setPartida(int partida) {
		this.partida = partida;
	}

	public int getPuntuacion() {
		return puntuacion;
	}

	public void setPuntuacion(int puntuacion) {
		this.puntuacion = puntuacion;
	}

	public String getDificultad() {
		return dificultad;
	}

	public void setDificultad(String dificultad) {
		this.dificultad = dificultad;
	}

	public String getRecomendar() {
		return recomendar;
	}

	public void setRecomendar(String recomendar) {
		this.recomendar = recomendar;
	}

	public String getComentario() {
		return comentario;
	}

	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	
}
