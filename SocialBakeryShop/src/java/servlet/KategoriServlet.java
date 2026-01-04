package servlet;

import classes.JDBC;
import model.Kategori;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/KategoriServlet")
public class KategoriServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Kategori> daftarKategori = new ArrayList<>();

        try (Connection conn = JDBC.getConnection()) {
            String sql = "SELECT * FROM kategori";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Kategori k = new Kategori();
                k.setId(rs.getInt("id"));
                k.setNama(rs.getString("nama"));
                k.setDeskripsi(rs.getString("deskripsi"));
                daftarKategori.add(k);
            }

            rs.close();
            stmt.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("daftarKategori", daftarKategori);
        request.getRequestDispatcher("kategori_admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nama = request.getParameter("nama");
        String deskripsi = request.getParameter("deskripsi");

        try (Connection conn = JDBC.getConnection()) {
            String sql = "INSERT INTO kategori (nama, deskripsi) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, nama);
            stmt.setString(2, deskripsi);
            stmt.executeUpdate();

            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("KategoriServlet");
    }
}
