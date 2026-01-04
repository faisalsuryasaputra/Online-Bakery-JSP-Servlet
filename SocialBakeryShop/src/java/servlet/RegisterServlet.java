package servlet;

import classes.JDBC;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = JDBC.getConnection()) {
            // Cek apakah email sudah terdaftar
            String checkSql = "SELECT id FROM users WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Sudah ada user dengan email itu
                response.sendRedirect("register.jsp?error=exists");
                return;
            }

            // Insert user baru
            String sql = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, 'customer')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.executeUpdate();

            stmt.close();
            response.sendRedirect("login.jsp?success=registered");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=server");
        }
    }
}
