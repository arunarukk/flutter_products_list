import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce_app/model/procucts_model.dart';

class GetProducts {
  final dio = Dio();
  String baseUrl = "https://fakestoreapi.com";
  Future<Either<String, List<Product>>> getProducts() async {
    try {
      final response = await dio.get('$baseUrl/products');
      if (response.statusCode == 200) {
        return Right(
            List<Product>.from(response.data.map((x) => Product.fromJson(x))));
      }
      return Left('error datz 1');
    } catch (e) {
      if (e is DioError) {
        return Left(e.response!.statusCode.toString());
      }
      return const Left('not a dio error');
    }
  }
  // return right([]);
}
