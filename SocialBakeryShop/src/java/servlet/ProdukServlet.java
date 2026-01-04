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

@WebServlet("/ProdukServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 5 * 1024 * 1024,   // 5MB
    maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class ProdukServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "edit":
                getProdukEditForm(request, response);
                break;
            case "delete":
                deleteProduk(request, response);
                break;
            default:
                listProduk(request, response);
                break;
        }
    }

    private void listProduk(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Produk> daftarProduk = new ArrayList<>();

        try (Connection conn = JDBC.getConnection()) {
            String sql = "SELECT p.*, k.nama AS kategori_nama FROM produk p JOIN kategori k ON p.kategori_id = k.id";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Produk p = new Produk();
                p.setId(rs.getInt("id"));
                p.setNama(rs.getString("nama"));
                p.setDeskripsi(rs.getString("deskripsi"));
                p.setHarga(rs.getDouble("harga"));
                p.setGambar(rs.getString("gambar"));

                Kategori k = new Kategori();
                k.setId(rs.getInt("kategori_id"));
                k.setNama(rs.getString("kategori_nama"));
                p.setKategori(k);

                daftarProduk.add(p);
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("daftarProduk", daftarProduk);
        request.getRequestDispatcher("dashboard_admin.jsp").forward(request, response);
    }

    private void getProdukEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = JDBC.getConnection()) {
            String sql = "SELECT * FROM produk WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Produk p = new Produk();
                p.setId(rs.getInt("id"));
                p.setNama(rs.getString("nama"));
                p.setDeskripsi(rs.getString("deskripsi"));
                p.setHarga(rs.getDouble("harga"));
                p.setGambar(rs.getString("gambar"));

                int kategoriId = rs.getInt("kategori_id");
                Kategori k = new Kategori();
                k.setId(kategoriId);
                p.setKategori(k);

                request.setAttribute("produkEdit", p);
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        listProduk(request, response);
    }

    private void deleteProduk(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = JDBC.getConnection()) {
            String sql = "DELETE FROM produk WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.executeUpdate();

            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("ProdukServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = request.getParameter("id") != null ? Integer.parseInt(request.getParameter("id")) : 0;
        String nama = request.getParameter("nama");
        String deskripsi = request.getParameter("deskripsi");
        double harga = Double.parseDouble(request.getParameter("harga"));
        int kategoriId = Integer.parseInt(request.getParameter("kategori_id"));

        // Proses upload file gambar
        Part filePart = request.getPart("gambar");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String gambarPath = "";

        if (fileName != null && !fileName.isEmpty()) {
            String uploadDir = request.getServletContext().getRealPath("/uploads");
            Files.createDirectories(Paths.get(uploadDir));

            String fullPath = uploadDir + File.separator + fileName;
            filePart.write(fullPath);

            gambarPath = "uploads/" + fileName;
        }

        try (Connection conn = JDBC.getConnection()) {
            String sql;
            if (id == 0) {
                sql = "INSERT INTO produk (nama, deskripsi, harga, kategori_id, gambar) VALUES (?, ?, ?, ?, ?)";
            } else {
                if (gambarPath.isEmpty()) {
                    sql = "UPDATE produk SET nama = ?, deskripsi = ?, harga = ?, kategori_id = ? WHERE id = ?";
                } else {
                    sql = "UPDATE produk SET nama = ?, deskripsi = ?, harga = ?, kategori_id = ?, gambar = ? WHERE id = ?";
                }
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, nama);
            stmt.setString(2, deskripsi);
            stmt.setDouble(3, harga);
            stmt.setInt(4, kategoriId);

            if (id == 0) {
                stmt.setString(5, gambarPath);
            } else {
                if (gambarPath.isEmpty()) {
                    stmt.setInt(5, id);
                } else {
                    stmt.setString(5, gambarPath);
                    stmt.setInt(6, id);
                }
            }

            stmt.executeUpdate();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("ProdukServlet");
    }
}
