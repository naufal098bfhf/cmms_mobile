# TODO - Fix login_page.dart (build + syntax errors)

- [ ] Rapikan `_login()` try/catch agar braces dan indentasi benar.
- [ ] Bersihkan widget tree `build()` yang saat ini terduplikasi/berantakan (hapus potongan `body: SafeArea...` yang tersisip).
- [ ] Perbaiki email `TextFormField`: pastikan `suffixIcon` masuk ke `decoration: InputDecoration(suffixIcon: ...)`.
- [ ] Perbaiki password `TextFormField`: pastikan `decoration: InputDecoration(...)` hanya muncul sekali dan paramsnya berada di dalam `decoration`.
- [ ] Pastikan ada overlay loading (`if (_loading)`) ditempatkan dengan benar di Stack.
- [ ] Jalankan `flutter analyze` / `flutter test` sampai error hilang.

