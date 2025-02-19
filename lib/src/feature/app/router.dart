import 'package:app_core/app_core.dart';
import 'package:expenses_tracker/src/feature/app/routes.dart';
import 'package:expenses_tracker/src/feature/categories/widget/screen/select_category_screen.dart';
import 'package:expenses_tracker/src/feature/categories/widget/screen/upsert_category_screen.dart';
import 'package:expenses_tracker/src/feature/dashboard/widget/dashboard_screen.dart';
import 'package:expenses_tracker/src/feature/transactions/widget/screens/transaction_detailed_history_screen.dart';
import 'package:expenses_tracker/src/feature/transactions/widget/screens/upsert_transaction_screen.dart';
import 'package:expenses_tracker/src/shared/page/multi_dialog_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_resizable/navigator_resizable.dart';

class AppGoRouter implements AppRouter {
  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: Routes.dashboard.path,
        name: Routes.dashboard.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: const DashboardScreen(),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: Routes.history.path,
        name: Routes.history.name,
        pageBuilder: (context, state) => CupertinoPage(
          child: TransactionDetailedHistoryScreen(),
          key: state.pageKey,
        ),
      ),
      ShellRoute(
        pageBuilder: (context, state, child) => MultiPageDialogPage(
          key: state.pageKey,
          navigator: child,
        ),
        routes: [
          GoRoute(
            path: Routes.createCategory.path,
            name: Routes.createCategory.name,
            pageBuilder: (context, state) => ResizableMaterialPage(
              key: state.pageKey,
              child: UpsertCategoryScreen(),
            ),
          ),
          GoRoute(
            path: Routes.selectCategory.path,
            name: Routes.selectCategory.name,
            pageBuilder: (context, state) => ResizableMaterialPage(
              key: state.pageKey,
              child: SelectCategoryScreen(),
            ),
          ),
          GoRoute(
            path: Routes.updateCategory.path,
            name: Routes.updateCategory.name,
            pageBuilder: (context, state) => ResizableMaterialPage(
              key: state.pageKey,
              child: UpsertCategoryScreen(
                uuid: state.pathParameters['id'],
              ),
            ),
          ),
          GoRoute(
            path: Routes.createTransaction.path,
            name: Routes.createTransaction.name,
            pageBuilder: (context, state) => ResizableMaterialPage(
              key: state.pageKey,
              child: UpsertTransactionScreen(),
            ),
          ),
          GoRoute(
            path: Routes.updateTransaction.path,
            name: Routes.updateTransaction.name,
            pageBuilder: (context, state) => ResizableMaterialPage(
              key: state.pageKey,
              child: UpsertTransactionScreen(
                uuid: state.pathParameters['id'],
              ),
            ),
          ),
        ],
      ),
    ],
  );

  @override
  RouterConfig<Object> toRouter() => _router;
}
