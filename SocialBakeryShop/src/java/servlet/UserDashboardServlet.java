package servlet;

import classes.JDBC;
import model.Kategori;
import model.Produk;
import model.Review;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/UserDashboardServlet")
public class UserDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Produk> produkList = new ArrayList<>();
        List<Kategori> kategoriList = new ArrayList<>();
        Map<Integer, List<Review>> reviewByProduk = new HashMap<>();
        StringBuilder debugInfo = new StringBuilder();

        try (Connection conn = JDBC.getConnection()) {
            Statement stmt = conn.createStatement();

            // Ambil semua produk
            String sqlProduk = "SELECT p.*, c.nama as kategori_nama FROM products p JOIN categories c ON p.kategori_id = c.id";
            ResultSet rsProduk = stmt.executeQuery(sqlProduk);
            while (rsProduk.next()) {
                Kategori kategori = new Kategori(
                        rsProduk.getInt("kategori_id"),
                        rsProduk.getString("kategori_nama"),
                        ""
                );
                Produk produk = new Produk(
                        rsProduk.getInt("id"),
                        rsProduk.getString("nama"),
                        rsProduk.getString("deskripsi"),
                        rsProduk.getDouble("harga"),
                        kategori,
                        rsProduk.getString("gambar")
                );
                produkList.add(produk);
            }
            rsProduk.close();

            // Ambil kategori yang digunakan dalam produk
            String sqlKategori = "SELECT DISTINCT c.id, c.nama, c.deskripsi, c.gambar " +
                                 "FROM categories c JOIN products p ON c.id = p.kategori_id";
            ResultSet rsKategori = stmt.executeQuery(sqlKategori);
            while (rsKategori.next()) {
                Kategori k = new Kategori(
                        rsKategori.getInt("id"),
                        rsKategori.getString("nama"),
                        rsKategori.getString("deskripsi"),
                        rsKategori.getString("gambar")
                );
                kategoriList.add(k);
            }
            rsKategori.close();

            // Ambil semua review dan kelompokkan berdasarkan produk
            String sqlReview = "SELECT * FROM reviews ORDER BY id DESC";
            ResultSet rsReview = stmt.executeQuery(sqlReview);
            
            debugInfo.append("Query Review: ").append(sqlReview).append("\n");
            
            int reviewCount = 0;
            while (rsReview.next()) {
                reviewCount++;
                int produkId = rsReview.getInt("produk_id");
                
                // Gunakan constructor kosong dan setter
                Review review = new Review();
                review.setId(rsReview.getInt("id"));
                review.setUserId(rsReview.getInt("user_id"));
                review.setProductId(produkId);
                review.setRating(rsReview.getInt("rating"));
                review.setKomentar(rsReview.getString("komentar"));
                review.setTanggalReview(rsReview.getTimestamp("tanggal_review"));
                
                // Kelompokkan review berdasarkan produk ID
                reviewByProduk.computeIfAbsent(produkId, k -> new ArrayList<>()).add(review);
                
                debugInfo.append("Review #").append(reviewCount)
                         .append(" - Produk ID: ").append(produkId)
                         .append(", Rating: ").append(rsReview.getInt("rating"))
                         .append(", Komentar: ").append(rsReview.getString("komentar"))
                         .append("\n");
            }
            rsReview.close();
            
            debugInfo.append("Total reviews found: ").append(reviewCount).append("\n");
            debugInfo.append("Products with reviews: ").append(reviewByProduk.keySet()).append("\n");
            
            stmt.close();

        } catch (SQLException e) {
            e.printStackTrace();
            debugInfo.append("SQL Error: ").append(e.getMessage()).append("\n");
        }

        request.setAttribute("produkList", produkList);
        request.setAttribute("kategoriList", kategoriList);
        request.setAttribute("reviewByProduk", reviewByProduk);
        request.setAttribute("debugInfo", debugInfo.toString());

        request.getRequestDispatcher("dashboard_user.jsp").forward(request, response);
    }
}