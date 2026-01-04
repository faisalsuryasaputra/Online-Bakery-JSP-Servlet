package model;

public class Kategori {
    private int id;
    private String nama;
    private String deskripsi;
    private String gambar; // ✅ Tambahkan field gambar

    public Kategori() {}

    // Constructor lengkap
    public Kategori(int id, String nama, String deskripsi, String gambar) {
        this.id = id;
        this.nama = nama;
        this.deskripsi = deskripsi;
        this.gambar = gambar;
    }

    // Constructor 3 parameter
    public Kategori(int id, String nama, String deskripsi) {
        this.id = id;
        this.nama = nama;
        this.deskripsi = deskripsi;
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

    public String getGambar() {
        return gambar;
    }

    public void setGambar(String gambar) {
        this.gambar = gambar;
    }
}
