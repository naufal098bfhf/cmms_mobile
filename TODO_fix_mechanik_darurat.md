# TODO Fix Mekanik Tugas Darurat (Android)

- [ ] Cek endpoint Flutter vs route Laravel API untuk:
  - [ ] PUT /api/mekanik/tugas-darurat/{id}/status
  - [ ] POST /api/mekanik/tugas-darurat/{id}/upload
- [ ] Tambahkan debug log pada Flutter agar respons JSON backend terlihat jelas.
- [ ] Pastikan updateStatus menggunakan ApiService milik yang benar (tidak ganda yang berpotensi salah payload).
- [ ] Pastikan uploadFoto mengirim multipart field name yang benar: `bukti_foto`.
- [ ] Pastikan parsing `id` pada model benar dan `t.id` sesuai record `TugasDarurat` mekanik.
- [ ] Test flow akhir di Android:
  - [ ] Load list tugas darurat
  - [ ] Update status pending->dikerjakan->selesai
  - [ ] Upload bukti foto dan tampilkan ulang bukti Foto.

