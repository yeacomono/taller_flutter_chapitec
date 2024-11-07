import 'dart:developer';
import 'package:dio/dio.dart';

class APIClient {
  String url;
  var _dio = Dio();

  APIClient({required this.url}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: url, // API URL definido aquí
        receiveTimeout: const Duration(seconds: 4),
        headers: {'product_id': 'KMF'},
        validateStatus: (status) {
          // Considera como éxito los códigos de estado entre 200 y 500
          return status != null && status >= 200 && status <= 500;
        },
      ),
    );
  }

  Map<String, dynamic> _getDefaultParameters(
      {required Map<String, dynamic> formData}) {
    var newFormData = {...formData};
    return newFormData;
  }

  void _logRequest(String method, String endpoint, Map<String, dynamic>? data,
      Map<String, dynamic>? headers, Map<String, dynamic>? queryparameters) {
    log("✅======================= $method Request =======================✅");
    log("URL: ${_dio.options.baseUrl + endpoint}");
    log("Headers: $headers");
    log("Query Params: $queryparameters");
    log("Body: ${_getDefaultParameters(formData: data ?? {})}");
    log("✅===========================================================✅");
  }

  void _logResponse(String method, Response response, String endpoint) {
    log("✅======================= $method Response =======================✅");
    log("URL: ${_dio.options.baseUrl + endpoint}");
    log("Status Code: ${response.statusCode}");
    log("Response Data: ${response.data}");
    log("✅===========================================================✅");
  }

  void _logError(String method, dynamic e, String endpoint) {
    log("❌======================= $method Error ======================= ❌");
    log("URL: ${_dio.options.baseUrl + endpoint}");
    log("Error: $e");
    log("❌=========================================================== ❌");
  }

  Future<Response?> _handleResponse(
      Future<Response> futureResponse, String endpoint, String method) async {
    try {
      final response = await futureResponse;

      // Manejo de respuestas con códigos de error
      if (response.statusCode != 200) {
        log("⚠️======================= $method Error Code: ${response.statusCode} ======================= ⚠️");
        log("URL: ${_dio.options.baseUrl + endpoint}");
        log("Response Data: ${response.data}");
        log("Status Code: ${response.statusCode}");
        log("Status Message: ${response.statusMessage}");
        return response; // Devuelve el response para manejar el JSON en caso de error
      }

      // Log de respuesta exitosa
      _logResponse(method, response, endpoint);
      return response;
    } catch (e) {
      _logError(method, e, endpoint);
      rethrow; // Propaga el error
    }
  }

  Future<Response?> post(
    String endpoint,
    Map<String, dynamic>? data, {
    Map<String, dynamic>? queryparameters,
    Map<String, dynamic>? headers,
  }) async {
    _logRequest("POST", endpoint, data, headers, queryparameters);

    return _handleResponse(
      _dio.post(
        endpoint,
        data: _getDefaultParameters(formData: data ?? {}),
        queryParameters: queryparameters,
        options: Options(headers: headers),
      ),
      endpoint,
      "POST",
    );
  }

  Future<Response?> get(
    String endpoint, {
    Map<String, dynamic>? queryparameters,
    Map<String, dynamic>? headers,
  }) async {
    _logRequest("GET", endpoint, null, headers, queryparameters);

    return _handleResponse(
      _dio.get(
        endpoint,
        queryParameters: queryparameters,
        options: Options(headers: headers),
      ),
      endpoint,
      "GET",
    );
  }

  Future<Response?> put(
    String endpoint,
    Map<String, dynamic>? data, {
    Map<String, dynamic>? queryparameters,
    Map<String, dynamic>? headers,
  }) async {
    _logRequest("PUT", endpoint, data, headers, queryparameters);

    return _handleResponse(
      _dio.put(
        endpoint,
        data: _getDefaultParameters(formData: data ?? {}),
        queryParameters: queryparameters,
        options: Options(headers: headers),
      ),
      endpoint,
      "PUT",
    );
  }

  Future<Response?> delete(
    String endpoint, {
    Map<String, dynamic>? queryparameters,
    Map<String, dynamic>? headers,
  }) async {
    _logRequest("DELETE", endpoint, null, headers, queryparameters);

    return _handleResponse(
      _dio.delete(
        endpoint,
        queryParameters: queryparameters,
        options: Options(headers: headers),
      ),
      endpoint,
      "DELETE",
    );
  }

  Future<Response?> patch(
    String endpoint,
    Map<String, dynamic>? data, {
    Map<String, dynamic>? queryparameters,
    Map<String, dynamic>? headers,
  }) async {
    _logRequest("PATCH", endpoint, data, headers, queryparameters);

    return _handleResponse(
      _dio.patch(
        endpoint,
        data: _getDefaultParameters(formData: data ?? {}),
        queryParameters: queryparameters,
        options: Options(headers: headers),
      ),
      endpoint,
      "PATCH",
    );
  }
}

class Result<T> {
  final T? data;
  final String? errorMessage;
  final String? error;
  final bool? success;
  final String? messageId;
  final int? statusCode;
  final bool? itemFound;

  const Result._({
    this.data,
    this.errorMessage,
    this.statusCode,
    this.error,
    this.success,
    this.messageId,
    this.itemFound,
  });

  // Constructor para éxito
  const Result.success(
    T data, {
    int? statusCode,
    bool? itemFound,
  }) : this._(
          data: data,
          itemFound: itemFound,
          statusCode: statusCode,
          success: true,
        );

  // Constructor para fallo
  const Result.failure({
    String? errorMessage,
    int? statusCode,
    String? error,
    String? messageId,
  }) : this._(
          errorMessage: errorMessage,
          statusCode: statusCode,
          error: error,
          messageId: messageId,
          success: false
        );

  bool get isSuccess => errorMessage == null;
  bool get isFailure => !isSuccess;

  // Métodos auxiliares
  void ifSuccess(void Function(T data) onSuccess) {
    if (isSuccess && data != null) onSuccess(data!);
  }

  void ifFailure(void Function(String errorMessage) onFailure) {
    if (isFailure) onFailure(errorMessage!);
  }

  Result<U> map<U>(U Function(T data) transform) {
    if (isSuccess && data != null) {
      return Result.success(transform(data as T), statusCode: statusCode);
    } else {
      return Result.failure(
        errorMessage: errorMessage,
        statusCode: statusCode,
      );
    }
  }

  @override
  String toString() {
    return isSuccess
        ? 'Success(data: $data, statusCode: $statusCode)'
        : 'Failure(errorMessage: $errorMessage, statusCode: $statusCode)';
  }
}
