package model;

public class DetailPesanan {
    private int id;
    private int orderId;
    private int productId;
    private int jumlah;
    private double subtotal;

    public DetailPesanan() {}

    public DetailPesanan(int id, int orderId, int productId, int jumlah, double subtotal) {
        this.id = id;
        this.orderId = orderId;
        this.productId = productId;
        this.jumlah = jumlah;
        this.subtotal = subtotal;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getJumlah() {
        return jumlah;
    }

    public void setJumlah(int jumlah) {
        this.jumlah = jumlah;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }
}
