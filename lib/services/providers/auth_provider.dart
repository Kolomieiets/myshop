import 'package:flutter/widgets.dart';
import 'package:my_shop/services/api/api.dart';

import 'package:my_shop/services/api/authentication_repository.dart';

class AuthProvider with ChangeNotifier {
  final Api api = Api();
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  final AuthenticationRepository apiRepository = AuthenticationRepository();

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String? get id => _userId;

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final Map<String, dynamic> responseData = await apiRepository.authenticate(
      email,
      password,
      urlSegment,
    );
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(
          responseData['expiresIn'],
        ),
      ),
    );
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
