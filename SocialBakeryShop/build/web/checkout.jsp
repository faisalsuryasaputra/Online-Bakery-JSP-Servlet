<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) session.getAttribute("error");
    String success = (String) session.getAttribute("success");
    session.removeAttribute("error");
    session.removeAttribute("success");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - SocialBakery</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/feather-icons"></script>
</head>
<body class="bg-gray-50">
    <div class="min-h-screen py-8">
        <div class="max-w-4xl mx-auto px-4">
            <div class="bg-white rounded-lg shadow-lg p-6">
                <h1 class="text-2xl font-bold text-gray-800 mb-6">Checkout Pesanan</h1>
                
                <% if (error != null) { %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                    <%= error %>
                </div>
                <% } %>
                
                <% if (success != null) { %>
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                    <%= success %>
                </div>
                <% } %>

                <form id="checkout-form" action="PesananServlet" method="post" class="space-y-6">
                    <input type="hidden" name="action" value="create">
                    
                    <!-- Order Summary -->
                    <div class="bg-gray-50 p-4 rounded-lg">
                        <h3 class="text-lg font-semibold mb-4">Ringkasan Pesanan</h3>
                        <div id="order-summary" class="space-y-2">
                            <!-- Will be populated by JavaScript -->
                        </div>
                        <div class="border-t pt-2 mt-4">
                            <div class="flex justify-between font-bold text-lg">
                                <span>Total:</span>
                                <span id="total-amount">Rp 0</span>
                            </div>
                        </div>
                    </div>

                    <!-- Hidden inputs for cart items -->
                    <div id="cart-inputs">
                        <!-- Will be populated by JavaScript -->
                    </div>

                    <!-- Delivery Address -->
                    <div>
                        <label for="alamat" class="block text-sm font-medium text-gray-700 mb-2">
                            Alamat Pengiriman *
                        </label>
                        <textarea name="alamat" id="alamat" rows="3" required
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                                placeholder="Masukkan alamat lengkap pengiriman..."></textarea>
                    </div>

                    <!-- Payment Method -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Metode Pembayaran *
                        </label>
                        <div class="space-y-2">
                            <label class="flex items-center">
                                <input type="radio" name="metodePembayaran" value="cod" required class="mr-2">
                                <span>Cash on Delivery (COD)</span>
                            </label>
                            <label class="flex items-center">
                                <input type="radio" name="metodePembayaran" value="transfer" required class="mr-2">
                                <span>Transfer Bank</span>
                            </label>
                            <label class="flex items-center">
                                <input type="radio" name="metodePembayaran" value="ewallet" required class="mr-2">
                                <span>E-Wallet</span>
                            </label>
                        </div>
                    </div>

                    <!-- Notes -->
                    <div>
                        <label for="catatan" class="block text-sm font-medium text-gray-700 mb-2">
                            Catatan (Opsional)
                        </label>
                        <textarea name="catatan" id="catatan" rows="2"
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                                placeholder="Catatan tambahan untuk pesanan..."></textarea>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex gap-4">
                        <button type="button" onclick="history.back()" 
                                class="px-6 py-2 border border-gray-300 text-gray-700 rounded-md hover:bg-gray-50">
                            Kembali
                        </button>
                        <button type="submit" 
                                class="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">
                            Buat Pesanan
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Load cart from localStorage and populate form
        document.addEventListener('DOMContentLoaded', function() {
            const cart = JSON.parse(localStorage.getItem('cart') || '[]');
            
            if (cart.length === 0) {
                alert('Keranjang belanja kosong!');
                window.location.href = 'dashboard_user.jsp';
                return;
            }

            // Populate order summary
            const orderSummary = document.getElementById('order-summary');
            const totalAmount = document.getElementById('total-amount');
            const cartInputs = document.getElementById('cart-inputs');
            let total = 0;

            cart.forEach((item, index) => {
                const subtotal = item.price * item.quantity;
                total += subtotal;

                // Add to summary display
                const itemDiv = document.createElement('div');
                itemDiv.className = 'flex justify-between';
                itemDiv.innerHTML = `
                    <span>${item.name} x ${item.quantity}</span>
                    <span>Rp ${subtotal.toLocaleString()}</span>
                `;
                orderSummary.appendChild(itemDiv);

                // Add hidden inputs for form submission
                cartInputs.innerHTML += `
                    <input type="hidden" name="productId" value="${item.id}">
                    <input type="hidden" name="productName" value="${item.name}">
                    <input type="hidden" name="quantity" value="${item.quantity}">
                    <input type="hidden" name="price" value="${item.price}">
                `;
            });

            totalAmount.textContent = `Rp ${total.toLocaleString()}`;
        });

        // Clear cart after successful order
        document.getElementById('checkout-form').addEventListener('submit', function() {
            localStorage.removeItem('cart');
        });
    </script>
</body>
</html>