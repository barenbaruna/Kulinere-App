import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kulinere/core/theme/app_colors.dart';
import 'package:kulinere/core/utils/debouncer.dart';
import 'package:kulinere/providers/restaurant_search_provider.dart';
import 'package:kulinere/screens/detail/detail_screen.dart';
import 'package:kulinere/screens/home/widgets/restaurant_card.dart';
import 'package:kulinere/states/restaurant_search_state.dart';
import 'package:kulinere/widgets/error_widget.dart';
import 'package:kulinere/widgets/loading_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _debouncer = Debouncer();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debouncer.run(() {
      context.read<RestaurantSearchProvider>().searchRestaurants(query);
    });
  }

  void _clearSearch() {
    _controller.clear();
    context.read<RestaurantSearchProvider>().reset();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Cari restoran...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          onChanged: _onSearchChanged,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
            ),
        ],
      ),
      body: Consumer<RestaurantSearchProvider>(
        builder: (context, provider, child) {
          final state = provider.state;

          if (state is RestaurantSearchNoneState) {
            return _buildEmptyHint(context);
          }

          if (state is RestaurantSearchLoadingState) {
            return const LoadingWidget(message: 'Mencari restoran...');
          }

          if (state is RestaurantSearchErrorState) {
            return AppErrorWidget(
              message: state.error,
              onRetry: () => provider.searchRestaurants(provider.lastQuery),
            );
          }

          if (state is RestaurantSearchLoadedState) {
            if (state.data.isEmpty) {
              return _buildNoResults(context, provider.lastQuery);
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final restaurant = state.data[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        restaurantId: restaurant.id,
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyHint(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: AppColors.gold.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Ketik untuk mencari restoran',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(BuildContext context, String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: AppColors.gold.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ditemukan restoran untuk "$query"',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
