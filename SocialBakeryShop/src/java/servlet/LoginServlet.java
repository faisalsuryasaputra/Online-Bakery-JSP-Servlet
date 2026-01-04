package servlet;

import model.Pengguna;
import classes.JDBC;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = JDBC.getConnection()) {
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Pengguna pengguna = new Pengguna();
                pengguna.setId(rs.getInt("id"));
                pengguna.setUsername(rs.getString("username"));
                pengguna.setEmail(rs.getString("email"));
                pengguna.setPassword(rs.getString("password"));
                pengguna.setRole(rs.getString("role"));

                HttpSession session = request.getSession();
                session.setAttribute("pengguna", pengguna);

                if ("admin".equalsIgnoreCase(pengguna.getRole())) {
                    response.sendRedirect("AdminServlet");
                } else {
                    response.sendRedirect("UserDashboardServlet");
                }
            } else {
                response.sendRedirect("login.jsp?error=1");
            }

            rs.close();
            stmt.close();

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Login gagal karena error server.");
        }
    }
}
