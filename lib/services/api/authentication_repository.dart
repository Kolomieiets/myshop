import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:my_shop/services/api/api.dart';

class AuthenticationRepository {
  late final Api _api;

  AuthenticationRepository() {
    _api = Api();
  }

  Future<Map<String, dynamic>> authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    late final Map<String, dynamic> responseData;
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAU70q6bu-ds-UdfOtTcV_p91jRNnhjWik';
    try {
      final response = await _api.post(
        url,
        data: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      responseData = response.data;
      if (responseData['error'] != null) {
        throw DioException(requestOptions: responseData['error']['message']);
      }
    } catch (error) {
      rethrow;
    }
    responseData.addAll({
      'idToken': responseData['idToken'],
      'localId': responseData['localId'],
      'expiresIn': responseData['expiresIn'],
    });
    return responseData;
  }
}
