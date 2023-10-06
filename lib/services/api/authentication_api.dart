import 'package:dio/dio.dart';
import 'package:my_shop/services/models/authentication_response.dart';
import 'package:retrofit/retrofit.dart';

part 'authentication_api.g.dart';

@RestApi(baseUrl: 'https://identitytoolkit.googleapis.com')
abstract class AuthenticationApi {
  factory AuthenticationApi(Dio dio) = _AuthenticationApi;

  @POST('/v1/accounts:{urlSegment}?key=AIzaSyAU70q6bu-ds-UdfOtTcV_p91jRNnhjWik')
  Future<AuthenticationResponse> authenticate(
    @Path() String urlSegment,
    @Body() Map<String, dynamic> body,
  );
}
