/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.tubespbo.controller.model;

/**
 *
 * @author achma
 */
public class Pet {
    private int id;
    private String nama;
    private String jenis;
    private int usia;
    private String foto;

    // getter & setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNama() { return nama; }
    public void setNama(String nama) { this.nama = nama; }

    public String getJenis() { return jenis; }
    public void setJenis(String jenis) { this.jenis = jenis; }

    public int getUsia() { return usia; }
    public void setUsia(int usia) { this.usia = usia; }

    public String getFoto() { return foto; }
    public void setFoto(String foto) { this.foto = foto; }
}

