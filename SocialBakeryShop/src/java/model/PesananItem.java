package model;

public class PesananItem {
    private int id;
    private int orderId;
    private int productId;
    private String productName;
    private int jumlah;
    private double harga;
    private double subtotal;

    public PesananItem() {}

    public PesananItem(int orderId, int productId, String productName, int jumlah, double harga) {
        this.orderId = orderId;
        this.productId = productId;
        this.productName = productName;
        this.jumlah = jumlah;
        this.harga = harga;
        this.subtotal = jumlah * harga;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getJumlah() { return jumlah; }
    public void setJumlah(int jumlah) { 
        this.jumlah = jumlah;
        this.subtotal = jumlah * harga;
    }

    public double getHarga() { return harga; }
    public void setHarga(double harga) { 
        this.harga = harga;
        this.subtotal = jumlah * harga;
    }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
}