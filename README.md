# 🎬 CineScope - Movie App (Flutter)

## 📌 Project Overview

CineScope adalah aplikasi mobile berbasis **Flutter** yang dirancang untuk membantu pengguna menemukan, mencari, dan menyimpan film favorit mereka. Aplikasi ini terintegrasi dengan **Public Movie API (seperti TMDB API)** untuk menampilkan data film secara real-time, termasuk kategori *Popular*, *Top Rated*, dan *Upcoming*.

Aplikasi ini dikembangkan dengan fokus pada:

* Struktur kode modular
* Performa yang responsif
* Pengalaman pengguna yang interaktif
* Dukungan offline (caching)

Dengan tampilan **dark mode modern**, CineScope menghadirkan pengalaman visual yang nyaman dan elegan.

---

## 🚀 Features

### 🏠 Home & Discovery

* Menampilkan daftar film berdasarkan kategori:

  * Popular
  * Top Rated
  * Upcoming
* Filter kategori menggunakan animasi interaktif

---

### 🔍 Search Movie

* Pencarian film berdasarkan judul
* Menggunakan async/await untuk performa optimal
* UI tetap responsif tanpa lag

---

### 🎞️ Movie Detail

* Informasi lengkap film:

  * Poster & backdrop
  * Rating
  * Tanggal rilis
  * Deskripsi
* Tambahkan ke daftar favorit

---

### ❤️ Favorites

* Menyimpan film favorit
* Data tersimpan secara lokal
* Akses cepat melalui navigation bar

---

### 📡 Offline Support

* Menggunakan **SharedPreferences / Hive**
* Menampilkan data terakhir saat offline
* Tidak ada halaman kosong

---

### ⚠️ Error Handling

* Pesan error informatif
* Tetap menampilkan cache jika tersedia

---

### ✨ Shimmer Loading

* Efek loading modern
* Transisi halus
* Tampilan tidak kosong

---

## 🏗️ Architecture & Structure

Aplikasi menggunakan:

* **Separation of Concerns (SoC)**
* **Provider (State Management)**

### 📂 Folder Structure

```
lib/
├── models/       # Data model (Movie)
├── services/     # API & caching
├── providers/    # State management
├── views/        # UI screens
├── widgets/      # Reusable components
```

### 🔧 Layer Responsibility

* **Services** → API & data handling
* **Providers** → State & business logic
* **Views** → UI
* **Widgets** → Komponen reusable

---

## 📈 Scalability & Maintainability

* ✅ Modular & mudah dikembangkan
* ✅ Logic terpisah dari UI
* ✅ Reusable components
* ✅ Mudah menambah fitur baru

### 🔮 Future Improvements

* Pagination / Load more
* User authentication
* TV Shows integration
* Advanced filtering

---

## 📝 Conclusion

CineScope berhasil menggabungkan:

* Integrasi API real-time
* UI modern & responsif
* Arsitektur modular

Aplikasi ini siap untuk dikembangkan lebih lanjut dengan tetap menjaga stabilitas dan kualitas kode.

---
