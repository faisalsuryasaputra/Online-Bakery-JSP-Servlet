package model;

public class Produk {
    private int id;
    private String nama;
    private String deskripsi;
    private double harga;
    private Kategori kategori;
    private String gambar; // tambahan untuk menyimpan path gambar

    public Produk() {}

    // Constructor lengkap
    public Produk(int id, String nama, String deskripsi, double harga, Kategori kategori, String gambar) {
        this.id = id;
        this.nama = nama;
        this.deskripsi = deskripsi;
        this.harga = harga;
        this.kategori = kategori;
        this.gambar = gambar;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNama() {
        return nama;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public String getDeskripsi() {
        return deskripsi;
    }

    public void setDeskripsi(String deskripsi) {
        this.deskripsi = deskripsi;
    }

    public double getHarga() {
        return harga;
    }

    public void setHarga(double harga) {
        this.harga = harga;
    }

    public Kategori getKategori() {
        return kategori;
    }

    public void setKategori(Kategori kategori) {
        this.kategori = kategori;
    }

    public String getGambar() {
        return gambar;
    }

    public void setGambar(String gambar) {
        this.gambar = gambar;
    }
}
