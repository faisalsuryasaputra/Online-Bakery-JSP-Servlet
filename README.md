# 🍞 SocialBakeryShop

**SocialBakeryShop** is a simple e-commerce web application designed for ordering bakery products. This project is built using native Java Web technologies (Servlet & JSP), following the MVC (Model-View-Controller) architecture, and utilizes a MySQL database.

This project serves as an excellent reference for learning Java Enterprise web development, user session management, and database CRUD operations.

## 🌟 Key Features

The application allows for two distinct user roles:

### 👤 Customer (User)
* **Registration & Login:** Create a new account and log in securely.
* **Menu Catalog:** Browse breads and cakes filtered by category.
* **Ordering:** Add items to the cart and proceed to checkout.
* **User Dashboard:** View personal order history.
* **Product Reviews:** Leave reviews on available products.

### 🛡️ Administrator (Admin)
* **Admin Dashboard:** View a summary of shop activities.
* **Product Management:** Add, edit, and delete bakery products.
* **Category Management:** Organize product categories.
* **Order Management:** View and manage incoming orders from customers.

## 🛠️ Tech Stack

* **Programming Language:** Java (JDK 8+)
* **Backend:** Java Servlet
* **Frontend:** Java Server Pages (JSP), HTML, CSS
* **Database:** MySQL
* **DB Connectivity:** JDBC (MySQL Connector)
* **Build Tool:** Apache Ant (Native NetBeans Project)
* **Server:** Apache Tomcat 9.0+

## 📂 Project Structure

```text
SocialBakeryShop/
├── src/java/
│   ├── classes/       # Database Configuration (JDBC)
│   ├── model/         # Data Objects (Product, Order, User, etc.)
│   └── servlet/       # Business Logic (Controllers)
├── web/               # View Pages (JSP)
│   ├── dashboard_admin.jsp
│   ├── dashboard_user.jsp
│   ├── menu.jsp
│   └── ...
├── nbproject/         # NetBeans Configuration
└── build.xml          # Ant Build Script
