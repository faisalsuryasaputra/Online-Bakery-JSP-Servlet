package servlet;

import classes.JDBC;
import model.Pengguna;
import model.Review;
import model.Produk;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String komentar = request.getParameter("komentar");
            String ratingStr = request.getParameter("rating");
            String productIdStr = request.getParameter("productId");

            System.out.println("DEBUG - Received parameters:");
            System.out.println("komentar: " + komentar);
            System.out.println("rating: " + ratingStr);
            System.out.println("productId: " + productIdStr);
            System.out.println("userId: " + pengguna.getId());

            if (komentar == null || ratingStr == null || productIdStr == null ||
                    komentar.trim().isEmpty() || ratingStr.trim().isEmpty() || productIdStr.trim().isEmpty()) {
                session.setAttribute("error", "Semua field harus diisi.");
                response.sendRedirect("review.jsp?produkId=" + productIdStr);
                return;
            }

            try (Connection conn = JDBC.getConnection()) {
                int rating = Integer.parseInt(ratingStr);
                int productId = Integer.parseInt(productIdStr);

                // Gunakan nama tabel dan kolom yang konsisten
                String sql = "INSERT INTO reviews (user_id, produk_id, rating, komentar, tanggal_review) VALUES (?, ?, ?, ?, NOW())";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, pengguna.getId());
                stmt.setInt(2, productId);
                stmt.setInt(3, rating);
                stmt.setString(4, komentar);
                
                System.out.println("DEBUG - Executing SQL: " + sql);
                System.out.println("DEBUG - Parameters: userId=" + pengguna.getId() + ", produkId=" + productId + ", rating=" + rating + ", komentar=" + komentar);
                
                int rowsAffected = stmt.executeUpdate();
                System.out.println("DEBUG - Rows affected: " + rowsAffected);

                if (rowsAffected > 0) {
                    session.setAttribute("message", "Review berhasil dikirim!");
                    System.out.println("DEBUG - Review successfully saved!");
                } else {
                    session.setAttribute("error", "Gagal menyimpan review - no rows affected.");
                    System.out.println("DEBUG - No rows were affected!");
                }
                
                response.sendRedirect("UserDashboardServlet");
            } catch (SQLException e) {
                e.printStackTrace();
                System.out.println("DEBUG - SQL Error: " + e.getMessage());
                session.setAttribute("error", "Gagal menyimpan review: " + e.getMessage());
                response.sendRedirect("review.jsp?produkId=" + productIdStr);
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("DEBUG - General Error: " + e.getMessage());
                session.setAttribute("error", "Gagal menyimpan review.");
                response.sendRedirect("review.jsp?produkId=" + productIdStr);
            }
        } else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            try (Connection conn = JDBC.getConnection()) {
                int id = Integer.parseInt(idStr);
                String sql = "DELETE FROM reviews WHERE id = ? AND user_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, id);
                stmt.setInt(2, pengguna.getId());
                stmt.executeUpdate();

                session.setAttribute("message", "Review berhasil dihapus.");
                response.sendRedirect("UserDashboardServlet");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Gagal menghapus review.");
                response.sendRedirect("UserDashboardServlet");
            }
        } else {
            response.sendRedirect("UserDashboardServlet");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect ke UserDashboardServlet untuk menampilkan data
        response.sendRedirect("UserDashboardServlet");
    }
}