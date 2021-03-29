import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging_interceptor.dart';

// Necessário encapsular a porta utilizada com o ngrok para
// somente conexões https. Substituir a baseAuthorityUrl após isso
const String baseAuthorityUrl = '15881c146303.ngrok.io';

final Client client = HttpClientWithInterceptor.build(
  interceptors: [
    LoggingInterceptor(),
  ],
);
