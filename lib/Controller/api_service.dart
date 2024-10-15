import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
          baseUrl: 'http://10.0.2.2:7228/api/', // Change to your API base URL
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
        ));

  Future<Response> get(String url, {String? id, String? query}) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: {
          'id': id,
          'query': query,
        }..removeWhere((key, value) => value == null),
      );
      return response;
    } catch (e) {
      log(
        'Failed to load data: $e',
        name: 'ApiService',
      );
      throw Exception('Failed to load data: $e');
    }
  }

  Future<Response> post(String url, {String? id, String? query, Map<String, dynamic>? body}) async {
    try {
      log('Posting data to $url');
      final response = await _dio.post(
        url,
        queryParameters: {
          'id': id,
          'query': query,
        }..removeWhere((key, value) => value == null),
        data: body,
      );
      log(response.toString());
      return response;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  Future<Response> put(String url, {String? id, String? query, Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.put(
        url,
        queryParameters: {
          'id': id,
          'query': query,
        }..removeWhere((key, value) => value == null),
        data: body,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update data: $e');
    }
  }

  Future<Response> delete(String url, {String? id, String? query}) async {
    try {
      final response = await _dio.delete(
        url,
        queryParameters: {
          'id': id,
          'query': query,
        }..removeWhere((key, value) => value == null),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  Future<Response> postSingleImage(String url, String path, String key) async {
    try {
      FormData formData = FormData.fromMap({
        key: await MultipartFile.fromFile(path, filename: path.split('/').last), // Use actual file name
      });

      final response = await _dio.post(url, data: formData);
      return response;
    } catch (e) {
      throw Exception('Failed to post image: $e');
    }
  }






Future<Response> postWithImages({
  required String endpoint,
  required Map<String, dynamic> body,
  required Map<String, dynamic>? imagePaths,
}) async {
  try {
    Dio dio = Dio();
    
    // Form data for the request
    FormData formData = FormData();

    // Add body fields to the form data
    body.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    // Add image files to the form data if available
    if (imagePaths != null) {
      for (var entry in imagePaths.entries) {
        var paths = entry.value.split(",");
        for (var path in paths) {
          formData.files.add(MapEntry(
            entry.key,
            await MultipartFile.fromFile(path, filename: path.split('/').last),
          ));
        }
      }
    }

    // Send the request
    Response response = await dio.post(
      'https://localhost:7228/api/$endpoint',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          "Accept": "application/json",

        },
      ),
    );

    return response;

  } catch (e) {
    // Handle the exception and return the error
    return Future.error(e.toString());
  }
}



Future<Response> updateWithImage({
  required String endpoint,
  required String id, // ID of the resource being updated
  required Map<String, dynamic> body,
  Map<String, dynamic>? imagePaths,
}) async {
  try {
    Dio dio = Dio();
    
    // Form data for the update request
    FormData formData = FormData();

    // Add body fields to the form data
    body.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    // Add image files to the form data if available
    if (imagePaths != null) {
      for (var entry in imagePaths.entries) {
        var paths = entry.value.split(",");
        for (var path in paths) {
          formData.files.add(MapEntry(
            entry.key,
            await MultipartFile.fromFile(path, filename: path.split('/').last),
          ));
        }
      }
    }

    // Send the update request
    Response response = await dio.put(
      'https://localhost:7228/api/$endpoint/$id',  // Assuming the ID is in the URL
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    return response;

  } catch (e) {
    // Handle the exception and return the error
    return Future.error(e.toString());
  }
}


}

