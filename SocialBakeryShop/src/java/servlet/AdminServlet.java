package servlet;

import classes.JDBC;
import model.Kategori;
import model.Produk;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.sql.*;
import java.util.*;

@WebServlet("/AdminServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 5 * 1024 * 1024,   // 5MB
    maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class AdminServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        String action = request.getParameter("action");

        try (Connection conn = JDBC.getConnection()) {
            if ("kategori".equals(type)) {
                if ("add".equals(action)) {
                    String nama = request.getParameter("nama");
                    String deskripsi = request.getParameter("deskripsi");
                    PreparedStatement ps = conn.prepareStatement("INSERT INTO categories (nama, deskripsi) VALUES (?, ?)");
                    ps.setString(1, nama);
                    ps.setString(2, deskripsi);
                    ps.executeUpdate();
                    ps.close();
                } else if ("delete".equals(action)) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    PreparedStatement ps = conn.prepareStatement("DELETE FROM categories WHERE id = ?");
                    ps.setInt(1, id);
                    ps.executeUpdate();
                    ps.close();
                }
            } else if ("produk".equals(type)) {
                if ("add".equals(action)) {
                    String nama = request.getParameter("nama");
                    String deskripsi = request.getParameter("deskripsi");
                    double harga = Double.parseDouble(request.getParameter("harga"));
                    int kategoriId = Integer.parseInt(request.getParameter("kategori_id"));
                    Timestamp createdAt = new Timestamp(System.currentTimeMillis());
                    int stok = 0;

                    // Upload gambar ke folder Web Pages/uploads (bukan build/)
                    Part filePart = request.getPart("gambar");
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String gambar = "";

                    if (fileName != null && !fileName.isEmpty()) {
                        String relativePath = "uploads";
                        String absolutePath = getServletContext().getRealPath("") + File.separator + ".." + File.separator + "web" + File.separator + relativePath;
                        Files.createDirectories(Paths.get(absolutePath));

                        String fullPath = absolutePath + File.separator + fileName;
                        filePart.write(fullPath);

                        gambar = relativePath + "/" + fileName; // simpan di DB
                    }

                    PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO products (nama, deskripsi, harga, stok, kategori_id, gambar, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)"
                    );
                    ps.setString(1, nama);
                    ps.setString(2, deskripsi);
                    ps.setDouble(3, harga);
                    ps.setInt(4, stok);
                    ps.setInt(5, kategoriId);
                    ps.setString(6, gambar);
                    ps.setTimestamp(7, createdAt);
                    ps.executeUpdate();
                    ps.close();
                } else if ("delete".equals(action)) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    PreparedStatement ps = conn.prepareStatement("DELETE FROM products WHERE id = ?");
                    ps.setInt(1, id);
                    ps.executeUpdate();
                    ps.close();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        doGet(request, response); // Refresh data setelah post
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Kategori> kategoriList = new ArrayList<>();
        List<Produk> produkList = new ArrayList<>();

        try (Connection conn = JDBC.getConnection()) {
            Statement stmt = conn.createStatement();

            ResultSet rs = stmt.executeQuery("SELECT * FROM categories");
            while (rs.next()) {
                kategoriList.add(new Kategori(
                        rs.getInt("id"),
                        rs.getString("nama"),
                        rs.getString("deskripsi")
                ));
            }
            rs.close();

            String sqlProduk = "SELECT p.*, c.nama as kategori_nama FROM products p JOIN categories c ON p.kategori_id = c.id";
            rs = stmt.executeQuery(sqlProduk);
            while (rs.next()) {
                Kategori kategori = new Kategori(
                        rs.getInt("kategori_id"),
                        rs.getString("kategori_nama"),
                        ""
                );
                produkList.add(new Produk(
                        rs.getInt("id"),
                        rs.getString("nama"),
                        rs.getString("deskripsi"),
                        rs.getDouble("harga"),
                        kategori,
                        rs.getString("gambar")
                ));
            }
            rs.close();
            stmt.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("kategoriList", kategoriList);
        request.setAttribute("produkList", produkList);
        request.getRequestDispatcher("dashboard_admin.jsp").forward(request, response);
    }
}
