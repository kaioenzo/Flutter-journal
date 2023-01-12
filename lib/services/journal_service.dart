import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class JournalService {
  static const String url = 'http://192.168.22.184:3000/';
  static const String resource = "learnhttp2/";

  http.Client client = InterceptedClient.build(
    interceptors: [
      HttpInterceptor(),
    ],
  );

  Uri getUri() {
    return Uri.parse("$url$resource");
  }

  register(String content) {
    client.post(
      getUri(),
      body: {
        "content": content,
      },
    );
  }

  Future<String> get() async {
    var response = await client.get(
      getUri(),
    );
    return response.body;
  }
}
