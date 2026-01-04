<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.*, model.Pengguna" %>
<%
    session = request.getSession(false);
    Pengguna pengguna = (session != null) ? (Pengguna) session.getAttribute("pengguna") : null;
    if (pengguna != null) {
        response.sendRedirect("dashboard_user.jsp");
        return;
    }
%>
<!-- Search Bar Overlay -->
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SocialBakery</title>
    <link rel="icon" type="image/png" href="img/favicon.png" />

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;300;400;700&display=swap"
      rel="stylesheet"
    />

    <!-- Feather Icons -->
    <script src="https://unpkg.com/feather-icons"></script>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              cream: "#FFF6E5", // Main background
              pastelPink: "#FADADD", // Button accent
              lightBrown: "#D7A86E", // Navigation, secondary buttons
              darkBrown: "#5C3A21", // Main text, logo
              butterYellow: "#FFE8A3", // Product highlight
              milkWhite: "#FDFBF7", // Footer, form areas
            },
            fontFamily: {
              poppins: ["Poppins", "sans-serif"],
            },
          },
        },
      };
    </script>
  </head>
  <body class="font-poppins text-darkBrown min-h-screen bg-cream relative">
    <!-- Navbar Start -->
    <nav
      class="flex justify-between items-center px-8 py-6 bg-milkWhite shadow-md fixed top-0 left-0 right-0 z-50"
    >
      <a href="#" class="text-2xl font-bold text-darkBrown">
        Social<span class="text-lightBrown">Bakery</span>
      </a>

      <div class="hidden md:flex space-x-4">
        <a
          href="#home"
          class="text-darkBrown hover:text-lightBrown text-lg relative after:content-[''] after:block after:pb-1 after:border-b after:border-butterYellow after:scale-x-0 hover:after:scale-x-50 after:transition-transform after:duration-200"
          >Home</a
        >
        <a
          href="#produk"
          class="text-darkBrown hover:text-lightBrown text-lg relative after:content-[''] after:block after:pb-1 after:border-b after:border-butterYellow after:scale-x-0 hover:after:scale-x-50 after:transition-transform after:duration-200"
          >Menu</a
        >
        <a
          href="#kategori"
          class="text-darkBrown hover:text-lightBrown text-lg relative after:content-[''] after:block after:pb-1 after:border-b after:border-butterYellow after:scale-x-0 hover:after:scale-x-50 after:transition-transform after:duration-200"
          >Categories</a
        >
        <a
          href="#reviews"
          class="text-darkBrown hover:text-lightBrown text-lg relative after:content-[''] after:block after:pb-1 after:border-b after:border-butterYellow after:scale-x-0 hover:after:scale-x-50 after:transition-transform after:duration-200"
          >Reviews</a
        >
      
      </div>

      <div class="flex items-center space-x-2">
        <a href="login.jsp" class="text-darkBrown hover:text-lightBrown">
          <i data-feather="shopping-cart" class="w-5 h-5"></i>
        </a>
        <a href="login.jsp" class="text-darkBrown hover:text-lightBrown">
          <i data-feather="user" class="w-5 h-5"></i>
        </a>
        <button
          id="hamburger-menu"
          class="md:hidden text-darkBrown cursor-pointer"
        >
          <i data-feather="menu" class="w-6 h-6"></i>
        </button>
      </div>
    </nav>
    <!-- Navbar End -->

    <!-- Mobile Nav Menu -->
    <div
      id="mobile-menu"
      class="fixed top-[4.5rem] right-[-100%] bg-lightBrown w-64 h-screen transition-all duration-300 z-40 md:hidden"
    >
      <div class="flex flex-col p-4">
        <a
          href="#home"
          class="text-milkWhite text-xl py-3 px-2 hover:text-butterYellow"
          >Home</a
        >
        <a
          href="#produk"
          class="text-milkWhite text-xl py-3 px-2 hover:text-butterYellow"
          >Produk</a
        >
        <a
          href="#kategori"
          class="text-milkWhite text-xl py-3 px-2 hover:text-butterYellow"
          >Kategori</a
        >
        <a
          href="#reviews"
          class="text-milkWhite text-xl py-3 px-2 hover:text-butterYellow"
          >Review</a
        >
        <a
          href="#contact"
          class="text-milkWhite text-xl py-3 px-2 hover:text-butterYellow"
          >Kontak</a
        >
      </div>
    </div>

    <!-- Hero Section Start -->
    <section
      id="home"
      class="min-h-screen flex items-center bg-gradient-to-r from-butterYellow to-cream relative overflow-hidden pt-20"
    >
      <div class="relative px-8 z-10">
        <h1 class="text-4xl md:text-5xl text-darkBrown/80 mb-4">
          Selamat Datang di <span class="text-darkBrown">Social</span
          ><span class="text-lightBrown">Bakery</span>!
        </h1>
        <p
          class="text-lg md:text-xl text-darkBrown/80 leading-relaxed mb-8 max-w-lg"
        >
          Temukan roti terbaik dengan bahan berkualitas tinggi dan rasa yang tak
          terlupakan.
        </p>
        <a
          href="login.jsp"
          class="inline-block px-8 py-3 bg-lightBrown text-milkWhite rounded-full text-lg shadow-md hover:transform hover:-translate-y-1 hover:shadow-lg transition-all duration-300"
          >Lihat Produk Kami</a
        >
      </div>
    </section>
    <!-- Hero Section End-->

    <!-- Produk Section Start -->
    <section id="produk" class="py-24 px-8 bg-milkWhite">
      <h2 class="text-3xl md:text-4xl text-center mb-4">
        <span class="text-darkBrown">Featured </span>
        <span class="text-lightBrown">Menu</span>
      </h2>
      <p class="text-center max-w-lg mx-auto text-darkBrown/80 mb-16">
        Pilihan roti terbaik kami dibuat dengan cinta dan bahan berkualitas tinggi.
      </p>

      <div class="flex flex-wrap justify-center gap-8 max-w-6xl mx-auto">
        <div class="w-full sm:w-64 md:w-80 text-center pb-16">
          <div
            class="w-40 h-40 mx-auto rounded-full overflow-hidden border-4 border-butterYellow"
          >
            <img src="img/croissant.jpg" alt="Croissant" class="w-full h-full object-cover" />
          </div>
          <h3 class="text-xl font-semibold my-4 text-darkBrown">Croissant</h3>
          <p class="text-darkBrown/80 max-w-xs mx-auto">
            Roti lapis dengan tekstur renyah dan rasa mentega yang lezat.
          </p>
          <button
            class="mt-4 px-6 py-2 bg-lightBrown text-milkWhite rounded-full shadow-md hover:bg-darkBrown transition-all duration-300"
          >
            Add to Cart
          </button>
        </div>

        <div class="w-full sm:w-64 md:w-80 text-center pb-16">
          <div
            class="w-40 h-40 mx-auto rounded-full overflow-hidden border-4 border-butterYellow"
          >
            <img src="img/sourdough.jpg" alt="Sourdough" class="w-full h-full object-cover" />
          </div>
          <h3 class="text-xl font-semibold my-4 text-darkBrown">Sourdough</h3>
          <p class="text-darkBrown/80 max-w-xs mx-auto">
            Roti sehat dengan rasa asam yang khas, cocok untuk sarapan.
          </p>
          <button
            class="mt-4 px-6 py-2 bg-lightBrown text-milkWhite rounded-full shadow-md hover:bg-darkBrown transition-all duration-300"
          >
            Add to Cart
          </button>
        </div>
      </div>
    </section>
    <!-- Produk Section End -->

    <!-- Kategori Start -->
    <section id="kategori" class="py-24 px-8 bg-cream">
      <h2 class="text-3xl md:text-4xl text-center mb-4">
      <span class="text-darkBrown">Shop By </span>
      <span class="text-lightBrown">Categories</span>
      </h2>
      <p class="text-center max-w-lg mx-auto text-darkBrown/80 mb-16">
      Pilihan kategori roti untuk memudahkan Anda menemukan produk yang tepat.
      </p>

      <div class="flex flex-wrap justify-center gap-8 max-w-6xl mx-auto">
      <div class="w-full sm:w-64 md:w-80 text-center pb-8 group bg-milkWhite rounded-2xl shadow-lg hover:shadow-2xl hover:-translate-y-2 transition-all duration-300 border border-butterYellow/20 p-6">
        <div class="w-40 h-40 mx-auto rounded-full overflow-hidden border-4 border-butterYellow transition-all duration-300 group-hover:scale-110 group-hover:border-lightBrown shadow-md">
        <img src="img/bread.jpg" alt="Bread" class="w-full h-full object-cover transform transition-transform duration-300 group-hover:scale-110" />
        </div>
        <h3 class="text-xl font-semibold my-4 text-darkBrown group-hover:text-lightBrown transition-colors duration-300">- Bread -</h3>
        <p class="text-darkBrown/80 max-w-xs mx-auto group-hover:text-darkBrown/90 transition-colors duration-300">
        Berbagai pilihan roti segar dengan berbagai rasa dan tekstur.
        </p>
      </div>

      <div class="w-full sm:w-64 md:w-80 text-center pb-8 group bg-milkWhite rounded-2xl shadow-lg hover:shadow-2xl hover:-translate-y-2 transition-all duration-300 border border-butterYellow/20 p-6">
        <div class="w-40 h-40 mx-auto rounded-full overflow-hidden border-4 border-butterYellow transition-all duration-300 group-hover:scale-110 group-hover:border-lightBrown shadow-md">
        <img src="img/pastry.jpg" alt="Pastry" class="w-full h-full object-cover transform transition-transform duration-300 group-hover:scale-110" />
        </div>
        <h3 class="text-xl font-semibold my-4 text-darkBrown group-hover:text-lightBrown transition-colors duration-300">- Pastry -</h3>
        <p class="text-darkBrown/80 max-w-xs mx-auto group-hover:text-darkBrown/90 transition-colors duration-300">
        Kue-kue manis yang lezat dan menggoyang lidah Anda.
        </p>
      </div>

      <div class="w-full sm:w-64 md:w-80 text-center pb-8 group bg-milkWhite rounded-2xl shadow-lg hover:shadow-2xl hover:-translate-y-2 transition-all duration-300 border border-butterYellow/20 p-6">
        <div class="w-40 h-40 mx-auto rounded-full overflow-hidden border-4 border-butterYellow transition-all duration-300 group-hover:scale-110 group-hover:border-lightBrown shadow-md">
        <img src="img/cake.jpg" alt="Cake" class="w-full h-full object-cover transform transition-transform duration-300 group-hover:scale-110" />
        </div>
        <h3 class="text-xl font-semibold my-4 text-darkBrown group-hover:text-lightBrown transition-colors duration-300">- Cake -</h3>
        <p class="text-darkBrown/80 max-w-xs mx-auto group-hover:text-darkBrown/90 transition-colors duration-300">
        Kue spesial untuk berbagai acara dan perayaan istimewa.
        </p>
      </div>
      </div>
    </section>
    <!-- Kategori End -->

    <!-- Review Section Start -->
    <section id="reviews" class="py-24 bg-milkWhite">
      <div class="max-w-7xl mx-auto px-4">
        <h2 class="text-3xl md:text-4xl text-center mb-4">
          <span class="text-darkBrown">What They  </span>
          <span class="text-lightBrown">Said</span>
        </h2>
        <p class="text-center text-darkBrown/80 max-w-2xl mx-auto mb-16">
          Hear what our customers have to say about our freshly baked goods and
          exceptional service.
        </p>

        <!-- Review Slider -->
        <div
          class="relative w-full overflow-hidden"
          id="review-slider-container"
        >
          <!-- Slides -->
          <div
            class="flex transition-transform duration-500 ease-in-out"
            id="review-slider-content"
          >
            <!-- Slide 1 -->
            <div class="min-w-full flex justify-center">
              <div
                class="flex flex-col items-center gap-4 max-w-2xl z-10 rounded-2xl bg-cream p-6 shadow-md text-center"
              > 
                <h3 class="text-xl font-semibold text-darkBrown">Emily R.</h3>
                <p class="text-darkBrown/80">
                  "The croissants are absolutely amazing! They are buttery,
                  flaky, and taste just like the ones I had in Paris. Highly
                  recommend!"
                </p>
              </div>
            </div>

            <!-- Slide 2 -->
            <div class="min-w-full flex justify-center">
              <div
                class="flex flex-col items-center gap-4 max-w-2xl z-10 rounded-2xl bg-cream p-6 shadow-md text-center"
              >
                <h3 class="text-xl font-semibold text-darkBrown">James L.</h3>
                <p class="text-darkBrown/80">
                  "I ordered a custom cake for my daughter's birthday, and it
                  was perfect! The design was beautiful, and the taste was even
                  better."
                </p>
              </div>
            </div>

            <!-- Slide 3 -->
            <div class="min-w-full flex justify-center">
              <div
                class="flex flex-col items-center gap-4 max-w-2xl z-10 rounded-2xl bg-cream p-6 shadow-md text-center"
              >
                <h3 class="text-xl font-semibold text-darkBrown">Sophia M.</h3>
                <p class="text-darkBrown/80">
                  "The sourdough bread is the best I've ever had. It's fresh,
                  flavorful, and perfect for breakfast or sandwiches."
                </p>
              </div>
            </div>
          </div>

          <!-- Navigation Buttons -->
          <div
            class="absolute top-1/2 -translate-y-1/2 w-full flex justify-between px-4"
          >
            <button
              id="review-prev-btn"
              class="bg-lightBrown text-white hover:bg-darkBrown w-10 h-10 rounded-full shadow-md transition-all duration-300 flex items-center justify-center opacity-75 hover:opacity-100"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-6 w-6"
                viewBox="0 0 20 20"
                fill="currentColor"
              >
                <path
                  fill-rule="evenodd"
                  d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z"
                  clip-rule="evenodd"
                />
              </svg>
            </button>

            <button
              id="review-next-btn"
              class="bg-lightBrown text-white hover:bg-darkBrown w-10 h-10 rounded-full shadow-md transition-all duration-300 flex items-center justify-center opacity-75 hover:opacity-100"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-6 w-6"
                viewBox="0 0 20 20"
                fill="currentColor"
              >
                <path
                  fill-rule="evenodd"
                  d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
                  clip-rule="evenodd"
                />
              </svg>
            </button>
          </div>

          <!-- Pagination Dots -->
          <div class="w-full flex justify-center gap-2 mt-6">
            <button
              class="w-3 h-3 rounded-full bg-darkBrown opacity-100 transition-opacity duration-300"
              data-index="0"
            ></button>
            <button
              class="w-3 h-3 rounded-full bg-darkBrown opacity-50 transition-opacity duration-300"
              data-index="1"
            ></button>
            <button
              class="w-3 h-3 rounded-full bg-darkBrown opacity-50 transition-opacity duration-300"
              data-index="2"
            ></button>
          </div>
        </div>
      </div>
    </section>
    <!-- Review Section End -->

    <!-- Footer Start -->
    <footer class="bg-darkBrown text-center text-milkWhite pt-4 pb-12">
      <div class="py-4">
        <a
          href="https://instagram.com/fliirf_"
          class="inline-block text-milkWhite mx-4 hover:text-butterYellow"
        >
          <i data-feather="instagram" class="w-6 h-6"></i>
        </a>
        <a
          href="#"
          class="inline-block text-milkWhite mx-4 hover:text-butterYellow"
        >
          <i data-feather="twitter" class="w-6 h-6"></i>
        </a>
        <a
          href="https://linkedin.com/in/muhamadrafli843"
          class="inline-block text-milkWhite mx-4 hover:text-butterYellow"
        >
          <i data-feather="linkedin" class="w-6 h-6"></i>
        </a>
      </div>

      <div class="mb-6">
        <a href="#home" class="text-milkWhite px-4 py-2 hover:text-butterYellow"
          >Home</a
        >
        <a
          href="#produk"
          class="text-milkWhite px-4 py-2 hover:text-butterYellow"
          >Menu</a
        >
        <a
          href="#kategori"
          class="text-milkWhite px-4 py-2 hover:text-butterYellow"
          >Categories</a
        >
        <a
          href="#reviews"
          class="text-milkWhite px-4 py-2 hover:text-butterYellow"
          >Reviews</a
        >
      </div>

      <div class="text-sm">
        <p>
          Created by
          <a href="#" class="text-butterYellow font-bold">Muhamad Rafli</a> |
          &copy;2025 SocialBakery. All rights reserved.
        </p>
      </div>
    </footer>
    <!-- Footer End -->

    <!-- JavaScript -->
    <script>
      feather.replace();

      // Mobile menu toggle
      const hamburger = document.getElementById("hamburger-menu");
      const mobileMenu = document.getElementById("mobile-menu");

      hamburger.addEventListener("click", () => {
        if (mobileMenu.classList.contains("right-[-100%]")) {
          mobileMenu.classList.remove("right-[-100%]");
          mobileMenu.classList.add("right-0");
        } else {
          mobileMenu.classList.remove("right-0");
          mobileMenu.classList.add("right-[-100%]");
        }
      });

      // Close mobile menu when clicking on links
      const mobileLinks = document.querySelectorAll("#mobile-menu a");

      mobileLinks.forEach((link) => {
        link.addEventListener("click", () => {
          mobileMenu.classList.remove("right-0");
          mobileMenu.classList.add("right-[-100%]");
        });
      });

      // Smooth scroll
      document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
        anchor.addEventListener("click", function (e) {
          e.preventDefault();

          document.querySelector(this.getAttribute("href")).scrollIntoView({
            behavior: "smooth",
          });
        });
      });

      // Review slider functionality
      document.addEventListener("DOMContentLoaded", function () {
        const reviewSliderContent = document.getElementById(
          "review-slider-content"
        );
        const reviewPrevBtn = document.getElementById("review-prev-btn");
        const reviewNextBtn = document.getElementById("review-next-btn");
        const reviewDots = document.querySelectorAll("[data-index]");

        let currentReviewSlide = 0;
        const reviewSlidesCount = reviewSliderContent.children.length;

        // Update slider position
        function updateReviewSlider() {
          reviewSliderContent.style.transform = `translateX(-${
            currentReviewSlide * 100
          }%)`;

          // Update dots
          reviewDots.forEach((dot, index) => {
            if (index === currentReviewSlide) {
              dot.classList.remove("opacity-50");
              dot.classList.add("opacity-100");
            } else {
              dot.classList.remove("opacity-100");
              dot.classList.add("opacity-50");
            }
          });
        }

        // Next button event
        reviewNextBtn.addEventListener("click", function () {
          if (currentReviewSlide < reviewSlidesCount - 1) {
            currentReviewSlide++;
          } else {
            currentReviewSlide = 0;
          }
          updateReviewSlider();
        });

        // Previous button event
        reviewPrevBtn.addEventListener("click", function () {
          if (currentReviewSlide > 0) {
            currentReviewSlide--;
          } else {
            currentReviewSlide = reviewSlidesCount - 1;
          }
          updateReviewSlider();
        });

        // Dot navigation event
        reviewDots.forEach((dot, index) => {
          dot.addEventListener("click", function () {
            currentReviewSlide = index;
            updateReviewSlider();
          });
        });

        // Auto-slide functionality
        let slideInterval = setInterval(() => {
          if (currentReviewSlide < reviewSlidesCount - 1) {
            currentReviewSlide++;
          } else {
            currentReviewSlide = 0;
          }
          updateReviewSlider();
        }, 5000);

        // Pause auto-slide when hovering over the slider
        document
          .getElementById("review-slider-container")
          .addEventListener("mouseenter", () => {
            clearInterval(slideInterval);
          });

        // Resume auto-slide when mouse leaves the slider
        document
          .getElementById("review-slider-container")
          .addEventListener("mouseleave", () => {
            slideInterval = setInterval(() => {
              if (currentReviewSlide < reviewSlidesCount - 1) {
                currentReviewSlide++;
              } else {
                currentReviewSlide = 0;
              }
              updateReviewSlider();
            }, 5000);
          });
      });
    </script>
  </body>
</html>

