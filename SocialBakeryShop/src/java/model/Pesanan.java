package model;

import java.sql.Timestamp;
import java.util.List;

public class Pesanan {
    private int id;
    private int userId;
    private double total;
    private String status;
    private String alamat;
    private String metodePembayaran;
    private String catatan;
    private Timestamp tanggalOrder;
    private Timestamp tanggalUpdate;
    private List<PesananItem> items; // Untuk relasi dengan order items

    // Status constants
    public static final String STATUS_MENUNGGU = "menunggu";
    public static final String STATUS_DIKONFIRMASI = "dikonfirmasi";
    public static final String STATUS_DIPROSES = "diproses";
    public static final String STATUS_DIKIRIM = "dikirim";
    public static final String STATUS_SELESAI = "selesai";
    public static final String STATUS_DIBATALKAN = "dibatalkan";

    public Pesanan() {}

    public Pesanan(int id, int userId, double total, String status, String alamat, 
                   String metodePembayaran, String catatan, Timestamp tanggalOrder) {
        this.id = id;
        this.userId = userId;
        this.total = total;
        this.status = status;
        this.alamat = alamat;
        this.metodePembayaran = metodePembayaran;
        this.catatan = catatan;
        this.tanggalOrder = tanggalOrder;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAlamat() { return alamat; }
    public void setAlamat(String alamat) { this.alamat = alamat; }

    public String getMetodePembayaran() { return metodePembayaran; }
    public void setMetodePembayaran(String metodePembayaran) { this.metodePembayaran = metodePembayaran; }

    public String getCatatan() { return catatan; }
    public void setCatatan(String catatan) { this.catatan = catatan; }

    public Timestamp getTanggalOrder() { return tanggalOrder; }
    public void setTanggalOrder(Timestamp tanggalOrder) { this.tanggalOrder = tanggalOrder; }

    public Timestamp getTanggalUpdate() { return tanggalUpdate; }
    public void setTanggalUpdate(Timestamp tanggalUpdate) { this.tanggalUpdate = tanggalUpdate; }

    public List<PesananItem> getItems() { return items; }
    public void setItems(List<PesananItem> items) { this.items = items; }

    // Utility methods
    public String getStatusBadgeClass() {
        switch (status) {
            case STATUS_MENUNGGU: return "bg-yellow-100 text-yellow-800";
            case STATUS_DIKONFIRMASI: return "bg-blue-100 text-blue-800";
            case STATUS_DIPROSES: return "bg-purple-100 text-purple-800";
            case STATUS_DIKIRIM: return "bg-orange-100 text-orange-800";
            case STATUS_SELESAI: return "bg-green-100 text-green-800";
            case STATUS_DIBATALKAN: return "bg-red-100 text-red-800";
            default: return "bg-gray-100 text-gray-800";
        }
    }

    public boolean canBeCancelled() {
        return STATUS_MENUNGGU.equals(status) || STATUS_DIKONFIRMASI.equals(status);
    }
}