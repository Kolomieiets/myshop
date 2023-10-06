import 'package:dio/dio.dart';
import 'package:my_shop/services/models/product_id.dart';
import 'package:my_shop/services/providers/product.dart';
import 'package:retrofit/retrofit.dart';
part 'product_api.g.dart';

@RestApi(baseUrl: 'https://myshop-f49b2-default-rtdb.firebaseio.com')
abstract class ProductApi {
  factory ProductApi(Dio dio) = _ProductApi;

  @GET('/products.json')
  Future<Map<String, Product>> getProduct(
    @Query('auth') String token,
  );

  @POST('/products.json')
  Future<ProductId> addProduct(
    @Query('auth') String token,
    @Body() Map<String, dynamic> body,
  );

  @PUT('/products/{id}.json')
  Future<void> updateProduct(
    @Path('id') String id,
    @Query('auth') String token,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/products/{id}.json')
  Future<void> deleteProduct(
    @Path('id') String id,
    @Query('auth') String token,
  );

  @PATCH('/products/{id}.json')
  Future<void> toggleFavorite(
    @Path('id') String id,
    @Query('auth') String token,
    @Body() Map<String, dynamic> body,
  );
}
