# Proyek Akhir: Peningkatan Restaurant App (Kulinere)

## Tujuan

Proyek ini merupakan iterasi lanjutan dari Restaurant App yang telah dibangun sebelumnya, dengan nama**Kulinere**. Tujuan utama adalah membuat aplikasi siap produksi dengan menambahkan fitur persistensi data lokal, pengaturan pengguna, notifikasi terjadwal, dan pengujian yang komprehensif.

Aplikasi harus tetap mempertahankan semua fungsionalitas dan kualitas dari implementasi sebelumnya, sesuai dengan dokumen-dokumen berikut:
- `PRD/restaurant_app_implementation_guide.MD`
- `PRD/product_requirement.MD`
- `PRD/design_system.MD`

Desain tetap minimalis, modern, dan user-centered: hindari elemen berlebihan seperti gradient tidak perlu, prioritaskan whitespace, readability, dan responsivitas di iOS/Android.

## Kriteria Wajib

Semua kriteria berikut harus dipenuhi untuk memastikan aplikasi robust, persistens, dan testable.

1. **Mempertahankan Kriteria Utama dari Submission Sebelumnya**
   - Semua fitur dan kualitas dari versi sebelumnya harus tetap berfungsi sempurna:
     - Halaman daftar dan detail restoran dengan data dari API.
     - Tema light/dark dengan font modern.
     - State management menggunakan Provider (dengan sealed classes untuk API states).
     - Indikator loading, error handling, Hero animation.
     - Fitur pencarian dan review.
     - Clean code, no overflow, tampilan informasi lengkap di halaman detail.
   - Pastikan tidak ada regresi fungsionalitas.

2. **Halaman Favorit Restoran dengan Penyimpanan Lokal (SQLite)**
   - Buat halaman khusus untuk daftar restoran favorit (bisa diakses via tab atau menu navigasi).
   - Tampilan menggunakan card serupa dengan daftar utama: nama, gambar, kota, rating.
   - Tap pada card navigasi ke halaman detail (dengan Hero animation jika memungkinkan).
   - Pengguna dapat menambah/menghapus favorit dari halaman daftar atau detail (misalnya via icon bookmark).
   - **Persistencia**: Gunakan SQLite (package `sqflite`) untuk menyimpan data favorit secara lokal.
     - Schema sederhana: tabel `favorites` dengan kolom `id` (primary key), `name`, `city`, `rating`, `pictureId`, dll.
     - Saat aplikasi dibuka, load favorit dari database dan tampilkan.
     - Saat ditutup/dibuka kembali, data favorit tetap ada.

3. **Pengaturan Tema**
   - Buat halaman atau section Settings dengan opsi toggle tema (Light / Dark / System).
   - Simpan pilihan tema menggunakan `shared_preferences`.
   - Tema harus tetap dipertahankan setelah aplikasi ditutup dan dibuka kembali.
   - Pastikan semua komponen UI (teks, ikon, background, card) memiliki kontras dan visibility baik di kedua tema (gunakan ThemeData yang konsisten).

4. **Fitur Pengaturan Daily Reminder**
   - Di halaman Settings, tambahkan toggle untuk mengaktifkan/menonaktifkan daily reminder.
   - Simpan status toggle menggunakan `shared_preferences`.
   - Jika aktif, jadwalkan notifikasi harian pada pukul 11:00 AM (waktu lokal perangkat).
   - Gunakan package `flutter_local_notifications` untuk notifikasi dan `workmanager` atau `android_alarm_manager_plus` untuk scheduling yang reliable di background (cross-platform).
   - **Peningkatan Lanjutan** (lihat Penilaian): Notifikasi menampilkan rekomendasi restoran acak dari API (fetch data saat scheduling, atau cache lokal).

## Kriteria Penilaian dan Fitur Tambahan

Fitur-fitur ini menentukan nilai tambah dan kualitas produksi.

1. **Menuliskan Kode dengan Bersih**
   - Hapus semua komentar, kode unused, dan import tidak terpakai.
   - Indentasi konsisten, gunakan `flutter format`.
   - Struktur folder modular (misalnya: features/favorites, core/database, core/preferences).

2. **Menampilkan Pesan Error**
   - Tampilkan error yang jelas saat gagal load data API atau operasi lokal (misalnya SQLite error).
   - Gunakan teks sederhana + ikon/animasi minimalis, dengan tombol retry jika relevan.

3. **Pengujian pada Provider**
   - Terapkan minimal tiga skenario unit test untuk Provider yang mengambil daftar restoran:
     - State awal terdefinisi dengan benar (loading).
     - Mengembalikan data sukses saat API berhasil.
     - Mengembalikan error saat API gagal (mock dengan failure).

4. **Menerapkan 4 Jenis Testing yang Berbeda**
   - Tulis minimal satu test case untuk masing-masing:
     - Unit test (logic Provider atau database helper).
     - Widget test (misalnya toggle tema atau bookmark button).
     - Integration test (navigasi daftar → detail → favorit).
   - Semua test harus lulus.

5. **Menerapkan 6 atau Lebih Testing**
   - Total minimal 6 test case (bisa campur unit/widget/integration).
   - Coverage mencakup fitur kunci: favorit SQLite, tema persistence, scheduling notification.

6. **Memodifikasi Notifikasi Daily Reminder**
   - Notifikasi tidak statis: Tampilkan informasi restoran acak (nama + rating) yang diambil dari API.
   - Fetch data saat Workmanager berjalan (gunakan `dio` atau `http` dengan background isolate).
   - Gunakan `flutter_local_notifications` untuk rich notification (judul: "Waktunya makan siang!", body: "Coba kunjungi [Nama Restoran] – Rating [X.XX]").

## Rekomendasi Package (Best Practices)

Gunakan package resmi dan stabil untuk implementasi yang reliable:

- Database: `sqflite` + `path` (untuk favorites).
- Preferences: `shared_preferences` (untuk tema dan reminder toggle).
- Notification: `flutter_local_notifications`.
- Background scheduling: `workmanager` (cross-platform terbaik untuk periodic task).
- Networking: `dio` atau `http` (dengan caching jika perlu).
- Testing: `mockito` atau `mocktail` untuk mocking API/database.

## Ketentuan yang Dilarang

Proyek akan ditolak jika tidak sesuai kriteria. Berikut poin-poin yang **harus diperhatikan dan dihindari**:

- Tidak memenuhi kriteria yang sudah ditentukan.
- Tidak mempertahankan kriteria utama dari submission sebelumnya.

**Terkait Halaman Favorit:**
- Tidak menggunakan penyimpanan lokal database SQLite.
- Data tidak langsung tampil di halaman favorit setelah item ditambahkan.
- Terdapat item yang duplikat pada halaman favorit.
- Halaman detail tidak bisa dibuka dari halaman favorit.

**Terkait Pengaturan Tema:**
- Tidak menggunakan penyimpanan lokal key-value SharedPreferences.
- Tidak ada menu pengaturan untuk mengganti tema.
- Ketika membuka aplikasi dari awal, tema tidak terimplementasi (tidak persist).

**Terkait Testing:**
- Deskripsi pengujian tidak merepresentasikan fitur yang diuji.

## Tips dan Trik

### Buat Skenario Pengujian yang Mudah
Dalam Software Engineering, Automated Testing terbagi menjadi unit test, widget test, dan integration test. Pilih skenario yang paling mudah diterapkan:
- Unit test: Periksa parsing JSON, pengambilan data API, atau proses CRUD pada database.
- Widget test: Validasi ListView di halaman utama, ikon favorit pada ListTile, dll.

Untuk testing yang melibatkan DataStore (API atau database), lakukan **mocking** terlebih dahulu agar test terisolasi tanpa dipengaruhi kondisi eksternal (internet/perangkat). Pelajari mocking di dokumentasi Flutter: [Mock Dependencies using Mockito](https://docs.flutter.dev/cookbook/testing/unit/mocking).

**Struktur File Testing:**
- Letakkan berkas test di folder `test` (sejajar dengan `lib`).
- Akhiri nama file dengan `_test.dart` agar terdeteksi otomatis.

### Simpan Pengaturan Tema pada SharedPreferences
Jangan lupa simpan nilai toggle tema/reminder. Jika tidak disimpan, nilai akan reset ke default saat app dibuka kembali. Gunakan SharedPreferences untuk persistensi boolean/string, lalu load saat startup.

## Catatan Penting

- **Responsivitas & Accessibility**: Pastikan layout adaptif (gunakan MediaQuery, Flexible), kontras warna tinggi, dan Semantics untuk screen reader.
- **Performance**: Cache gambar dengan `cached_network_image`, hindari memory leak di Provider.
- **Cross-Platform**: Uji di Android dan iOS (notification scheduling berbeda di iOS).
- **Error Handling**: Tangani permission notification, database migration, dan network failure dengan graceful degradation.



