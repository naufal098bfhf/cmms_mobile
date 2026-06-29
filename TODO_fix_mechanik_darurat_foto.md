# TODO Fix: Foto tidak tampil di Tugas Darurat (Mekanik)

- [ ] Analisis sumber masalah: path URL foto yang dipakai `Image.network`.
- [ ] Cek kemungkinan `buktiFoto` berisi value full URL / atau hanya filename.
- [ ] Perbaiki widget tampilan foto agar:
  - aman terhadap null/kosong
  - menggunakan URL yang benar (tanpa double `/storage/`)
  - ada `errorBuilder`/placeholder supaya tidak crash.
- [ ] Pastikan import `dart:io` / dependensi tidak memicu error (gunakan `Image.network` saja untuk view).
- [ ] Jalankan `flutter analyze` dan `flutter test` (jika ada) untuk memastikan tidak ada error.

