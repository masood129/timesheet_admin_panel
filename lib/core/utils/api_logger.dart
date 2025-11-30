import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiLogger {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';
  static const String _white = '\x1B[37m';
  static const String _bold = '\x1B[1m';

  static void logRequest(RequestOptions options) {
    if (!kDebugMode) return;

    final method = options.method.toUpperCase();
    final uri = options.uri.toString();
    final headers = options.headers;
    final data = options.data;
    final queryParams = options.queryParameters;

    debugPrint('\n');
    debugPrint('$_cyan╔════════════════════════════════════════════════════════════════════════════════════$_reset');
    debugPrint('$_cyan║$_reset $_bold${_green}API REQUEST$_reset');
    debugPrint('$_cyan╠════════════════════════════════════════════════════════════════════════════════════$_reset');
    debugPrint('$_cyan║$_reset $_bold${_blue}Method:$_reset $method');
    debugPrint('$_cyan║$_reset $_bold${_blue}URL:$_reset $uri');
    
    if (queryParams.isNotEmpty) {
      debugPrint('$_cyan║$_reset $_bold${_blue}Query Parameters:$_reset');
      queryParams.forEach((key, value) {
        debugPrint('$_cyan║$_reset   • $key: $value');
      });
    }
    
    if (headers.isNotEmpty) {
      debugPrint('$_cyan║$_reset $_bold${_blue}Headers:$_reset');
      headers.forEach((key, value) {
        // Hide sensitive data
        if (key.toLowerCase() == 'authorization') {
          final token = value.toString();
          final maskedToken = token.length > 20 
              ? '${token.substring(0, 7)}...${token.substring(token.length - 4)}'
              : '***';
          debugPrint('$_cyan║$_reset   • $key: $maskedToken');
        } else {
          debugPrint('$_cyan║$_reset   • $key: $value');
        }
      });
    }
    
    if (data != null) {
      debugPrint('$_cyan║$_reset $_bold${_blue}Body:$_reset');
      _printPrettyJson(data);
    }
    
    debugPrint('$_cyan╚════════════════════════════════════════════════════════════════════════════════════$_reset');
  }

  static void logResponse(Response response, int durationMs) {
    if (!kDebugMode) return;

    final statusCode = response.statusCode ?? 0;
    final method = response.requestOptions.method.toUpperCase();
    final uri = response.requestOptions.uri.toString();
    final data = response.data;

    final statusColor = _getStatusColor(statusCode);
    final methodColor = _getMethodColor(method);

    debugPrint('\n');
    debugPrint('$_green╔════════════════════════════════════════════════════════════════════════════════════$_reset');
    debugPrint('$_green║$_reset $_bold${_green}API RESPONSE$_reset');
    debugPrint('$_green╠════════════════════════════════════════════════════════════════════════════════════$_reset');
    debugPrint('$_green║$_reset $_bold${_blue}Method:$_reset $methodColor$method$_reset');
    debugPrint('$_green║$_reset $_bold${_blue}URL:$_reset $uri');
    debugPrint('$_green║$_reset $_bold${_blue}Status Code:$_reset $statusColor$statusCode$_reset ${_getStatusMessage(statusCode)}');
    debugPrint('$_green║$_reset $_bold${_blue}Duration:$_reset ${durationMs}ms');
    
    if (data != null) {
      debugPrint('$_green║$_reset $_bold${_blue}Response Data:$_reset');
      _printPrettyJson(data);
    }
    
    debugPrint('$_green╚════════════════════════════════════════════════════════════════════════════════════$_reset');
  }

  static void logError(DioException error, int durationMs) {
    if (!kDebugMode) return;

    final statusCode = error.response?.statusCode ?? 0;
    final method = error.requestOptions.method.toUpperCase();
    final uri = error.requestOptions.uri.toString();
    final errorMessage = error.message ?? 'Unknown error';
    final responseData = error.response?.data;

    debugPrint('\n');
    debugPrint('$_red╔════════════════════════════════════════════════════════════════════════════════════$_reset');
    debugPrint('$_red║$_reset $_bold${_red}API ERROR$_reset');
    debugPrint('$_red╠════════════════════════════════════════════════════════════════════════════════════$_reset');
    debugPrint('$_red║$_reset $_bold${_blue}Method:$_reset $method');
    debugPrint('$_red║$_reset $_bold${_blue}URL:$_reset $uri');
    debugPrint('$_red║$_reset $_bold${_blue}Status Code:$_reset $_red$statusCode$_reset ${_getStatusMessage(statusCode)}');
    debugPrint('$_red║$_reset $_bold${_blue}Duration:$_reset ${durationMs}ms');
    debugPrint('$_red║$_reset $_bold${_blue}Error Type:$_reset ${error.type}');
    debugPrint('$_red║$_reset $_bold${_blue}Error Message:$_reset $_red$errorMessage$_reset');
    
    if (responseData != null) {
      debugPrint('$_red║$_reset $_bold${_blue}Error Response:$_reset');
      _printPrettyJson(responseData);
    }
    
    debugPrint('$_red╚════════════════════════════════════════════════════════════════════════════════════$_reset');
  }

  static String _getStatusColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) return _green;
    if (statusCode >= 300 && statusCode < 400) return _yellow;
    if (statusCode >= 400 && statusCode < 500) return _red;
    if (statusCode >= 500) return _magenta;
    return _white;
  }

  static String _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return _cyan;
      case 'POST':
        return _green;
      case 'PUT':
        return _yellow;
      case 'DELETE':
        return _red;
      case 'PATCH':
        return _magenta;
      default:
        return _white;
    }
  }

  static String _getStatusMessage(int statusCode) {
    switch (statusCode) {
      case 200:
        return '✓ OK';
      case 201:
        return '✓ Created';
      case 204:
        return '✓ No Content';
      case 400:
        return '✗ Bad Request';
      case 401:
        return '✗ Unauthorized';
      case 403:
        return '✗ Forbidden';
      case 404:
        return '✗ Not Found';
      case 500:
        return '✗ Internal Server Error';
      case 502:
        return '✗ Bad Gateway';
      case 503:
        return '✗ Service Unavailable';
      default:
        return '';
    }
  }

  static void _printPrettyJson(dynamic data) {
    try {
      String jsonString;
      if (data is String) {
        jsonString = data;
      } else {
        jsonString = data.toString();
      }
      
      // Split long lines
      if (jsonString.length > 100) {
        final lines = _splitLongString(jsonString, 90);
        for (final line in lines) {
          debugPrint('$_cyan║$_reset   $line');
        }
      } else {
        debugPrint('$_cyan║$_reset   $jsonString');
      }
    } catch (e) {
      debugPrint('$_cyan║$_reset   $data');
    }
  }

  static List<String> _splitLongString(String text, int maxLength) {
    final List<String> result = [];
    int start = 0;
    
    while (start < text.length) {
      int end = start + maxLength;
      if (end > text.length) {
        end = text.length;
      }
      result.add(text.substring(start, end));
      start = end;
    }
    
    return result;
  }
}

class ApiLoggerInterceptor extends Interceptor {
  final Map<String, int> _requestStartTimes = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final key = '${options.method}_${options.path}_${DateTime.now().millisecondsSinceEpoch}';
    _requestStartTimes[key] = DateTime.now().millisecondsSinceEpoch;
    options.extra['_log_key'] = key;
    
    ApiLogger.logRequest(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final key = response.requestOptions.extra['_log_key'] as String?;
    final startTime = key != null ? _requestStartTimes[key] : null;
    final duration = startTime != null 
        ? DateTime.now().millisecondsSinceEpoch - startTime 
        : 0;
    
    if (key != null) {
      _requestStartTimes.remove(key);
    }
    
    ApiLogger.logResponse(response, duration);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final key = err.requestOptions.extra['_log_key'] as String?;
    final startTime = key != null ? _requestStartTimes[key] : null;
    final duration = startTime != null 
        ? DateTime.now().millisecondsSinceEpoch - startTime 
        : 0;
    
    if (key != null) {
      _requestStartTimes.remove(key);
    }
    
    ApiLogger.logError(err, duration);
    super.onError(err, handler);
  }
}

