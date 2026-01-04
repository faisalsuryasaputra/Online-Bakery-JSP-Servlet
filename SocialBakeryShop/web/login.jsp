<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="model.Pengguna" %>
<%
    HttpSession userSession = request.getSession(false);
    Pengguna pengguna = null;

    if (userSession != null) {
        pengguna = (Pengguna) userSession.getAttribute("pengguna");
        if (pengguna != null) {
            String role = pengguna.getRole();
            if ("admin".equalsIgnoreCase(role)) {
                response.sendRedirect("AdminServlet");
                return;
            } else if ("user".equalsIgnoreCase(role)) {
                response.sendRedirect("UserDashboardServlet"); 
                return;
            }
        }
    }

    String errorMessage = request.getParameter("error");
    String successMessage = request.getParameter("success");
%>


<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - SocialBakery</title>
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
              errorRed: "#EF4444",
              successGreen: "#10B981",
            },
            fontFamily: {
              poppins: ["Poppins", "sans-serif"],
            },
            animation: {
              'fade-in': 'fadeIn 0.5s ease-in-out',
              'shake': 'shake 0.5s ease-in-out',
            },
            keyframes: {
              fadeIn: {
                '0%': { opacity: '0', transform: 'translateY(-10px)' },
                '100%': { opacity: '1', transform: 'translateY(0)' },
              },
              shake: {
                '0%, 100%': { transform: 'translateX(0)' },
                '25%': { transform: 'translateX(-5px)' },
                '75%': { transform: 'translateX(5px)' },
              }
            }
          },
        },
      };
    </script>
  </head>
  <body class="font-poppins bg-gradient-to-br from-cream to-butterYellow min-h-screen flex items-center justify-center p-4">
    <div class="bg-milkWhite p-8 rounded-2xl shadow-2xl w-full max-w-md mx-4 animate-fade-in border border-lightBrown/20">
      <!-- Header -->
      <div class="text-center mb-8">
        <a href="index.jsp" class="inline-block">
          <h1 class="text-3xl font-bold text-darkBrown hover:scale-105 transition-transform duration-300">
            Social<span class="text-lightBrown">Bakery</span>
          </h1>
        </a>
        <p class="text-darkBrown/70 mt-3 text-sm">Selamat datang kembali! Silakan masuk ke akun Anda.</p>
      </div>

      <!-- Alert Messages -->
      <% if (errorMessage != null) { %>
      <div class="mb-4 p-3 bg-errorRed/10 border border-errorRed/20 rounded-lg animate-shake">
        <div class="flex items-center">
          <i data-feather="alert-circle" class="w-4 h-4 text-errorRed mr-2"></i>
          <span class="text-errorRed text-sm font-medium">
            <% 
              if ("invalid".equals(errorMessage)) {
                out.print("Email atau password tidak valid!");
              } else if ("empty".equals(errorMessage)) {
                out.print("Email dan password harus diisi!");
              } else if ("blocked".equals(errorMessage)) {
                out.print("Akun Anda telah diblokir. Hubungi administrator.");
              } else {
                out.print("Terjadi kesalahan. Silakan coba lagi.");
              }
            %>
          </span>
        </div>
      </div>
      <% } %>

      <% if (successMessage != null) { %>
      <div class="mb-4 p-3 bg-successGreen/10 border border-successGreen/20 rounded-lg">
        <div class="flex items-center">
          <i data-feather="check-circle" class="w-4 h-4 text-successGreen mr-2"></i>
          <span class="text-successGreen text-sm font-medium">
            <% 
              if ("registered".equals(successMessage)) {
                out.print("Registrasi berhasil! Silakan login.");
              } else if ("logout".equals(successMessage)) {
                out.print("Anda telah berhasil logout.");
              }
            %>
          </span>
        </div>
      </div>
      <% } %>

      <!-- Login Form -->
      <form id="loginForm" class="space-y-6" action="LoginServlet" method="post" novalidate>
        <div class="space-y-1">
          <label for="email" class="block text-darkBrown font-medium text-sm">Email</label>
          <div class="relative">
            <input
              type="email"
              name="email"
              id="email"
              class="w-full px-4 py-3 pl-10 rounded-lg border border-lightBrown/30 focus:outline-none focus:border-lightBrown focus:ring-2 focus:ring-lightBrown/20 transition-all duration-300"
              placeholder="Masukkan email Anda"
              value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
              required
              autocomplete="email"
            />
            <i data-feather="mail" class="w-4 h-4 absolute left-3 top-1/2 transform -translate-y-1/2 text-lightBrown"></i>
          </div>
          <span id="emailError" class="text-errorRed text-xs hidden">Email tidak valid</span>
        </div>

        <div class="space-y-1">
          <label for="password" class="block text-darkBrown font-medium text-sm">Password</label>
          <div class="relative">
            <input
              type="password"
              name="password"
              id="password"
              class="w-full px-4 py-3 pl-10 pr-12 rounded-lg border border-lightBrown/30 focus:outline-none focus:border-lightBrown focus:ring-2 focus:ring-lightBrown/20 transition-all duration-300"
              placeholder="Masukkan password Anda"
              required
              autocomplete="current-password"
              minlength="6"
            />
            <i data-feather="lock" class="w-4 h-4 absolute left-3 top-1/2 transform -translate-y-1/2 text-lightBrown"></i>
            <button
              type="button"
              id="togglePassword"
              class="absolute right-3 top-1/2 transform -translate-y-1/2 text-lightBrown hover:text-darkBrown transition-colors"
            >
              <i data-feather="eye" class="w-4 h-4"></i>
            </button>
          </div>
          <span id="passwordError" class="text-errorRed text-xs hidden">Password minimal 6 karakter</span>
        </div>

        <div class="flex items-center justify-between">
          <label class="flex items-center cursor-pointer">
            <input 
              type="checkbox" 
              name="remember" 
              class="rounded text-lightBrown focus:ring-lightBrown border-lightBrown/30" 
            />
            <span class="ml-2 text-darkBrown/70 text-sm">Ingat saya</span>
          </label>
          <a href="forgot-password.jsp" class="text-lightBrown hover:text-darkBrown text-sm hover:underline transition-colors">
            Lupa password?
          </a>
        </div>

        <button
          type="submit"
          id="loginButton"
          class="w-full bg-lightBrown text-milkWhite py-3 rounded-lg font-medium hover:bg-darkBrown focus:outline-none focus:ring-2 focus:ring-lightBrown/50 transition-all duration-300 transform hover:scale-[1.02] active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <span id="buttonText">Masuk</span>
          <span id="loadingSpinner" class="hidden">
            <i data-feather="loader" class="w-4 h-4 animate-spin inline mr-2"></i>
            Memproses...
          </span>
        </button>
      </form>

      <!-- Divider -->
      <div class="my-6 flex items-center">
        <div class="flex-1 border-t border-lightBrown/20"></div>
        <span class="px-4 text-darkBrown/50 text-sm">atau</span>
        <div class="flex-1 border-t border-lightBrown/20"></div>
      </div>

      <!-- Register Link -->
      <div class="text-center">
        <p class="text-darkBrown/70 text-sm">
          Belum punya akun?
          <a href="register.jsp" class="text-lightBrown hover:text-darkBrown font-medium hover:underline transition-colors">
            Daftar sekarang
          </a>
        </p>
      </div>

      <!-- Back to Home -->
      <div class="mt-4 text-center">
        <a href="index.jsp" class="inline-flex items-center text-darkBrown/50 hover:text-darkBrown text-sm transition-colors">
          <i data-feather="arrow-left" class="w-4 h-4 mr-1"></i>
          Kembali ke beranda
        </a>
      </div>
    </div>

    <script>
      // Initialize Feather Icons
      feather.replace();

      // Form validation and enhancement
      document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('loginForm');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');
        const togglePassword = document.getElementById('togglePassword');
        const loginButton = document.getElementById('loginButton');
        const buttonText = document.getElementById('buttonText');
        const loadingSpinner = document.getElementById('loadingSpinner');

        // Toggle password visibility
        togglePassword.addEventListener('click', function() {
          const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
          passwordInput.setAttribute('type', type);
          
          const icon = type === 'password' ? 'eye' : 'eye-off';
          togglePassword.innerHTML = `<i data-feather="${icon}" class="w-4 h-4"></i>`;
          feather.replace();
        });

        // Email validation
        emailInput.addEventListener('blur', function() {
          const emailError = document.getElementById('emailError');
          const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          
          if (this.value && !emailRegex.test(this.value)) {
            emailError.classList.remove('hidden');
            this.classList.add('border-errorRed');
          } else {
            emailError.classList.add('hidden');
            this.classList.remove('border-errorRed');
          }
        });

        // Password validation
        passwordInput.addEventListener('blur', function() {
          const passwordError = document.getElementById('passwordError');
          
          if (this.value && this.value.length < 6) {
            passwordError.classList.remove('hidden');
            this.classList.add('border-errorRed');
          } else {
            passwordError.classList.add('hidden');
            this.classList.remove('border-errorRed');
          }
        });

        // Form submission
        form.addEventListener('submit', function(e) {
          const email = emailInput.value.trim();
          const password = passwordInput.value.trim();

          // Basic validation
          if (!email || !password) {
            e.preventDefault();
            alert('Email dan password harus diisi!');
            return;
          }

          // Email format validation
          const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          if (!emailRegex.test(email)) {
            e.preventDefault();
            alert('Format email tidak valid!');
            emailInput.focus();
            return;
          }

          // Password length validation
          if (password.length < 6) {
            e.preventDefault();
            alert('Password minimal 6 karakter!');
            passwordInput.focus();
            return;
          }

          // Show loading state
          loginButton.disabled = true;
          buttonText.classList.add('hidden');
          loadingSpinner.classList.remove('hidden');
        });

        // Auto-focus on email input if empty
        if (!emailInput.value) {
          emailInput.focus();
        }

        // Handle browser back button
        window.addEventListener('pageshow', function(event) {
          if (event.persisted) {
            // Reset form state if page is loaded from cache
            loginButton.disabled = false;
            buttonText.classList.remove('hidden');
            loadingSpinner.classList.add('hidden');
          }
        });
      });

      // Auto-hide alerts after 5 seconds
      setTimeout(function() {
        const alerts = document.querySelectorAll('[class*="bg-errorRed"], [class*="bg-successGreen"]');
        alerts.forEach(function(alert) {
          alert.style.opacity = '0';
          alert.style.transform = 'translateY(-10px)';
          setTimeout(function() {
            alert.remove();
          }, 300);
        });
      }, 5000);
    </script>
  </body>
</html>