import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging_interceptor.dart';

// Necessário encapsular a porta utilizada com o ngrok para
// somente conexões https. Substituir a baseAuthorityUrl após isso
const String baseAuthorityUrl = '2643a34e770b.ngrok.io';

final Client client = HttpClientWithInterceptor.build(
  interceptors: [
    LoggingInterceptor(),
  ],
);
