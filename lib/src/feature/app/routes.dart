import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum Routes {
  dashboard('/', 'dashboard'),
  createTransaction('/transaction/create', 'create_transaction'),
  updateTransaction('/transaction/edit/:id', 'update_transaction'),
  createCategory('/category/create', 'create_category'),
  selectCategory('/category/select', 'select_category'),
  updateCategory('/category/edit/:id', 'update_category'),
  history('/history', 'history'),
  ;

  final String path;
  final String name;

  const Routes(this.path, this.name);

  Future<T?> push<T>(
    BuildContext context, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
  }) =>
      context.pushNamed<T>(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      );
}
