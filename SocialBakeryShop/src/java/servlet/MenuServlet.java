package servlet;

import classes.JDBC;
import model.Kategori;
import model.Produk;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/MenuServlet")
public class MenuServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int kategoriId = Integer.parseInt(request.getParameter("kategori"));
        List<Produk> produkList = new ArrayList<>();
        Kategori kategori = null;

        try (Connection conn = JDBC.getConnection()) {
            // Ambil data kategori
            PreparedStatement psKategori = conn.prepareStatement("SELECT * FROM categories WHERE id = ?");
            psKategori.setInt(1, kategoriId);
            ResultSet rsKategori = psKategori.executeQuery();
            if (rsKategori.next()) {
                kategori = new Kategori(
                        rsKategori.getInt("id"),
                        rsKategori.getString("nama"),
                        rsKategori.getString("deskripsi"),
                        rsKategori.getString("gambar")
                );
            }

            // Ambil semua produk dari kategori tersebut
            PreparedStatement psProduk = conn.prepareStatement(
                    "SELECT * FROM products WHERE kategori_id = ?"
            );
            psProduk.setInt(1, kategoriId);
            ResultSet rsProduk = psProduk.executeQuery();
            while (rsProduk.next()) {
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

            rsKategori.close();
            rsProduk.close();
            psKategori.close();
            psProduk.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("produkList", produkList);
        request.setAttribute("kategori", kategori);
        request.getRequestDispatcher("menu.jsp").forward(request, response);
    }
}
