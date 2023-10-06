

class AuthenticationResponse {
  final Map<String, dynamic> response;

  AuthenticationResponse(this.response);

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newResponse = {};

    json.forEach((key, value) {
      newResponse.addAll({key: value});
    });
    return AuthenticationResponse(newResponse);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    response.forEach((key, value) {
      json.addAll({key: value.toJson()});
    });
    return json;
  }
}
