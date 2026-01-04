<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Produk, model.Kategori" %>
<%
    List<Produk> produkList = (List<Produk>) request.getAttribute("produkList");
    Kategori kategori = (Kategori) request.getAttribute("kategori");
%>
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8" />
  <title>Menu Kategori - <%= kategori.getNama() %></title>
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
<body class="bg-cream font-poppins text-darkBrown min-h-screen">

<!-- Navbar Start -->
<nav class="flex justify-between items-center px-8 py-6 bg-milkWhite shadow-md">
  <a href="dashboard_user.jsp" class="text-2xl font-bold text-darkBrown">
    Social<span class="text-lightBrown">Bakery</span>
  </a>

  <div class="hidden md:flex space-x-6">
  <a href="UserDashboardServlet#home" class="text-darkBrown hover:text-lightBrown text-lg relative after:content-[''] after:block after:pb-1 after:border-b after:border-butterYellow after:scale-x-0 hover:after:scale-x-50 after:transition-transform after:duration-200">Home</a>
  <a href="UserDashboardServlet#menu" class="text-darkBrown hover:text-lightBrown text-lg relative after:content-[''] after:block after:pb-1 after:border-b after:border-butterYellow after:scale-x-0 hover:after:scale-x-50 after:transition-transform after:duration-200">Menu</a>
  <a href="UserDashboardServlet#categories" class="text-darkBrown hover:text-lightBrown text-lg relative after:content-[''] after:block after:pb-1 after:border-b after:border-butterYellow after:scale-x-0 hover:after:scale-x-50 after:transition-transform after:duration-200">Categories</a>
  <a href="UserDashboardServlet#reviews" class="text-darkBrown hover:text-lightBrown text-lg relative after:content-[''] after:block after:pb-1 after:border-b after:border-butterYellow after:scale-x-0 hover:after:scale-x-50 after:transition-transform after:duration-200">Reviews</a>
</div>


  <div class="flex items-center space-x-4">
    <a href="#" class="text-darkBrown hover:text-lightBrown">
      <i data-feather="shopping-cart" class="w-5 h-5"></i>
    </a>
    <a href="LogoutServlet" class="text-darkBrown hover:text-lightBrown">
      <i data-feather="user" class="w-5 h-5"></i>
    </a>
    <button id="hamburger-menu" class="md:hidden text-darkBrown cursor-pointer">
      <i data-feather="menu" class="w-6 h-6"></i>
    </button>
  </div>
</nav>
<!-- Navbar End -->

<script src="https://unpkg.com/feather-icons"></script>
<script>feather.replace();</script>


  <!-- Judul Kategori -->
  <div class="text-center py-10">
    <h1 class="text-4xl font-bold mb-2">Kategori: <%= kategori.getNama() %></h1>
    <p class="text-darkBrown/70 text-lg"><%= kategori.getDeskripsi() %></p>
  </div>

  <!-- Produk -->
  <section class="max-w-7xl mx-auto px-4 pb-20">
    <% if (produkList != null && !produkList.isEmpty()) { %>
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-10">
      <% for (Produk p : produkList) {
          String imagePath = (p.getGambar() != null && !p.getGambar().isEmpty())
              ? request.getContextPath() + "/" + p.getGambar()
              : request.getContextPath() + "/img/default.jpg";
      %>
      <div class="bg-milkWhite rounded-lg shadow-md overflow-hidden group hover:shadow-xl transition duration-300">
        <div class="w-full h-48 overflow-hidden">
          <img src="<%= imagePath %>"
               alt="gambar"
               class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
               onerror="this.src='<%= request.getContextPath() %>/img/default.jpg'" />
        </div>
        <div class="p-4">
          <h3 class="text-xl font-bold mb-2 text-darkBrown"><%= p.getNama() %></h3>
          <p class="text-sm text-darkBrown/70 mb-3"><%= p.getDeskripsi() %></p>
          <div class="flex justify-between items-center">
            <span class="text-lg font-semibold text-green-700">
              Rp <%= String.format("%,.0f", p.getHarga()) %>
            </span>
            <button class="bg-lightBrown text-white px-3 py-1 rounded-full text-sm hover:bg-darkBrown transition">
              + Keranjang
            </button>
          </div>
        </div>
      </div>
      <% } %>
    </div>
    <% } else { %>
    <p class="text-center text-darkBrown/60 mt-12">Belum ada produk di kategori ini.</p>
    <% } %>
    
  </section>
</body>
</html>
