<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Kategori, model.Produk" %>
<%
    List<Kategori> kategoriList = (List<Kategori>) request.getAttribute("kategoriList");
    if (kategoriList == null) kategoriList = new ArrayList<>();

    List<Produk> produkList = (List<Produk>) request.getAttribute("produkList");
    if (produkList == null) produkList = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - SocialBakery</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-yellow-50 font-sans text-gray-800 min-h-screen">
<header class="bg-gradient-to-r from-yellow-800 to-yellow-500 text-white p-6 shadow-md flex justify-between items-center">
    <div>
        <h1 class="text-3xl font-bold flex items-center">
            Admin Dashboard
        </h1>
        <p class="text-sm opacity-75 mt-1">Kelola kategori dan produk SocialBakery</p>
    </div>
    <a href="LogoutServlet" class="text-white border border-white px-4 py-2 rounded hover:bg-white hover:text-yellow-800 transition">Logout</a>
</header>

<main class="max-w-6xl mx-auto py-8 px-4 space-y-8">
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="bg-white shadow-md p-6 rounded-lg text-center">
            <div class="text-4xl font-bold text-yellow-800"><%= kategoriList.size() %></div>
            <p class="text-sm text-gray-600 mt-1">TOTAL KATEGORI</p>
        </div>
        <div class="bg-white shadow-md p-6 rounded-lg text-center">
            <div class="text-4xl font-bold text-yellow-800"><%= produkList.size() %></div>
            <p class="text-sm text-gray-600 mt-1">TOTAL PRODUK</p>
        </div>
    </div>

    <section class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-xl font-semibold text-yellow-800 mb-4">📂 Kelola Kategori</h2>
        <form method="post" action="AdminServlet" class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
            <input type="hidden" name="type" value="kategori" />
            <input type="hidden" name="action" value="add" />
            <input type="text" name="nama" placeholder="Masukkan nama kategori" required class="border rounded px-4 py-2" />
            <input type="text" name="deskripsi" placeholder="Masukkan deskripsi kategori" class="border rounded px-4 py-2" />
            <button type="submit" class="bg-yellow-700 text-white rounded px-4 py-2 hover:bg-yellow-800 transition">+ Tambah</button>
        </form>
        <% if (!kategoriList.isEmpty()) { %>
        <div class="overflow-auto">
            <table class="min-w-full text-sm text-left">
                <thead class="bg-yellow-700 text-white">
                    <tr>
                        <th class="p-3">ID</th>
                        <th class="p-3">Nama</th>
                        <th class="p-3">Deskripsi</th>
                        <th class="p-3 text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody class="bg-white">
                <% for (Kategori k : kategoriList) { %>
                    <tr class="border-t hover:bg-yellow-50">
                        <td class="p-3"><%= k.getId() %></td>
                        <td class="p-3 font-semibold"><%= k.getNama() %></td>
                        <td class="p-3"><%= k.getDeskripsi() %></td>
                        <td class="p-3 text-center">
                            <form method="post" action="AdminServlet" onsubmit="return confirm('Yakin hapus kategori ini?')" class="inline">
                                <input type="hidden" name="type" value="kategori" />
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="id" value="<%= k.getId() %>" />
                                <button type="submit" class="text-red-600 hover:text-red-800 font-medium">Hapus</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <p class="text-center text-gray-500 py-4">Belum ada kategori ditambahkan.</p>
        <% } %>
    </section>

    <section class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-xl font-semibold text-yellow-800 mb-4">🛆 Kelola Produk</h2>
        <% if (!kategoriList.isEmpty()) { %>
        <form method="post" action="AdminServlet" enctype="multipart/form-data" class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
            <input type="hidden" name="type" value="produk" />
            <input type="hidden" name="action" value="add" />
            <input type="text" name="nama" placeholder="Nama produk" required class="border rounded px-4 py-2" />
            <input type="number" name="harga" placeholder="Harga" required class="border rounded px-4 py-2" />
            <select name="kategori_id" required class="border rounded px-4 py-2">
                <option value="">Pilih kategori</option>
                <% for (Kategori k : kategoriList) { %>
                    <option value="<%= k.getId() %>"><%= k.getNama() %></option>
                <% } %>
            </select>
            <input type="file" name="gambar" accept="image/*" class="border rounded px-4 py-2" />
            <div class="col-span-full">
                <textarea name="deskripsi" placeholder="Deskripsi produk" class="border rounded w-full px-4 py-2"></textarea>
            </div>
            <div class="col-span-full">
                <button type="submit" class="bg-yellow-700 text-white rounded px-4 py-2 hover:bg-yellow-800 transition w-full">+ Tambah Produk</button>
            </div>
        </form>
        <% } else { %>
        <p class="text-center text-gray-500">Tambahkan kategori terlebih dahulu sebelum menambah produk.</p>
        <% } %>

        <% if (!produkList.isEmpty()) { %>
        <div class="overflow-auto">
            <table class="min-w-full text-sm text-left">
                <thead class="bg-yellow-700 text-white">
                    <tr>
                        <th class="p-3">ID</th>
                        <th class="p-3">Nama</th>
                        <th class="p-3">Deskripsi</th>
                        <th class="p-3">Harga</th>
                        <th class="p-3">Kategori</th>
                        <th class="p-3">Gambar</th>
                        <th class="p-3 text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody class="bg-white">
                <% for (Produk p : produkList) { %>
                    <tr class="border-t hover:bg-yellow-50">
                        <td class="p-3"><%= p.getId() %></td>
                        <td class="p-3 font-semibold"><%= p.getNama() %></td>
                        <td class="p-3"><%= p.getDeskripsi() %></td>
                        <td class="p-3 text-green-600 font-medium">Rp <%= String.format("%,.0f", p.getHarga()) %></td>
                        <td class="p-3"><%= p.getKategori() != null ? p.getKategori().getNama() : "-" %></td>
                        <td class="p-3">
                            <% if (p.getGambar() != null && !p.getGambar().isEmpty()) { %>
                                <img src="<%= p.getGambar() %>" alt="img" class="w-16 h-16 object-cover rounded" />
                            <% } else { %>
                                <span class="text-gray-400">-</span>
                            <% } %>
                        </td>
                        <td class="p-3 text-center">
                            <form method="post" action="AdminServlet" onsubmit="return confirm('Yakin hapus produk ini?')" class="inline">
                                <input type="hidden" name="type" value="produk" />
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="id" value="<%= p.getId() %>" />
                                <button type="submit" class="text-red-600 hover:text-red-800 font-medium">Hapus</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <p class="text-center text-gray-500 py-4">Belum ada produk ditambahkan.</p>
        <% } %>
    </section>
</main>
</body>
</html>