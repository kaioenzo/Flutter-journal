import 'dart:convert';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class JournalService {
  static const String url = 'http://192.168.1.107:3000/';
  static const String resource = "journals/";

  http.Client client = InterceptedClient.build(
    interceptors: [
      HttpInterceptor(),
    ],
  );

  Uri getUri({String? id}) {
    if (id != null) {
      return Uri.parse("$url$resource$id");
    }
    return Uri.parse("$url$resource");
  }

  Future<bool> register(Journal journal) async {
    String data = json.encode(journal.toMap());
    http.Response response = await client.post(
      getUri(),
      body: data,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<bool> update(Journal journal) async {
    String data = json.encode(journal.toMap());
    http.Response response = await client.put(
      getUri(id: journal.id),
      body: data,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    }
    return false;
  }

  Future<bool> delete(String id) async {
    var response = await http.delete(getUri(id: id));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(getUri());
    if (!(response.statusCode == 200)) {
      throw Exception();
    }
    List<dynamic> dynamicList = json.decode(response.body);
    List<Journal> journals = [];
    for (var jsonMap in dynamicList) {
      journals.add(Journal.fromMap(jsonMap));
    }
    return journals;
  }

  Future<String> get() async {
    var response = await client.get(
      getUri(),
    );
    return response.body;
  }
}
