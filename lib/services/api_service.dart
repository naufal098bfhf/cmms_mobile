    import 'dart:convert';
    import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/dashboard_admin_model.dart';
import '../models/login_models.dart';
import '../models/tugas_tetap_model.dart';

    import '../models/dashboard_mekanik_model.dart';
    import 'package:image_picker/image_picker.dart';

    class ApiService {
static const String baseUrl =
      "http://192.168.100.218:8001/api";


      // ================= LOGIN =================
      static Future<User> login(String email, String password) async {
        final response = await http.post(
          Uri.parse("$baseUrl/login"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode({
            "email": email,
            "password": password,
          }),
        );
        print("============== LOGIN ==============");
print(response.statusCode);
print(response.body);

        final body = jsonDecode(response.body);

        if (response.statusCode == 200 && body['status'] == true) {
          return User(
  id: body['user']['id'],
  name: body['user']['name'],
  email: body['user']['email'],
  role: body['user']['role'],
  token: body['token'],
  photo: body['user']['photo'],
);
        } else {
          throw Exception(body['message'] ?? "Login gagal");
        }
      }
    // ================= DASHBOARD MEKANIK =================
    static Future<DashboardMekanikModel> getDashboard(String token) async {
      final response = await http.get(
        Uri.parse("$baseUrl/dashboard"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return DashboardMekanikModel.fromJson(body);
      } else {
        throw Exception(body['message'] ?? "Dashboard error");
      }
    }

    // ================= DASHBOARD ADMIN =================
    static Future<DashboardModel> getDashboardAdmin(String token) async {

      print("CALL ADMIN API");

      final response = await http.get(
        Uri.parse("$baseUrl/dashboard-admin"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return DashboardModel.fromJson(body);
      } else {
        throw Exception(body['message'] ?? "Dashboard admin error");
      }
    }

      // ================= GET USERS =================
      static Future<List> getUsers(String token) async {
        final res = await http.get(
          Uri.parse("$baseUrl/users"),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        );

        print("=== DEBUG USERS ===");
        print(res.body); // 🔥 WAJIB BIAR TAHU ISI API

        if (res.statusCode == 200) {
          final body = jsonDecode(res.body);

          // 🔥 HANDLE SEMUA FORMAT API
          if (body is List) {
            return body;
          } else if (body is Map && body.containsKey('data')) {
            return body['data'];
          } else {
            return [];
          }
        } else {
          throw Exception("GET USERS ERROR: ${res.body}");
        }
      }

      // ================= DELETE =================
      static Future deleteUser(int id, String token) async {
        final res = await http.delete(
          Uri.parse("$baseUrl/users/$id"),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        );

        if (res.statusCode != 200) {
          throw Exception("DELETE ERROR: ${res.body}");
        }
      }

      // ================= UPDATE =================
      static Future updateUser(int id, Map data, String token) async {
        final res = await http.put(
          Uri.parse("$baseUrl/users/$id"),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          body: jsonEncode(data),
        );

        if (res.statusCode != 200) {
          throw Exception("UPDATE ERROR: ${res.body}");
        }
      }

      // ================= CREATE =================
      static Future createUser(Map data, String token) async {
        final res = await http.post(
          Uri.parse("$baseUrl/users"),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          body: jsonEncode(data),
        );

        if (res.statusCode == 201 || res.statusCode == 200) {
          return jsonDecode(res.body);
        } else {
          throw Exception("CREATE ERROR: ${res.body}");
        }
      }
      // ================= CREATE + FOTO =================
static Future createUserWithPhoto(
  Map<String, dynamic> data,
  XFile? image,
  String token,
) async {

  final request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/users'),
  );

  request.headers['Authorization'] =
      'Bearer $token';

  request.headers['Accept'] =
      'application/json';

  data.forEach((key, value) {
    request.fields[key] =
        value.toString();
  });

  if (image != null) {

    if (kIsWeb) {

      final bytes =
          await image.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          bytes,
          filename: image.name,
        ),
      );

    } else {

      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          image.path,
        ),
      );
    }
  }

  final response =
      await request.send();

  final body =
      await response.stream
          .bytesToString();

  print("CREATE USER STATUS:");
  print(response.statusCode);

  print("CREATE USER BODY:");
  print(body);

  if (response.statusCode != 200 &&
      response.statusCode != 201) {

    throw Exception(body);
  }

  return jsonDecode(body);
}
      // ================= UPDATE + FOTO =================
  static Future updateUserWithPhoto(
  int id,
  Map data,
  XFile? image,
  String token,
) async {

  final uri =
      Uri.parse("$baseUrl/users/$id");

  final request =
      http.MultipartRequest(
    "POST",
    uri,
  );

  request.headers['Authorization'] =
      "Bearer $token";

  request.headers['Accept'] =
      "application/json";

  request.fields['_method'] = 'PUT';

  data.forEach((key, value) {
    request.fields[key] =
        value.toString();
  });

  print("DATA USER:");
  print(data);

  print("IMAGE:");
  print(image?.path);

  if (image != null) {

    if (kIsWeb) {

      final bytes =
          await image.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          bytes,
          filename: image.name,
        ),
      );

    } else {

      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          image.path,
        ),
      );

    }

    print(
      "FOTO DIKIRIM: ${image.path}",
    );
  }

  final response =
      await request.send();

  final body =
      await response.stream
          .bytesToString();

  print("STATUS:");
  print(response.statusCode);

  print("BODY:");
  print(body);

  if (response.statusCode != 200 &&
      response.statusCode != 201) {

    throw Exception(
      "UPDATE USER ERROR: $body",
    );
  }

  return jsonDecode(body);
}
      // ================= EQUIPMENT =================

    // GET
    static Future<List> getEquipment(String token) async {
      final res = await http.get(
        Uri.parse("$baseUrl/equipment"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("EQUIPMENT: ${res.body}");

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        throw Exception("GET EQUIPMENT ERROR");
      }
    }

    // CREATE
    static Future createEquipment(Map data, String token) async {
      final res = await http.post(
        Uri.parse("$baseUrl/equipment"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception("CREATE ERROR");
      }
    }

    // UPDATE
    static Future updateEquipment(int id, Map data, String token) async {
      final res = await http.put(
        Uri.parse("$baseUrl/equipment/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      if (res.statusCode != 200) {
        throw Exception("UPDATE ERROR");
      }
    }

    // DELETE
    static Future deleteEquipment(int id, String token) async {
      final res = await http.delete(
        Uri.parse("$baseUrl/equipment/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (res.statusCode != 200) {
        throw Exception("DELETE ERROR");
      }
    }

    // ================= TUGAS TETAP =================

    // GET
    static Future<List<TugasTetap>> getTugasTetap() async {
      final res = await http.get(Uri.parse("$baseUrl/tugas-tetap"));

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => TugasTetap.fromJson(e)).toList();
      } else {
        throw Exception("GET ERROR");
      }
    }

    // CREATE
    static Future createTugasTetap(Map data, String token) async {
      final res = await http.post(
        Uri.parse("$baseUrl/tugas-tetap"),
        headers: {
          "Authorization": "Bearer $token", // 🔥 WAJIB
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      print("CREATE TUGAS RESPONSE:");
      print(res.statusCode);
      print(res.body);

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception("CREATE ERROR: ${res.body}");
      }
    }

    // UPDATE
    static Future updateTugasTetap(
        int id, Map data, String token) async {

      final res = await http.put(
        Uri.parse("$baseUrl/tugas-tetap/$id"),
        headers: {
          "Authorization": "Bearer $token", // 🔥 WAJIB
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      print("UPDATE TUGAS:");
      print(res.statusCode);
      print(res.body);

      if (res.statusCode != 200) {
        throw Exception("UPDATE ERROR: ${res.body}");
      }
    }

    // DELETE
    static Future deleteTugasTetap(int id) async {
      final res = await http.delete(
        Uri.parse("$baseUrl/tugas-tetap/$id"),
      );

      if (res.statusCode != 200) {
        throw Exception("DELETE ERROR");
      }
    }
  static Future<List<dynamic>>
  getTugasDaruratAdmin(
    String token,
  ) async {

    try {

      print("TOKEN:");
      print(token);

      final res = await http.get(

        Uri.parse(
          "$baseUrl/admin/tugas-darurat",
        ),

        headers: {

          "Authorization":
              "Bearer $token",

          "Accept":
              "application/json",
        },
      );

      print(
        "========== GET TUGAS ADMIN ==========",
      );

      print("STATUS:");
      print(res.statusCode);

      print("BODY:");
      print(res.body);

      // ====================================
      // UNAUTHORIZED
      // ====================================
      if (res.statusCode == 401) {

        throw Exception(
          "401 Unauthorized",
        );
      }

      // ====================================
      // ERROR SERVER
      // ====================================
      if (res.statusCode != 200) {

        throw Exception(
          "Server Error ${res.statusCode}",
        );
      }

      final body =
          jsonDecode(res.body);

      print("JSON TYPE:");
      print(body.runtimeType);

      // ====================================
      // RESPONSE LIST
      // ====================================
      if (body is List) {

        return body;
      }

      // ====================================
      // RESPONSE MAP
      // ====================================
      if (body is Map &&
          body.containsKey('data')) {

        return body['data'];
      }

      return [];

    } catch (e) {

      print(
        "ERROR GET TUGAS ADMIN:",
      );

      print(e);

      rethrow;
    }
  }

      static Future<List<dynamic>> getTugasDarurat(
        String token,
    ) async {

      try {

        print("TOKEN LOGIN:");
        print(token);

        final res = await http.get(
          Uri.parse(
            "$baseUrl/mekanik/tugas-darurat",
          ),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        );

        print("========== API TUGAS DARURAT ==========");
        print("STATUS CODE:");
        print(res.statusCode);

        print("BODY:");
        print(res.body);

        // ===================================
        // UNAUTHORIZED
        // ===================================
        if (res.statusCode == 401) {

          throw Exception(
            "401 Unauthorized",
          );
        }

        // ===================================
        // SERVER ERROR
        // ===================================
        if (res.statusCode != 200) {

          throw Exception(
            "Server Error ${res.statusCode}",
          );
        }

        // ===================================
        // JSON
        // ===================================
        final body = jsonDecode(res.body);

        print("JSON TYPE:");
        print(body.runtimeType);

        // ===================================
        // VALIDASI LIST
        // ===================================
        if (body is! List) {

          throw Exception(
            "Response bukan List",
          );
        }

        return body;

      } catch (e) {

        print("ERROR API:");
        print(e);

        rethrow;
      }
    }
    // CREATE
  static Future<dynamic> createTugasDarurat(
      Map data,
      String token,
  ) async {

    final res = await http.post(

      Uri.parse("$baseUrl/tugas-darurat"),

      headers: {

        "Authorization": "Bearer $token",

        "Accept": "application/json",

        "Content-Type": "application/json",
      },

      body: jsonEncode(data),
    );

    print("========== CREATE DARURAT ==========");
    print(res.statusCode);
    print(res.body);

    if (res.statusCode == 200 ||
        res.statusCode == 201) {

      return jsonDecode(res.body);

    } else {

      throw Exception(
        "CREATE DARURAT ERROR: ${res.body}",
      );
    }
  }

    // DELETE
    static Future deleteTugasDarurat(int id) async {
      final res = await http.delete(
        Uri.parse("$baseUrl/tugas-darurat/$id"),
      );

      if (res.statusCode != 200) {
        throw Exception("DELETE DARURAT ERROR");
      }

      
    }
    // ================= NOTIFIKASI =================

    // GET NOTIFIKASI
    static Future getNotifikasi(int userId) async {
      final res = await http.get(
        Uri.parse("$baseUrl/notifikasi/$userId"),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        throw Exception("GET NOTIF ERROR");
      }
    }

    // READ NOTIFIKASI
    static Future readNotifikasi(int id) async {
      final res = await http.put(
        Uri.parse("$baseUrl/notifikasi/read/$id"),
      );

      if (res.statusCode != 200) {
        throw Exception("READ NOTIF ERROR");
      }
    }
    // ================================
    // 🔥 RIWAYAT TUGAS
    // ================================
    static Future<List> getRiwayatTugas({
  String? startDate,
  String? endDate,
  String? search,
}) async {

  String url = "$baseUrl/riwayat-tugas?";

  if (startDate != null) {
    url += "start_date=$startDate&";
  }

  if (endDate != null) {
    url += "end_date=$endDate&";
  }

  if (search != null && search.isNotEmpty) {
    url += "search=$search";
  }

  final res = await http.get(
    Uri.parse(url),
  );

  print("========== RIWAYAT API ==========");
  print(res.statusCode);
  print(res.body);

  if (res.statusCode != 200) {
    throw Exception(
      "Gagal load riwayat",
    );
  }

  final body =
      jsonDecode(res.body);

  print(
    "BODY TYPE = ${body.runtimeType}",
  );

  return body;
}

      // UPDATE STATUS
    static Future updateStatus(
        int id,
        String status,
        String token,
    ) async {

      final res = await http.put(
        Uri.parse("$baseUrl/mekanik/tugas-darurat/$id/status"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {
          "status": status,
        },
      );

      print("UPDATE STATUS:");
      print(res.statusCode);
      print(res.body);

      if (res.statusCode != 200) {
        throw Exception("UPDATE STATUS ERROR");
      }
    }

static Future uploadFoto(
      int id,
      XFile file,
      String token,
    ) async {

      try {
        final uri =
            Uri.parse("$baseUrl/mekanik/tugas-darurat/$id/upload");

        final request =
            http.MultipartRequest('POST', uri);

        request.headers['Authorization'] =
            "Bearer $token";
        request.headers['Accept'] =
            "application/json";

        // =========================
        // FILE FOTO
        // =========================
        if (kIsWeb) {
          // Flutter Web: tidak ada file path filesystem
          final bytes = await file.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              'bukti_foto',
              bytes,
              filename: file.name,
            ),
          );
        } else {
          // Android/iOS
          request.files.add(
            await http.MultipartFile.fromPath(
              'bukti_foto',
              file.path,
            ),
          );
        }
      
        print("UPLOAD FILE NAME: ${file.name}");

        final response = await request.send();
        final body =
            await response.stream.bytesToString();

        print("UPLOAD RESPONSE: ${response.statusCode}");
        print(body);

        if (response.statusCode != 200) {
          throw Exception("Upload gagal (${response.statusCode}) - $body");
        }

        return body;
      } catch (e) {
        print("ERROR UPLOAD FOTO: $e");
        rethrow;
      }
    }


    static Future uploadFotoTugasTetap(
  int id,
  XFile file,
  String token,
) async {

  try {

    final uri = Uri.parse(
      "$baseUrl/mekanik/tugas-tetap/$id/upload",
    );

    final request =
        http.MultipartRequest(
      'POST',
      uri,
    );

    request.headers['Authorization'] =
        "Bearer $token";

    request.headers['Accept'] =
        "application/json";

    if (kIsWeb) {

      final bytes =
          await file.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'foto',
          bytes,
          filename: file.name,
        ),
      );

    } else {

      request.files.add(
        await http.MultipartFile.fromPath(
          'foto',
          file.path,
        ),
      );
    }

    final response =
        await request.send();

    final body =
        await response.stream
            .bytesToString();

    print(body);

    if (response.statusCode != 200) {

      throw Exception(
        "Upload gagal",
      );
    }

  } catch (e) {

    print(
      "ERROR UPLOAD TUGAS TETAP: $e",
    );

    rethrow;
  }
}
      // =========================================
    // UPDATE TUGAS DARURAT
    // =========================================
    static Future updateTugasDarurat(

      int id,

      Map<String, dynamic> data,

      String token,

    ) async {

      try {

        final res = await http.put(

          Uri.parse(
            "$baseUrl/tugas-darurat/$id",
          ),

          headers: {

            "Authorization":
                "Bearer $token",

            "Accept":
                "application/json",
          },

          body: data.map(
            (key, value) =>
                MapEntry(
              key,
              value.toString(),
            ),
          ),
        );

        print(
          "========== UPDATE TUGAS ==========",
        );

        print(
          "STATUS CODE:",
        );

        print(
          res.statusCode,
        );

        print(
          "BODY:",
        );

        print(
          res.body,
        );

        // =====================================
        // ERROR
        // =====================================
        if (res.statusCode != 200 &&
            res.statusCode != 201) {

          throw Exception(
            "Gagal update tugas",
          );
        }

        return jsonDecode(
          res.body,
        );

      } catch (e) {

        print(
          "ERROR UPDATE TUGAS:",
        );

        print(e);

        rethrow;
      }
    }
    static Future<List<dynamic>>
getTugasTetapMekanik(
  String token,
) async {

  final res = await http.get(
    Uri.parse(
      "$baseUrl/mekanik/tugas-tetap",
    ),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
  );

  if (res.statusCode != 200) {
    throw Exception(
      "Gagal mengambil tugas tetap",
    );
  }

  return jsonDecode(res.body);
}
// ===============================
// HAPUS 1 NOTIFIKASI
// ===============================
static Future<void> hapusNotifikasi(
  int id,
) async {

  final res = await http.delete(
    Uri.parse(
      "$baseUrl/notifikasi/$id",
    ),
    headers: {
      "Accept": "application/json",
    },
  );

  print("DELETE NOTIF STATUS:");
  print(res.statusCode);

  print("DELETE NOTIF BODY:");
  print(res.body);

  if (res.statusCode != 200) {
    throw Exception(res.body);
  }
}
// ===============================
// HAPUS SEMUA NOTIFIKASI
// ===============================
static Future<void>
hapusSemuaNotifikasi(
  int userId,
) async {

  final res = await http.delete(
    Uri.parse(
      "$baseUrl/notifikasi/user/$userId",
    ),
  );

  if (res.statusCode != 200) {
    throw Exception(
      "Gagal menghapus semua notifikasi",
    );
  }
}

static Future<Map<String,dynamic>>
getValidasiMp(
  String token,
) async {

  final res = await http.get(

    Uri.parse(
      "$baseUrl/maintenance-planning/validasi",
    ),

    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
  );

  print("VALIDASI STATUS:");
  print(res.statusCode);

  print("VALIDASI BODY:");
  print(res.body);

  if (res.statusCode != 200) {
    throw Exception(
      "Gagal load validasi",
    );
  }

  return jsonDecode(res.body);
}
// ===================================
// VALIDASI TUGAS TETAP
// ===================================
static Future<void> validasiTetap(
  int id,
  String token,
) async {

  final res = await http.post(
    Uri.parse(
      "$baseUrl/maintenance-planning/validasi/tetap/$id",
    ),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
  );

  print("VALIDASI TETAP:");
  print(res.statusCode);
  print(res.body);

  if (res.statusCode != 200) {
    throw Exception(res.body);
  }
}

// ===================================
// VALIDASI TUGAS DARURAT
// ===================================
static Future<void> validasiDarurat(
  int id,
  String token,
) async {

  final res = await http.post(
    Uri.parse(
      "$baseUrl/maintenance-planning/validasi/darurat/$id",
    ),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
  );

  print("VALIDASI DARURAT:");
  print(res.statusCode);
  print(res.body);

  if (res.statusCode != 200) {
    throw Exception(res.body);
  }
}
static Future<void> deleteNotifikasi(int id) async {
  final response = await http.delete(
    Uri.parse("$baseUrl/notifikasi/$id"),
    headers: {
      "Accept": "application/json",
    },
  );

  print("DELETE STATUS = ${response.statusCode}");
  print("DELETE BODY = ${response.body}");

  if (response.statusCode != 200) {
    throw Exception(response.body);
  }
}
    }    