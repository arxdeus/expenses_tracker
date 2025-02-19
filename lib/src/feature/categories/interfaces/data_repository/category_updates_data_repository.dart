import 'package:expenses_tracker/src/feature/categories/interfaces/categories_interfaces.dart';

abstract class CategoryUpdatesDataRepositoryInterface
    implements CategoriesCreateInterface, CategoriesDeleteInterface, CategoryUpdatesStreamInterface {}
