<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Produk" %>
<%
    List<Produk> produkList = (List<Produk>) request.getAttribute("produkList");
    if (produkList == null) produkList = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Dashboard User - SocialBakery</title>
  <link rel="icon" type="image/png" href="img/favicon.png" />
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            cream: "#FFF6E5",
            pastelPink: "#FADADD",
            lightBrown: "#D7A86E",
            darkBrown: "#5C3A21",
            butterYellow: "#FFE8A3",
            milkWhite: "#FDFBF7",
          },
          fontFamily: {
            poppins: ["Poppins", "sans-serif"],
          },
        },
      },
    };
  </script>
</head>
<body class="font-poppins bg-cream text-darkBrown min-h-screen">
  <header class="bg-lightBrown text-white py-6 shadow-md">
    <div class="max-w-6xl mx-auto px-4 flex justify-between items-center">
      <h1 class="text-2xl font-bold">Selamat Datang di SocialBakery 🍞</h1>
      <a href="LogoutServlet" class="bg-white text-lightBrown px-4 py-2 rounded hover:bg-milkWhite font-semibold">Logout</a>
    </div>
  </header>

  <main class="max-w-6xl mx-auto px-4 py-10">
    <h2 class="text-3xl font-semibold text-center mb-10">Produk Tersedia</h2>

    <% if (!produkList.isEmpty()) { %>
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8">
      <% for (Produk p : produkList) { %>
      <div class="bg-milkWhite rounded-lg shadow-md overflow-hidden group hover:shadow-xl transition duration-300">
        <div class="w-full h-48 overflow-hidden">
          <img src="<%= p.getGambar() != null && !p.getGambar().isEmpty() ? p.getGambar() : "img/default.jpg" %>" alt="gambar" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" />
        </div>
        <div class="p-4">
          <h3 class="text-xl font-bold mb-2 text-darkBrown"><%= p.getNama() %></h3>
          <p class="text-sm text-darkBrown/70 mb-3"><%= p.getDeskripsi() %></p>
          <div class="flex justify-between items-center gap-2">
            <span class="text-lg font-semibold text-green-700">Rp <%= String.format("%,.0f", p.getHarga()) %></span>
            <button class="bg-lightBrown text-white px-3 py-1 rounded-full text-sm hover:bg-darkBrown transition">+ Keranjang</button>
            <form action="review.jsp" method="get">
              <input type="hidden" name="produk_id" value="<%= p.getId() %>" />
              <button type="submit" class="bg-pastelPink text-darkBrown px-3 py-1 rounded-full text-sm hover:bg-lightBrown hover:text-white transition">Review</button>
            </form>
          </div>
        </div>
      </div>
      <% } %>
    </div>
    <% } else { %>
      <p class="text-center text-gray-500">Belum ada produk ditambahkan.</p>
    <% } %>
  </main>
</body>
</html>
