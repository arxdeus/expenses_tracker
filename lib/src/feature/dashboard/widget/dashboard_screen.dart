import 'package:expenses_tracker/src/feature/balance/widget/balance_header.dart';
import 'package:expenses_tracker/src/feature/categories/widget/category_grid.dart';
import 'package:expenses_tracker/src/feature/dashboard/widget/recent_transactions_block.dart';
import 'package:flutter/material.dart';

/// {@template dashboard_screen}
/// DashboardScreen widget.
/// {@endtemplate}
class DashboardScreen extends StatefulWidget {
  /// {@macro dashboard_screen}
  const DashboardScreen({
    super.key, // ignore: unused_element
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

/// State for widget DashboardScreen.
class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                sliver: DecoratedSliver(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  sliver: SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: BalanceWithGraph(),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                sliver: DecoratedSliver(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  sliver: SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: RecentTransactionsBlockWidget(),
                    ),
                  ),
                ),
              ),
              CategoryGrid(
                canCreateNew: true,
              ),
            ],
          ),
        ),
      );
}
