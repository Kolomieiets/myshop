
import 'package:dio/dio.dart';
import 'package:my_shop/services/api/authentication_api.dart';
import 'package:my_shop/services/models/authentication_response.dart';

class AuthenticationRepository {
  late final Dio _dio;

  AuthenticationRepository() {
    _dio = Dio();
  }

  Future<Map<String, dynamic>> authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    late final Map<String, dynamic> responseData;
    try {
      final AuthenticationResponse response =
          await AuthenticationApi(_dio).authenticate(urlSegment, {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });

      responseData = response.response;
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
