import 'package:expenses_tracker/src/feature/categories/interfaces/categories_interfaces.dart';

abstract class CategoriesDataProviderInterface
    implements
        CategoriesCreateInterface,
        CategoriesDeleteInterface,
        CategoriesGetManyInterface,
        CategoriesUpdateInterface,
        CategoriesGetSingleInterface {}
