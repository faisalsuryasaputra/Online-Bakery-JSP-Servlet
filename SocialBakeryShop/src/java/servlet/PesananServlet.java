package servlet;

import classes.JDBC;
import model.Pesanan;
import model.PesananItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/PesananServlet")
public class PesananServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        int userId = ((model.Pengguna) session.getAttribute("pengguna")).getId();

        try {
            if ("detail".equals(action)) {
                showOrderDetail(request, response, userId);
            } else if ("cancel".equals(action)) {
                cancelOrder(request, response, userId);
            } else {
                showOrderList(request, response, userId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Terjadi kesalahan database: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void showOrderList(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws SQLException, ServletException, IOException {
        
        List<Pesanan> daftarPesanan = new ArrayList<>();
        String statusFilter = request.getParameter("status");

        try (Connection conn = JDBC.getConnection()) {
            StringBuilder sql = new StringBuilder(
                "SELECT p.* FROM pesanan p WHERE p.user_id = ?"
            );
            
            if (statusFilter != null && !statusFilter.isEmpty()) {
                sql.append(" AND p.status = ?");
            }
            
            sql.append(" ORDER BY p.tanggal_order DESC");

            PreparedStatement stmt = conn.prepareStatement(sql.toString());
            stmt.setInt(1, userId);
            
            if (statusFilter != null && !statusFilter.isEmpty()) {
                stmt.setString(2, statusFilter);
            }

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Pesanan p = new Pesanan();
                p.setId(rs.getInt("id"));
                p.setUserId(rs.getInt("user_id"));
                p.setTotal(rs.getDouble("total"));
                p.setStatus(rs.getString("status"));
                p.setAlamat(rs.getString("alamat"));
                
                // Handle nullable columns safely
                String metodePembayaran = rs.getString("metode_pembayaran");
                p.setMetodePembayaran(metodePembayaran != null ? metodePembayaran : "");
                
                String catatan = rs.getString("catatan");
                p.setCatatan(catatan != null ? catatan : "");
                
                p.setTanggalOrder(rs.getTimestamp("tanggal_order"));
                
                Timestamp tanggalUpdate = rs.getTimestamp("tanggal_update");
                p.setTanggalUpdate(tanggalUpdate);
                
                daftarPesanan.add(p);
            }
        }

        request.setAttribute("daftarPesanan", daftarPesanan);
        request.setAttribute("statusFilter", statusFilter);
        request.getRequestDispatcher("pesanan_user.jsp").forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws SQLException, ServletException, IOException {
        
        int orderId = Integer.parseInt(request.getParameter("id"));
        Pesanan pesanan = null;
        List<PesananItem> orderItems = new ArrayList<>();

        try (Connection conn = JDBC.getConnection()) {
            // Get order details
            String orderSql = "SELECT * FROM pesanan WHERE id = ? AND user_id = ?";
            PreparedStatement orderStmt = conn.prepareStatement(orderSql);
            orderStmt.setInt(1, orderId);
            orderStmt.setInt(2, userId);
            ResultSet orderRs = orderStmt.executeQuery();

            if (orderRs.next()) {
                pesanan = new Pesanan();
                pesanan.setId(orderRs.getInt("id"));
                pesanan.setUserId(orderRs.getInt("user_id"));
                pesanan.setTotal(orderRs.getDouble("total"));
                pesanan.setStatus(orderRs.getString("status"));
                pesanan.setAlamat(orderRs.getString("alamat"));
                
                String metodePembayaran = orderRs.getString("metode_pembayaran");
                pesanan.setMetodePembayaran(metodePembayaran != null ? metodePembayaran : "");
                
                String catatan = orderRs.getString("catatan");
                pesanan.setCatatan(catatan != null ? catatan : "");
                
                pesanan.setTanggalOrder(orderRs.getTimestamp("tanggal_order"));
                pesanan.setTanggalUpdate(orderRs.getTimestamp("tanggal_update"));

                // Get order items
                String itemsSql = "SELECT oi.*, p.nama as product_name FROM order_items oi " +
                                 "JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?";
                PreparedStatement itemsStmt = conn.prepareStatement(itemsSql);
                itemsStmt.setInt(1, orderId);
                ResultSet itemsRs = itemsStmt.executeQuery();

                while (itemsRs.next()) {
                    PesananItem item = new PesananItem();
                    item.setId(itemsRs.getInt("id"));
                    item.setOrderId(itemsRs.getInt("order_id"));
                    item.setProductId(itemsRs.getInt("product_id"));
                    item.setProductName(itemsRs.getString("product_name"));
                    item.setJumlah(itemsRs.getInt("jumlah"));
                    item.setHarga(itemsRs.getDouble("harga"));
                    item.setSubtotal(itemsRs.getDouble("subtotal"));
                    orderItems.add(item);
                }
            }
        }

        if (pesanan == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Pesanan tidak ditemukan");
            return;
        }

        pesanan.setItems(orderItems);
        request.setAttribute("pesanan", pesanan);
        request.getRequestDispatcher("pesanan_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                createOrder(request, response);
            } else if ("cancel".equals(action)) {
                int userId = ((model.Pengguna) session.getAttribute("pengguna")).getId();
                cancelOrder(request, response, userId);
            } else {
                // Default action - create order from original servlet
                createOrderSimple(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Terjadi kesalahan: " + e.getMessage());
            response.sendRedirect("PesananServlet");
        }
    }

    // Method untuk membuat order dengan cara sederhana (tanpa JSON parsing)
    private void createOrderSimple(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        HttpSession session = request.getSession();
        int userId = ((model.Pengguna) session.getAttribute("pengguna")).getId();
        
        String alamat = request.getParameter("alamat");
        String totalStr = request.getParameter("total");

        // Validate input
        if (alamat == null || alamat.trim().isEmpty()) {
            session.setAttribute("error", "Alamat pengiriman harus diisi");
            response.sendRedirect("dashboard_user.jsp");
            return;
        }

        if (totalStr == null || totalStr.trim().isEmpty()) {
            session.setAttribute("error", "Total pesanan tidak valid");
            response.sendRedirect("dashboard_user.jsp");
            return;
        }

        double total;
        try {
            total = Double.parseDouble(totalStr);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Total pesanan tidak valid");
            response.sendRedirect("dashboard_user.jsp");
            return;
        }

        try (Connection conn = JDBC.getConnection()) {
            String sql = "INSERT INTO pesanan (user_id, total, status, alamat, tanggal_order) VALUES (?, ?, 'menunggu', ?, NOW())";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setDouble(2, total);
            stmt.setString(3, alamat.trim());
            
            int result = stmt.executeUpdate();
            
            if (result > 0) {
                session.setAttribute("success", "Pesanan berhasil dibuat!");
            } else {
                session.setAttribute("error", "Gagal membuat pesanan");
            }
        }

        response.sendRedirect("PesananServlet");
    }

    // Method untuk membuat order dengan detail items (menggunakan parameter array)
    private void createOrder(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        HttpSession session = request.getSession();
        int userId = ((model.Pengguna) session.getAttribute("pengguna")).getId();
        
        String alamat = request.getParameter("alamat");
        String metodePembayaran = request.getParameter("metodePembayaran");
        String catatan = request.getParameter("catatan");
        
        // Get cart items from form parameters
        String[] productIds = request.getParameterValues("productId");
        String[] productNames = request.getParameterValues("productName");
        String[] quantities = request.getParameterValues("quantity");
        String[] prices = request.getParameterValues("price");

        // Validate input
        if (alamat == null || alamat.trim().isEmpty()) {
            session.setAttribute("error", "Alamat pengiriman harus diisi");
            response.sendRedirect("checkout.jsp");
            return;
        }

        if (metodePembayaran == null || metodePembayaran.trim().isEmpty()) {
            session.setAttribute("error", "Metode pembayaran harus dipilih");
            response.sendRedirect("checkout.jsp");
            return;
        }

        if (productIds == null || productIds.length == 0) {
            session.setAttribute("error", "Keranjang belanja kosong");
            response.sendRedirect("dashboard_user.jsp");
            return;
        }

        Connection conn = null;
        try {
            conn = JDBC.getConnection();
            conn.setAutoCommit(false);

            // Calculate total
            double total = 0;
            for (int i = 0; i < productIds.length; i++) {
                double price = Double.parseDouble(prices[i]);
                int quantity = Integer.parseInt(quantities[i]);
                total += price * quantity;
            }

            // Insert order
            String orderSql = "INSERT INTO pesanan (user_id, total, status, alamat, metode_pembayaran, catatan, tanggal_order) " +
                             "VALUES (?, ?, 'menunggu', ?, ?, ?, NOW())";
            PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, userId);
            orderStmt.setDouble(2, total);
            orderStmt.setString(3, alamat.trim());
            orderStmt.setString(4, metodePembayaran);
            orderStmt.setString(5, catatan != null ? catatan.trim() : "");
            orderStmt.executeUpdate();

            // Get generated order ID
            ResultSet generatedKeys = orderStmt.getGeneratedKeys();
            int orderId = 0;
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            }

            // Insert order items
            String itemSql = "INSERT INTO order_items (order_id, product_id, jumlah, harga, subtotal) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement itemStmt = conn.prepareStatement(itemSql);

            for (int i = 0; i < productIds.length; i++) {
                int productId = Integer.parseInt(productIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                double price = Double.parseDouble(prices[i]);
                double subtotal = price * quantity;

                itemStmt.setInt(1, orderId);
                itemStmt.setInt(2, productId);
                itemStmt.setInt(3, quantity);
                itemStmt.setDouble(4, price);
                itemStmt.setDouble(5, subtotal);
                itemStmt.addBatch();
            }
            itemStmt.executeBatch();

            conn.commit();
            session.setAttribute("success", "Pesanan berhasil dibuat dengan ID: " + orderId);
            response.sendRedirect("PesananServlet?action=detail&id=" + orderId);

        } catch (SQLException | NumberFormatException e) {
            if (conn != null) {
                conn.rollback();
            }
            e.printStackTrace();
            session.setAttribute("error", "Gagal membuat pesanan: " + e.getMessage());
            response.sendRedirect("checkout.jsp");
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws SQLException, ServletException, IOException {
        
        int orderId = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();

        try (Connection conn = JDBC.getConnection()) {
            // Check if order can be cancelled
            String checkSql = "SELECT status FROM pesanan WHERE id = ? AND user_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, orderId);
            checkStmt.setInt(2, userId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                String currentStatus = rs.getString("status");
                if (!"menunggu".equals(currentStatus) && !"dikonfirmasi".equals(currentStatus)) {
                    session.setAttribute("error", "Pesanan tidak dapat dibatalkan karena sudah diproses");
                } else {
                    // Cancel the order
                    String updateSql = "UPDATE pesanan SET status = 'dibatalkan', tanggal_update = NOW() WHERE id = ? AND user_id = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setInt(1, orderId);
                    updateStmt.setInt(2, userId);
                    
                    int updated = updateStmt.executeUpdate();
                    if (updated > 0) {
                        session.setAttribute("success", "Pesanan berhasil dibatalkan");
                    } else {
                        session.setAttribute("error", "Gagal membatalkan pesanan");
                    }
                }
            } else {
                session.setAttribute("error", "Pesanan tidak ditemukan");
            }
        }

        response.sendRedirect("PesananServlet");
    }
}