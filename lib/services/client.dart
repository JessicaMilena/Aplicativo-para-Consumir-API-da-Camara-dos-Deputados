import 'package:http/http.dart' as http;

abstract class HttpInterface {
  Future get({required String url});
}

class HttpClient implements HttpInterface {
  final client = http.Client();

  @override
  Future get({required String url}) async {
    return await client.get(Uri.parse(url));
  }
}
