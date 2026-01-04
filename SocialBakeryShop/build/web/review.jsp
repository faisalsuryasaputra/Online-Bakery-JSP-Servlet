<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>
<%@ page import="model.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    HttpSession sess = request.getSession(false);
    Pengguna pengguna = (sess != null) ? (Pengguna) sess.getAttribute("pengguna") : null;
    if (pengguna == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String produkId = request.getParameter("produkId");
%>
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Review Produk - SocialBakery</title>
  <link rel="icon" type="image/png" href="img/favicon.png" />

  <!-- Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;300;400;700&display=swap" rel="stylesheet" />

  <!-- Feather Icons -->
  <script src="https://unpkg.com/feather-icons"></script>

  <!-- Tailwind CSS -->
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
  <style>
    .star-rating {
      display: flex;
      gap: 5px;
      justify-content: center;
      margin: 10px 0;
    }
    .star {
      font-size: 28px;
      color: #D1D5DB;
      cursor: pointer;
      transition: color 0.2s ease;
    }
    .star:hover,
    .star.active {
      color: #FFE8A3;
    }
    .star.filled {
      color: #D7A86E;
    }
    .review-card {
      transition: all 0.3s ease;
    }
    .review-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(92, 58, 33, 0.15);
    }
  </style>
</head>
<body class="font-poppins bg-cream min-h-screen">
  <!-- Navbar -->
  <nav class="flex justify-between items-center px-8 py-6 bg-milkWhite shadow-md">
    <a href="UserDashboardServlet" class="text-2xl font-bold text-darkBrown">
      Social<span class="text-lightBrown">Bakery</span>
    </a>
    <div class="hidden md:flex space-x-6">
      <a href="UserDashboardServlet#home" class="text-darkBrown hover:text-lightBrown text-lg">Home</a>
      <a href="UserDashboardServlet#menu" class="text-darkBrown hover:text-lightBrown text-lg">Menu</a>
      <a href="UserDashboardServlet#categories" class="text-darkBrown hover:text-lightBrown text-lg">Categories</a>
      <a href="UserDashboardServlet#reviews" class="text-darkBrown hover:text-lightBrown text-lg">Reviews</a>
    </div>
    <div class="flex items-center space-x-4">
      <a href="#" class="text-darkBrown hover:text-lightBrown"><i data-feather="shopping-cart" class="w-5 h-5"></i></a>
      <a href="LogoutServlet" class="text-darkBrown hover:text-lightBrown"><i data-feather="user" class="w-5 h-5"></i></a>
    </div>
  </nav>

  <div class="container mx-auto px-4 py-8">
    <div class="max-w-4xl mx-auto">
      <h2 class="text-3xl font-bold text-darkBrown text-center mb-6">Review Produk</h2>

      <form action="ReviewServlet" method="post" class="bg-milkWhite p-8 rounded-xl shadow-lg" id="reviewForm">
        <input type="hidden" name="action" value="add" />
        <input type="hidden" name="userId" value="<%= pengguna.getId() %>" />
        <input type="hidden" name="productId" value="<%= produkId != null ? produkId : "" %>" />

        <div class="mb-4">
          <label class="block text-darkBrown font-medium mb-2">Nama</label>
          <input type="text" name="nama" value="<%= pengguna.getUsername() %>" readonly
                 class="w-full border border-lightBrown rounded-lg p-3 focus:outline-none bg-gray-100" />
        </div>

        <div class="mb-4">
          <label class="block text-darkBrown font-medium mb-2">Rating</label>
          <div class="star-rating" id="starRating">
            <span class="star" data-rating="1">★</span>
            <span class="star" data-rating="2">★</span>
            <span class="star" data-rating="3">★</span>
            <span class="star" data-rating="4">★</span>
            <span class="star" data-rating="5">★</span>
          </div>
          <input type="hidden" name="rating" id="ratingValue" required />
          <p class="text-sm text-lightBrown text-center">Klik bintang untuk memberikan rating</p>
        </div>

        <div class="mb-6">
          <label class="block text-darkBrown font-medium mb-2">Komentar</label>
          <textarea name="komentar" rows="4" required
                    class="w-full border border-lightBrown rounded-lg p-3 focus:outline-none focus:border-darkBrown resize-none"
                    placeholder="Ceritakan pengalaman Anda dengan produk ini..."></textarea>
        </div>

        <button type="submit"
                class="w-full bg-lightBrown text-white p-3 rounded-lg hover:bg-darkBrown transition font-semibold">
          <i data-feather="send" class="w-5 h-5 inline-block mr-2"></i>
          Kirim Review
        </button>
      </form>
    </div>
  </div>

  <script>
    feather.replace();
    const stars = document.querySelectorAll('.star');
    const ratingInput = document.getElementById('ratingValue');
    stars.forEach((star, index) => {
      star.addEventListener('click', () => {
        const rating = index + 1;
        ratingInput.value = rating;
        updateStars(rating);
      });
      star.addEventListener('mouseover', () => {
        highlightStars(index + 1);
      });
    });
    document.getElementById('starRating').addEventListener('mouseleave', () => {
      const currentRating = parseInt(ratingInput.value) || 0;
      updateStars(currentRating);
    });
    function updateStars(rating) {
      stars.forEach((star, index) => {
        star.classList.remove('active', 'filled');
        if (index < rating) star.classList.add('filled');
      });
    }
    function highlightStars(rating) {
      stars.forEach((star, index) => {
        star.classList.remove('active', 'filled');
        if (index < rating) star.classList.add('active');
      });
    }
  </script>
</body>
</html>
