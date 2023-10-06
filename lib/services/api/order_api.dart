import 'package:dio/dio.dart';
import 'package:my_shop/services/models/order_item_response.dart';
import 'package:retrofit/retrofit.dart';
part 'order_api.g.dart';

@RestApi(baseUrl: 'https://myshop-f49b2-default-rtdb.firebaseio.com')
abstract class OrderApi {
  factory OrderApi(Dio dio) = _OrderApi;

  @GET('/orders/{id}.json')
  Future<OrderItemResponse?> getOrder(
    @Path('id') String id,
    @Query('auth') String token,
  );

  @POST('/orders/{id}.json')
  Future<void> addOrder(
    @Path('id') String id,
    @Query('auth') String token,
    @Body() Map<String, dynamic> body,
  );
}
