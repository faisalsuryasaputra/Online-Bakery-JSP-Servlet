<%@page import="model.Review"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Produk, model.Kategori" %>
<%
    List<Produk> produkList = (List<Produk>) request.getAttribute("produkList");
    if (produkList == null) produkList = new ArrayList<>();
    
    List<Kategori> kategoriList = (List<Kategori>) request.getAttribute("kategoriList");
    if (kategoriList == null) kategoriList = new ArrayList<>();
    
    List<Review> userReviews = (List<Review>) session.getAttribute("userReviews");
    if (userReviews == null) userReviews = new ArrayList<>();
    
    // Add this line to get reviews by product
    Map<Integer, List<Review>> reviewByProduk = (Map<Integer, List<Review>>) request.getAttribute("reviewByProduk");
    if (reviewByProduk == null) reviewByProduk = new HashMap<>();
    
    String debugInfo = (String) request.getAttribute("debugInfo");
    String currentUser = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SocialBakery - Dashboard</title>
    <link rel="icon" type="image/png" href="img/favicon.png" />
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;300;400;500;600;700&display=swap" rel="stylesheet" />
    
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
                    animation: {
                        'fade-in': 'fadeIn 0.5s ease-in-out',
                        'slide-up': 'slideUp 0.6s ease-out',
                        'bounce-subtle': 'bounceSubtle 2s infinite',
                    },
                    keyframes: {
                        fadeIn: {
                            '0%': { opacity: '0' },
                            '100%': { opacity: '1' }
                        },
                        slideUp: {
                            '0%': { transform: 'translateY(20px)', opacity: '0' },
                            '100%': { transform: 'translateY(0)', opacity: '1' }
                        },
                        bounceSubtle: {
                            '0%, 100%': { transform: 'translateY(0)' },
                            '50%': { transform: 'translateY(-5px)' }
                        }
                    }
                },
            },
        };
    </script>
    
    <!-- Custom CSS for additional styling -->
    <style>
        .glass-effect {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .gradient-text {
            background: linear-gradient(45deg, #D7A86E, #5C3A21);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .product-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .product-card:hover {
            transform: translateY(-8px) scale(1.02);
        }
        
        .loading-skeleton {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
        }
        
        @keyframes loading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }

        .review-section {
            max-height: 200px;
            overflow-y: auto;
        }
        
        .review-section::-webkit-scrollbar {
            width: 4px;
        }
        
        .review-section::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 2px;
        }
        
        .review-section::-webkit-scrollbar-thumb {
            background: #D7A86E;
            border-radius: 2px;
        }
        
        .review-section::-webkit-scrollbar-thumb:hover {
            background: #5C3A21;
        }
    </style>
</head>
<body class="font-poppins text-darkBrown min-h-screen bg-cream relative">
    <!-- Loading Overlay -->
    <div id="loading-overlay" class="fixed inset-0 bg-cream/80 backdrop-blur-sm z-50 flex items-center justify-center hidden">
        <div class="text-center">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-lightBrown mx-auto mb-4"></div>
            <p class="text-darkBrown font-medium">Memuat...</p>
        </div>
    </div>

    <!-- Success/Error Toast -->
    <div id="toast" class="fixed top-4 right-4 z-50 hidden">
        <div class="bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg flex items-center gap-2">
            <i data-feather="check-circle" class="w-5 h-5"></i>
            <span id="toast-message">Berhasil!</span>
            <button onclick="hideToast()" class="ml-2 hover:bg-green-600 rounded p-1">
                <i data-feather="x" class="w-4 h-4"></i>
            </button>
        </div>
    </div>

    <!-- Navbar Start -->
    <nav class="sticky top-0 z-40 glass-effect backdrop-blur-md bg-milkWhite/90 shadow-lg border-b border-butterYellow/20">
        <div class="flex justify-between items-center px-8 py-4">
            <a href="#" class="text-2xl font-bold gradient-text animate-fade-in">
                Social<span class="text-lightBrown">Bakery</span>
            </a>

            <div class="hidden md:flex space-x-8">
                <a href="#home" class="nav-link text-darkBrown hover:text-lightBrown text-lg font-medium relative transition-all duration-300">Home</a>
                <a href="#menu" class="nav-link text-darkBrown hover:text-lightBrown text-lg font-medium relative transition-all duration-300">Menu</a>
                <a href="#categories" class="nav-link text-darkBrown hover:text-lightBrown text-lg font-medium relative transition-all duration-300">Categories</a>
                <a href="#reviews" class="nav-link text-darkBrown hover:text-lightBrown text-lg font-medium relative transition-all duration-300">Reviews</a>
            </div>

            <div class="flex items-center space-x-4">
                <div class="relative">
                    <button id="cart-btn" class="text-darkBrown hover:text-lightBrown transition-colors duration-300 relative">
                        <i data-feather="shopping-cart" class="w-6 h-6"></i>
                        <span id="cart-count" class="absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center hidden">0</span>
                    </button>
                </div>
                
                <div class="relative">
                    <button id="user-menu-btn" class="text-darkBrown hover:text-lightBrown transition-colors duration-300 flex items-center gap-2">
                        <i data-feather="user" class="w-6 h-6"></i>
                        <% if (currentUser != null) { %>
                        <span class="hidden md:inline text-sm font-medium"><%= currentUser %></span>
                        <% } %>
                    </button>
                    
                    <!-- User Dropdown Menu -->
                    <div id="user-dropdown" class="absolute right-0 top-full mt-2 w-48 bg-milkWhite rounded-lg shadow-lg border border-butterYellow/20 hidden">
                        <% if (currentUser != null) { %>
                        <div class="px-4 py-3 border-b border-butterYellow/20">
                            <p class="text-sm font-medium text-darkBrown">Logged in as</p>
                            <p class="text-sm text-darkBrown/80"><%= currentUser %></p>
                        </div>
                        <% } %>
                        <div class="py-2">
                            <a href="#" class="block px-4 py-2 text-sm text-darkBrown hover:bg-cream transition-colors">Profile</a>
                            <a href="#" class="block px-4 py-2 text-sm text-darkBrown hover:bg-cream transition-colors">Order History</a>
                            <a href="LogoutServlet" class="block px-4 py-2 text-sm text-darkBrown hover:bg-cream transition-colors">Logout</a>
                        </div>
                    </div>
                </div>
                
                <button id="hamburger-menu" class="md:hidden text-darkBrown cursor-pointer transition-transform duration-300 hover:scale-110">
                    <i data-feather="menu" class="w-6 h-6"></i>
                </button>
            </div>
        </div>
        
        <!-- Mobile Menu -->
        <div id="mobile-menu" class="md:hidden fixed top-full left-0 w-full bg-milkWhite/95 backdrop-blur-md shadow-lg transform -translate-y-full opacity-0 transition-all duration-300 pointer-events-none">
            <div class="px-8 py-6 space-y-4">
                <a href="#home" class="block text-darkBrown hover:text-lightBrown text-lg font-medium py-2 transition-colors">Home</a>
                <a href="#menu" class="block text-darkBrown hover:text-lightBrown text-lg font-medium py-2 transition-colors">Menu</a>
                <a href="#categories" class="block text-darkBrown hover:text-lightBrown text-lg font-medium py-2 transition-colors">Categories</a>
                <a href="#reviews" class="block text-darkBrown hover:text-lightBrown text-lg font-medium py-2 transition-colors">Reviews</a>
            </div>
        </div>
    </nav>
    <!-- Navbar End -->

    <!-- Hero Section Start -->
    <section id="home" class="py-20 px-8 bg-gradient-to-br from-milkWhite via-cream to-butterYellow/20">
        <div class="max-w-6xl mx-auto text-center">
            <h1 class="text-4xl md:text-6xl font-bold mb-6 animate-slide-up">
                <span class="gradient-text">Selamat Datang di</span><br>
                <span class="text-darkBrown">SocialBakery</span>
            </h1>
            <p class="text-xl text-darkBrown/80 mb-8 max-w-2xl mx-auto animate-fade-in">
                Nikmati kelezatan roti artisan terbaik yang dibuat dengan cinta dan bahan berkualitas premium
            </p>
            <div class="flex flex-col sm:flex-row gap-4 justify-center animate-slide-up">
                <a href="#menu" class="px-8 py-3 bg-lightBrown text-milkWhite rounded-full shadow-lg hover:bg-darkBrown hover:shadow-xl transform hover:-translate-y-1 transition-all duration-300 font-semibold">
                    Lihat Menu
                </a>
                <a href="#categories" class="px-8 py-3 bg-transparent border-2 border-lightBrown text-lightBrown rounded-full hover:bg-lightBrown hover:text-milkWhite transform hover:-translate-y-1 transition-all duration-300 font-semibold">
                    Jelajahi Kategori
                </a>
            </div>
        </div>
    </section>
    <!-- Hero Section End -->

    <!-- Featured Menu Section Start -->
    <section id="menu" class="py-24 px-8 bg-milkWhite">
        <div class="max-w-7xl mx-auto">
            <div class="text-center mb-16">
                <h2 class="text-3xl md:text-5xl font-bold mb-4 animate-slide-up">
                    <span class="text-darkBrown">Featured </span>
                    <span class="gradient-text">Menu</span>
                </h2>
                <p class="text-center max-w-2xl mx-auto text-darkBrown/80 text-lg animate-fade-in">
                    Pilihan roti terbaik kami dibuat dengan cinta dan bahan berkualitas tinggi untuk memberikan pengalaman rasa yang tak terlupakan.
                </p>
            </div>

            <!-- Search and Filter Bar -->
            <div class="flex flex-col md:flex-row gap-4 mb-12 justify-center">
                <div class="relative">
                    <input type="text" id="search-input" placeholder="Cari produk..." 
                           class="pl-10 pr-4 py-3 w-full md:w-80 border border-butterYellow/30 rounded-full focus:outline-none focus:ring-2 focus:ring-lightBrown focus:border-transparent bg-cream/50">
                    <i data-feather="search" class="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-darkBrown/60"></i>
                </div>
                <select id="price-filter" class="px-4 py-3 border border-butterYellow/30 rounded-full focus:outline-none focus:ring-2 focus:ring-lightBrown bg-cream/50">
                    <option value="">Semua Harga</option>
                    <option value="0-50000">Di bawah Rp 50.000</option>
                    <option value="50000-100000">Rp 50.000 - Rp 100.000</option>
                    <option value="100000-999999">Di atas Rp 100.000</option>
                </select>
            </div>

            <div id="products-container">
                <% if (!produkList.isEmpty()) { %>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8" id="products-grid">
                    <% 
                    int displayCount = 0;
                    for (Produk p : produkList) { 
                        if (displayCount >= 6) break;
                        displayCount++;
                        List<Review> reviews = reviewByProduk.get(p.getId());
                    %>
                    <div class="product-card bg-cream rounded-2xl shadow-lg border border-butterYellow/20 p-6 text-center animate-fade-in"
                         data-name="<%= p.getNama().toLowerCase() %>" 
                         data-price="<%= p.getHarga() %>">
                        <div class="relative mb-6 group">
                            <div class="w-48 h-48 mx-auto rounded-2xl overflow-hidden border-4 border-butterYellow shadow-lg group-hover:border-lightBrown transition-colors duration-300">
                                <img src="<%= request.getContextPath() + "/" + (p.getGambar() != null && !p.getGambar().isEmpty() ? p.getGambar() : "img/default.jpg") %>"
                                     alt="<%= p.getNama() %>"
                                     class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default.jpg'" />
                            </div>
                            <div class="absolute top-2 right-2 bg-green-500 text-white px-2 py-1 rounded-full text-xs font-semibold">
                                Fresh
                            </div>
                        </div>
                        
                        <h3 class="text-xl font-bold mb-3 text-darkBrown group-hover:text-lightBrown transition-colors">
                            <%= p.getNama() %>
                        </h3>
                        
                        <p class="text-darkBrown/80 max-w-xs mx-auto mb-4 text-sm leading-relaxed">
                            <%= p.getDeskripsi() %>
                        </p>
                        
                        <div class="flex items-center justify-center mb-6">
                            <span class="text-2xl font-bold text-green-600">
                                Rp <%= String.format("%,.0f", p.getHarga()) %>
                            </span>
                        </div>
                        
                        <!-- Reviews Section -->
                        <% if (reviews != null && !reviews.isEmpty()) { %>
                        <div class="mb-6 bg-milkWhite rounded-lg p-4 border border-butterYellow/30">
                            <h4 class="font-semibold text-darkBrown mb-3 flex items-center justify-center gap-2">
                                <i data-feather="star" class="w-4 h-4 text-yellow-500"></i>
                                Ulasan Pelanggan
                            </h4>
                            <div class="review-section space-y-3">
                                <% 
                                int reviewCount = 0;
                                for (Review r : reviews) { 
                                    if (reviewCount >= 3) break; // Limit to 3 reviews
                                    reviewCount++;
                                %>
                                <div class="bg-cream/50 p-3 rounded-lg shadow-sm border border-butterYellow/20">
                                    <div class="flex justify-center gap-1 mb-2">
                                        <% for (int i = 0; i < 5; i++) { %>
                                            <% if (i < r.getRating()) { %>
                                            <span class="text-yellow-400 text-sm">★</span>
                                            <% } else { %>
                                            <span class="text-gray-300 text-sm">★</span>
                                            <% } %>
                                        <% } %>
                                    </div>
                                    <p class="text-darkBrown/80 text-xs italic text-center leading-relaxed">
                                        "<%= r.getKomentar() %>"
                                    </p>
                                </div>
                                <% } %>
                                <% if (reviews.size() > 3) { %>
                                <p class="text-xs text-darkBrown/60 text-center italic">
                                    +<%= reviews.size() - 3 %> ulasan lainnya
                                </p>
                                <% } %>
                            </div>
                        </div>
                        <% } else { %>
                        <div class="mb-6 bg-milkWhite rounded-lg p-4 border border-butterYellow/30">
                            <div class="flex items-center justify-center gap-2 text-darkBrown/60">
                                <i data-feather="message-circle" class="w-4 h-4"></i>
                                <p class="text-sm italic">Belum ada review</p>
                            </div>
                        </div>
                        <% } %>
                        
                        <div class="flex flex-col gap-3">
                            <button onclick="addToCart(<%= p.getId() %>, '<%= p.getNama() %>', <%= p.getHarga() %>)" 
                                    class="w-full px-6 py-3 bg-lightBrown text-milkWhite rounded-full shadow-md hover:bg-darkBrown hover:shadow-lg transform hover:-translate-y-1 transition-all duration-300 font-semibold">
                                <i data-feather="shopping-cart" class="w-4 h-4 inline mr-2"></i>
                                Tambah ke Keranjang
                            </button>
                            <a href="review.jsp?produkId=<%= p.getId() %>" 
                               class="w-full px-6 py-3 bg-pastelPink text-darkBrown rounded-full shadow hover:bg-pink-300 hover:shadow-lg transform hover:-translate-y-1 transition-all duration-300 text-center font-semibold">
                                <i data-feather="star" class="w-4 h-4 inline mr-2"></i>
                                Lihat Semua Review
                            </a>
                        </div>
                    </div>
                    <% } %>
                </div>
                
                <!-- Load More Button -->
                <% if (produkList.size() > 6) { %>
                <div class="text-center mt-12">
                    <button id="load-more-btn" class="px-8 py-3 bg-transparent border-2 border-lightBrown text-lightBrown rounded-full hover:bg-lightBrown hover:text-milkWhite transform hover:-translate-y-1 transition-all duration-300 font-semibold">
                        Lihat Lebih Banyak
                    </button>
                </div>
                <% } %>
                
                <% } else { %>
                <div class="text-center py-16">
                    <div class="w-24 h-24 mx-auto mb-6 bg-butterYellow/20 rounded-full flex items-center justify-center">
                        <i data-feather="package" class="w-12 h-12 text-darkBrown/60"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-darkBrown mb-4">Belum Ada Produk</h3>
                    <p class="text-darkBrown/60 mb-6">Produk akan segera hadir. Silakan cek kembali nanti!</p>
                    <button onclick="window.location.reload()" 
                            class="px-6 py-3 bg-lightBrown text-milkWhite rounded-full shadow-md hover:bg-darkBrown transition-all duration-300 font-semibold">
                        <i data-feather="refresh-cw" class="w-4 h-4 inline mr-2"></i>
                        Refresh Halaman
                    </button>
                </div>
                <% } %>
            </div>
        </div>
    </section>
    <!-- Featured Menu Section End -->

    <!-- Categories Section Start -->
    <section id="categories" class="py-24 px-8 bg-gradient-to-br from-cream to-butterYellow/10">
        <div class="max-w-7xl mx-auto">
            <div class="text-center mb-16">
                <h2 class="text-3xl md:text-5xl font-bold mb-4 animate-slide-up">
                    <span class="text-darkBrown">Shop By </span>
                    <span class="gradient-text">Categories</span>
                </h2>
                <p class="text-center max-w-2xl mx-auto text-darkBrown/80 text-lg animate-fade-in">
                    Temukan berbagai kategori roti yang telah kami siapkan khusus untuk memenuhi selera dan kebutuhan Anda.
                </p>
            </div>

            <% if (!kategoriList.isEmpty()) { %>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <% for (Kategori k : kategoriList) { 
                    String categoryImageName = k.getNama().toLowerCase().replace(" ", "_");
                %>
                <a href="MenuServlet?kategori=<%= k.getId() %>" class="block group">
                    <div class="product-card bg-milkWhite rounded-2xl shadow-lg hover:shadow-2xl border border-butterYellow/20 p-8 text-center transition-all duration-300 h-full">
                        <div class="relative mb-6">
                            <div class="w-40 h-40 mx-auto rounded-full overflow-hidden border-4 border-butterYellow group-hover:border-lightBrown shadow-lg transition-all duration-300">
                                <img src="${pageContext.request.contextPath}/img/<%= categoryImageName %>.jpg" 
                                     alt="<%= k.getNama() %>" 
                                     class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default.jpg'" />
                            </div>
                            <div class="absolute -bottom-2 -right-2 bg-lightBrown text-milkWhite w-8 h-8 rounded-full flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
                                <i data-feather="arrow-right" class="w-4 h-4"></i>
                            </div>
                        </div>
                        
                        <h3 class="text-xl font-bold mb-4 text-darkBrown group-hover:text-lightBrown transition-colors duration-300">
                            <%= k.getNama() %>
                        </h3>
                        
                        <p class="text-darkBrown/80 max-w-xs mx-auto leading-relaxed">
                            <%= k.getDeskripsi() != null && !k.getDeskripsi().isEmpty() ? 
                                k.getDeskripsi() : "Berbagai pilihan " + k.getNama().toLowerCase() + " segar dan lezat yang siap memanjakan lidah Anda." %>
                        </p>
                    </div>
                </a>
                <% } %>
            </div>
            <% } else { %>
            <div class="text-center py-16">
                <div class="w-24 h-24 mx-auto mb-6 bg-butterYellow/20 rounded-full flex items-center justify-center">
                    <i data-feather="grid" class="w-12 h-12 text-darkBrown/60"></i>
                </div>
                <h3 class="text-xl font-semibold text-darkBrown mb-4">Belum Ada Kategori</h3>
                <p class="text-darkBrown/60 mb-6">Kategori akan segera ditambahkan. Silakan cek kembali nanti!</p>
                <button onclick="window.location.reload()" 
                        class="px-6 py-3 bg-lightBrown text-milkWhite rounded-full shadow-md hover:bg-darkBrown transition-all duration-300 font-semibold">
                    <i data-feather="refresh-cw" class="w-4 h-4 inline mr-2"></i>
                    Refresh Halaman
                </button>
            </div>
            <% } %>
        </div>
    </section>
    <!-- Categories Section End -->

    <section id="reviews" class="py-24 bg-milkWhite text-center">
      <div class="max-w-2xl mx-auto">
        <h2 class="text-3xl md:text-5xl font-bold mb-6 text-darkBrown">Ulasan Pelanggan</h2>
        <p class="text-darkBrown/80 mb-8">Klik tombol di bawah untuk melihat semua review yang diberikan oleh pelanggan.</p>
        <a href="review.jsp" class="inline-block px-6 py-3 bg-lightBrown text-milkWhite rounded-full shadow-md hover:bg-darkBrown transition-all duration-300 font-semibold">
          Lihat Review
        </a>
      </div>
    </section>

    <!-- Footer Start -->
    <footer class="bg-gradient-to-br from-darkBrown to-darkBrown/90 text-milkWhite pt-16 pb-8">
        <div class="max-w-7xl mx-auto px-8">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-8 mb-12">
                <!-- Brand Section -->
                <div class="text-center md:text-left">
                    <a href="#" class="text-3xl font-bold mb-4 block">
                        Social<span class="text-butterYellow">Bakery</span>
                    </a>
                    <p class="text-milkWhite/80 mb-6 leading-relaxed">
                        Menghadirkan kelezatan roti artisan terbaik dengan cita rasa yang tak terlupakan untuk keluarga Indonesia.
                    </p>
                    <div class="flex justify-center md:justify-start space-x-4">
                        <a href="https://instagram.com/fliirf_" class="w-10 h-10 bg-milkWhite/10 hover:bg-butterYellow/20 rounded-full flex items-center justify-center transition-all duration-300 hover:scale-110">
                            <i data-feather="instagram" class="w-5 h-5"></i>
                        </a>
                        <a href="#" class="w-10 h-10 bg-milkWhite/10 hover:bg-butterYellow/20 rounded-full flex items-center justify-center transition-all duration-300 hover:scale-110">
                            <i data-feather="twitter" class="w-5 h-5"></i>
                        </a>
                        <a href="https://linkedin.com/in/muhamadrafli843" class="w-10 h-10 bg-milkWhite/10 hover:bg-butterYellow/20 rounded-full flex items-center justify-center transition-all duration-300 hover:scale-110">
                            <i data-feather="linkedin" class="w-5 h-5"></i>
                        </a>
                    </div>
                </div>

                <!-- Quick Links -->
                <div>
                    <h4 class="text-lg font-semibold mb-6 text-butterYellow">Quick Links</h4>
                    <ul class="space-y-3">
                        <li><a href="#home" class="text-milkWhite/80 hover:text-butterYellow transition-colors duration-300">Home</a></li>
                        <li><a href="#menu" class="text-milkWhite/80 hover:text-butterYellow transition-colors duration-300">Menu</a></li>
                        <li><a href="#categories" class="text-milkWhite/80 hover:text-butterYellow transition-colors duration-300">Categories</a></li>
                        <li><a href="#reviews" class="text-milkWhite/80 hover:text-butterYellow transition-colors duration-300">Reviews</a></li>
                    </ul>
                </div>

                <!-- Categories -->
                <div>
                    <h4 class="text-lg font-semibold mb-6 text-butterYellow">Categories</h4>
                    <ul class="space-y-3">
                        <% for (Kategori k : kategoriList) { %>
                        <li><a href="MenuServlet?kategori=<%= k.getId() %>" class="text-milkWhite/80 hover:text-butterYellow transition-colors duration-300"><%= k.getNama() %></a></li>
                        <% } %>
                    </ul>
                </div>

                <!-- Contact Info -->
                <div>
                    <h4 class="text-lg font-semibold mb-6 text-butterYellow">Contact Info</h4>
                    <div class="space-y-3">
                        <div class="flex items-center gap-3">
                            <i data-feather="map-pin" class="w-5 h-5 text-butterYellow"></i>
                            <span class="text-milkWhite/80">Bandung, West Java, ID</span>
                        </div>
                        <div class="flex items-center gap-3">
                            <i data-feather="phone" class="w-5 h-5 text-butterYellow"></i>
                            <span class="text-milkWhite/80">+62 xxx xxxx xxxx</span>
                        </div>
                        <div class="flex items-center gap-3">
                            <i data-feather="mail" class="w-5 h-5 text-butterYellow"></i>
                            <span class="text-milkWhite/80">info@socialbakery.com</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer Bottom -->
            <div class="border-t border-milkWhite/20 pt-8 text-center">
                <p class="text-milkWhite/80">
                    Created with <i data-feather="heart" class="w-4 h-4 inline text-red-400 fill-current"></i> by 
                    <a href="#" class="text-butterYellow font-semibold hover:underline">Muhamad Rafli</a> | 
                    &copy; 2025 SocialBakery. All rights reserved.
                </p>
            </div>
        </div>
    </footer>
    <!-- Footer End -->

    <!-- Shopping Cart Sidebar -->
    <div id="cart-sidebar" class="fixed right-0 top-0 h-full w-96 bg-milkWhite shadow-2xl transform translate-x-full transition-transform duration-300 z-50 border-l border-butterYellow/20">
        <div class="flex flex-col h-full">
            <!-- Cart Header -->
            <div class="flex items-center justify-between p-6 border-b border-butterYellow/20">
                <h3 class="text-xl font-bold text-darkBrown">Keranjang Belanja</h3>
                <button id="close-cart" class="text-darkBrown hover:text-lightBrown transition-colors">
                    <i data-feather="x" class="w-6 h-6"></i>
                </button>
            </div>

            <!-- Cart Items -->
            <div id="cart-items" class="flex-1 overflow-y-auto p-6">
                <div id="empty-cart" class="text-center py-12">
                    <div class="w-16 h-16 mx-auto mb-4 bg-butterYellow/20 rounded-full flex items-center justify-center">
                        <i data-feather="shopping-cart" class="w-8 h-8 text-darkBrown/60"></i>
                    </div>
                    <p class="text-darkBrown/60">Keranjang belanja kosong</p>
                </div>
            </div>

            <!-- Cart Footer -->
            <div class="border-t border-butterYellow/20 p-6">
                <div class="flex justify-between items-center mb-4">
                    <span class="text-lg font-semibold text-darkBrown">Total:</span>
                    <span id="cart-total" class="text-xl font-bold text-green-600">Rp 0</span>
                </div>
                <button id="checkout-btn" class="w-full px-6 py-3 bg-lightBrown text-milkWhite rounded-full shadow-md hover:bg-darkBrown transition-all duration-300 font-semibold disabled:opacity-50 disabled:cursor-not-allowed" disabled>
                    Checkout
                </button>
            </div>
        </div>
    </div>

    <!-- Cart Overlay -->
    <div id="cart-overlay" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-40 opacity-0 pointer-events-none transition-opacity duration-300"></div>

    <!-- Debug Info (hidden by default) -->
    <% if (debugInfo != null && !debugInfo.isEmpty()) { %>
    <div class="fixed bottom-4 left-4 z-50">
        <details class="bg-yellow-100 border border-yellow-300 rounded-lg p-4 text-sm max-w-sm shadow-lg">
            <summary class="cursor-pointer font-semibold text-yellow-800 flex items-center gap-2">
                <i data-feather="info" class="w-4 h-4"></i>
                Debug Info
            </summary>
            <div class="mt-3 text-yellow-700 text-xs font-mono whitespace-pre-wrap">
                <%= debugInfo %>
            </div>
        </details>
    </div>
    <% } %>

    <!-- JavaScript -->
    <script>
        // Initialize Feather Icons
        feather.replace();

        // Global Variables
        let cart = JSON.parse(localStorage.getItem('cart')) || [];
        let currentReviewSlide = 0;
        let reviewSlideInterval;

        // DOM Elements
        const hamburger = document.getElementById("hamburger-menu");
        const mobileMenu = document.getElementById("mobile-menu");
        const cartBtn = document.getElementById("cart-btn");
        const cartSidebar = document.getElementById("cart-sidebar");
        const cartOverlay = document.getElementById("cart-overlay");
        const closeCart = document.getElementById("close-cart");
        const userMenuBtn = document.getElementById("user-menu-btn");
        const userDropdown = document.getElementById("user-dropdown");
        const loadingOverlay = document.getElementById("loading-overlay");

        // Utility Functions
        function showLoading() {
            loadingOverlay.classList.remove('hidden');
        }

        function hideLoading() {
            loadingOverlay.classList.add('hidden');
        }

        function showToast(message, type = 'success') {
            const toast = document.getElementById('toast');
            const toastMessage = document.getElementById('toast-message');
            const toastDiv = toast.querySelector('div');
            
            toastMessage.textContent = message;
            
            if (type === 'success') {
                toastDiv.className = 'bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg flex items-center gap-2';
                toastDiv.innerHTML = `<i data-feather="check-circle" class="w-5 h-5"></i><span>${message}</span><button onclick="hideToast()" class="ml-2 hover:bg-green-600 rounded p-1"><i data-feather="x" class="w-4 h-4"></i></button>`;
            } else if (type === 'error') {
                toastDiv.className = 'bg-red-500 text-white px-6 py-3 rounded-lg shadow-lg flex items-center gap-2';
                toastDiv.innerHTML = `<i data-feather="alert-circle" class="w-5 h-5"></i><span>${message}</span><button onclick="hideToast()" class="ml-2 hover:bg-red-600 rounded p-1"><i data-feather="x" class="w-4 h-4"></i></button>`;
            }
            
            toast.classList.remove('hidden');
            feather.replace();
            
            setTimeout(hideToast, 5000);
        }

        function hideToast() {
            document.getElementById('toast').classList.add('hidden');
        }

        // Mobile Menu Functionality
        if (hamburger && mobileMenu) {
            hamburger.addEventListener("click", () => {
                const isOpen = !mobileMenu.classList.contains('-translate-y-full');
                
                if (isOpen) {
                    mobileMenu.classList.add('-translate-y-full', 'opacity-0', 'pointer-events-none');
                } else {
                    mobileMenu.classList.remove('-translate-y-full', 'opacity-0', 'pointer-events-none');
                }
            });
        }

        // User Dropdown Functionality
        if (userMenuBtn && userDropdown) {
            userMenuBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                userDropdown.classList.toggle('hidden');
            });

            document.addEventListener('click', () => {
                userDropdown.classList.add('hidden');
            });

            userDropdown.addEventListener('click', (e) => {
                e.stopPropagation();
            });
        }

        // Shopping Cart Functionality
        function updateCartUI() {
            const cartCount = document.getElementById('cart-count');
            const cartItems = document.getElementById('cart-items');
            const cartTotal = document.getElementById('cart-total');
            const checkoutBtn = document.getElementById('checkout-btn');
            const emptyCart = document.getElementById('empty-cart');

            // Update cart count
            if (cart.length > 0) {
                cartCount.textContent = cart.reduce((sum, item) => sum + item.quantity, 0);
                cartCount.classList.remove('hidden');
            } else {
                cartCount.classList.add('hidden');
            }

            // Update cart items
            if (cart.length === 0) {
                emptyCart.classList.remove('hidden');
                cartTotal.textContent = 'Rp 0';
                checkoutBtn.disabled = true;
            } else {
                emptyCart.classList.add('hidden');
                
                cartItems.innerHTML = cart.map(item => `
                    <div class="flex items-center gap-4 p-4 bg-cream rounded-lg mb-4">
                        <div class="flex-1">
                            <h4 class="font-semibold text-darkBrown">${item.name}</h4>
                            <p class="text-sm text-darkBrown/60">Rp ${item.price.toLocaleString()}</p>
                        </div>
                        <div class="flex items-center gap-2">
                            <button onclick="updateCartItemQuantity(${item.id}, ${item.quantity - 1})" class="w-8 h-8 bg-lightBrown text-white rounded-full flex items-center justify-center hover:bg-darkBrown transition-colors">
                                <i data-feather="minus" class="w-4 h-4"></i>
                            </button>
                            <span class="w-8 text-center font-semibold">${item.quantity}</span>
                            <button onclick="updateCartItemQuantity(${item.id}, ${item.quantity + 1})" class="w-8 h-8 bg-lightBrown text-white rounded-full flex items-center justify-center hover:bg-darkBrown transition-colors">
                                <i data-feather="plus" class="w-4 h-4"></i>
                            </button>
                        </div>
                        <button onclick="removeFromCart(${item.id})" class="text-red-500 hover:text-red-700 transition-colors">
                            <i data-feather="trash-2" class="w-4 h-4"></i>
                        </button>
                    </div>
                `).join('') + emptyCart.outerHTML;

                const total = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
                cartTotal.textContent = `Rp ${total.toLocaleString()}`;
                checkoutBtn.disabled = false;
                
                feather.replace();
            }

            // Save to localStorage
            localStorage.setItem('cart', JSON.stringify(cart));
        }

        function addToCart(id, name, price) {
            const existingItem = cart.find(item => item.id === id);
            
            if (existingItem) {
                existingItem.quantity += 1;
            } else {
                cart.push({ id, name, price, quantity: 1 });
            }
            
            updateCartUI();
            showToast(`${name} ditambahkan ke keranjang!`);
        }

        function updateCartItemQuantity(id, newQuantity) {
            if (newQuantity <= 0) {
                removeFromCart(id);
                return;
            }
            
            const item = cart.find(item => item.id === id);
            if (item) {
                item.quantity = newQuantity;
                updateCartUI();
            }
        }

        function removeFromCart(id) {
            cart = cart.filter(item => item.id !== id);
            updateCartUI();
            showToast('Item dihapus dari keranjang', 'error');
        }

        // Cart Sidebar Toggle
        if (cartBtn && cartSidebar && cartOverlay && closeCart) {
            cartBtn.addEventListener('click', () => {
                cartSidebar.classList.remove('translate-x-full');
                cartOverlay.classList.remove('opacity-0', 'pointer-events-none');
                document.body.style.overflow = 'hidden';
            });

            closeCart.addEventListener('click', () => {
                cartSidebar.classList.add('translate-x-full');
                cartOverlay.classList.add('opacity-0', 'pointer-events-none');
                document.body.style.overflow = 'auto';
            });

            cartOverlay.addEventListener('click', () => {
                cartSidebar.classList.add('translate-x-full');
                cartOverlay.classList.add('opacity-0', 'pointer-events-none');
                document.body.style.overflow = 'auto';
            });
        }

        // Search and Filter Functionality
        const searchInput = document.getElementById('search-input');
        const priceFilter = document.getElementById('price-filter');
        const productsGrid = document.getElementById('products-grid');

        function filterProducts() {
            const searchTerm = searchInput.value.toLowerCase();
            const priceRange = priceFilter.value;
            const productCards = productsGrid.querySelectorAll('.product-card');

            productCards.forEach(card => {
                const name = card.dataset.name;
                const price = parseInt(card.dataset.price);
                
                let showCard = true;

                // Search filter
                if (searchTerm && !name.includes(searchTerm)) {
                    showCard = false;
                }

                // Price filter
                if (priceRange) {
                    const [min, max] = priceRange.split('-').map(Number);
                    if (price < min || price > max) {
                        showCard = false;
                    }
                }

                card.style.display = showCard ? 'block' : 'none';
            });
        }

        if (searchInput) {
            searchInput.addEventListener('input', filterProducts);
        }

        if (priceFilter) {
            priceFilter.addEventListener('change', filterProducts);
        }

        // Review Slider Functionality
        function initReviewSlider() {
            const reviewSliderContent = document.getElementById("review-slider-content");
            const reviewPrevBtn = document.getElementById("review-prev-btn");
            const reviewNextBtn = document.getElementById("review-next-btn");
            const reviewDots = document.querySelectorAll(".review-dot");

            if (!reviewSliderContent) return;

            const reviewSlidesCount = reviewSliderContent.children.length;

            function updateReviewSlider() {
                reviewSliderContent.style.transform = `translateX(-${currentReviewSlide * 100}%)`;

                reviewDots.forEach((dot, index) => {
                    if (index === currentReviewSlide) {
                        dot.classList.remove("opacity-50", "scale-100");
                        dot.classList.add("opacity-100", "scale-125");
                    } else {
                        dot.classList.remove("opacity-100", "scale-125");
                        dot.classList.add("opacity-50", "scale-100");
                    }
                });
            }

            function nextSlide() {
                currentReviewSlide = (currentReviewSlide + 1) % reviewSlidesCount;
                updateReviewSlider();
            }

            function prevSlide() {
                currentReviewSlide = (currentReviewSlide - 1 + reviewSlidesCount) % reviewSlidesCount;
                updateReviewSlider();
            }

            // Event listeners
            if (reviewNextBtn) {
                reviewNextBtn.addEventListener("click", nextSlide);
            }

            if (reviewPrevBtn) {
                reviewPrevBtn.addEventListener("click", prevSlide);
            }

            reviewDots.forEach((dot, index) => {
                dot.addEventListener("click", () => {
                    currentReviewSlide = index;
                    updateReviewSlider();
                });
            });

            // Auto-slide
            function startAutoSlide() {
                reviewSlideInterval = setInterval(nextSlide, 5000);
            }

            function stopAutoSlide() {
                if (reviewSlideInterval) {
                    clearInterval(reviewSlideInterval);
                }
            }

            const reviewContainer = document.getElementById("review-slider-container");
            if (reviewContainer) {
                reviewContainer.addEventListener("mouseenter", stopAutoSlide);
                reviewContainer.addEventListener("mouseleave", startAutoSlide);
                startAutoSlide();
            }
        }

        // Smooth Scrolling
        document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
            anchor.addEventListener("click", function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute("href"));
                if (target) {
                    target.scrollIntoView({
                        behavior: "smooth",
                        block: "start"
                    });
                }
            });
        });

        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            const navbar = document.querySelector('nav');
            if (window.scrollY > 100) {
                navbar.classList.add('shadow-xl');
                navbar.classList.remove('shadow-lg');
            } else {
                navbar.classList.add('shadow-lg');
                navbar.classList.remove('shadow-xl');
            }
        });

        // Load More Products
        const loadMoreBtn = document.getElementById('load-more-btn');
        if (loadMoreBtn) {
            loadMoreBtn.addEventListener('click', () => {
                showLoading();
                // Simulate loading more products
                setTimeout(() => {
                    hideLoading();
                    showToast('Semua produk telah ditampilkan');
                    loadMoreBtn.style.display = 'none';
                }, 1000);
            });
        }

        // Initialize everything when DOM is loaded
        document.addEventListener("DOMContentLoaded", function () {
            updateCartUI();
            initReviewSlider();
            
            // Animate elements on scroll
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -100px 0px'
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);

            // Observe all product cards and category items
            document.querySelectorAll('.product-card, .animate-fade-in, .animate-slide-up').forEach(el => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(20px)';
                el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                observer.observe(el);
            });
        });

        // Auto-refresh functionality (improved)
        let refreshCounter = 0;
        setInterval(function() {
            if (document.visibilityState === 'visible' && !document.querySelector(':hover')) {
                refreshCounter++;
                
                // Only check every 5 intervals (2.5 minutes) to reduce server load
                if (refreshCounter % 5 === 0) {
                    fetch(window.location.href, { 
                        method: 'HEAD',
                        cache: 'no-cache'
                    })
                    .then(response => {
                        if (response.ok) {
                            const lastModified = response.headers.get('last-modified');
                            const currentModified = localStorage.getItem('lastPageModified');
                            
                            if (lastModified && lastModified !== currentModified) {
                                localStorage.setItem('lastPageModified', lastModified);
                                
                                // Show update notification
                                const notification = document.createElement('div');
                                notification.className = 'fixed top-20 right-4 bg-blue-500 text-white p-4 rounded-lg shadow-lg z-50 transform translate-x-full opacity-0 transition-all duration-300';
                                notification.innerHTML = `
                                    <div class="flex items-center gap-2">
                                        <i data-feather="refresh-cw" class="w-5 h-5"></i>
                                        <span>Update tersedia!</span>
                                        <button onclick="window.location.reload()" class="ml-2 bg-blue-600 px-3 py-1 rounded text-sm hover:bg-blue-700 transition-colors">
                                            Refresh
                                        </button>
                                        <button onclick="this.parentElement.parentElement.remove()" class="ml-1 hover:bg-blue-600 rounded p-1">
                                            <i data-feather="x" class="w-4 h-4"></i>
                                        </button>
                                    </div>
                                `;
                                document.body.appendChild(notification);
                                feather.replace();
                                
                                // Animate in
                                setTimeout(() => {
                                    notification.classList.remove('translate-x-full', 'opacity-0');
                                }, 100);
                                
                                // Auto remove after 10 seconds
                                setTimeout(() => {
                                    if (notification.parentElement) {
                                        notification.classList.add('translate-x-full', 'opacity-0');
                                        setTimeout(() => notification.remove(), 300);
                                    }
                                }, 10000);
                            }
                        }
                    })
                    .catch(error => {
                        console.log('Auto-refresh check failed:', error);
                    });
                }
            }
        }, 30000); // Check every 30 seconds
    </script>
</body>
</html>