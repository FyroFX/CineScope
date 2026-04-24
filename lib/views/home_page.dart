import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/movie_provider.dart';
import '../../../widgets/movie_card.dart';
import '../../../widgets/shimmer_card.dart';
import '../../../widgets/error_state_widget.dart';
import '../../../widgets/offline_banner.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Trigger initial data fetch after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchMovies();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryFilter(),
            const OfflineBanner(),
            const SizedBox(height: 8),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CineScope 🎬',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Discover great films',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Search Bar ──────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        style: const TextStyle(color: Colors.white),
        onChanged: (value) {
          if (value.trim().isEmpty) {
            context.read<MovieProvider>().clearSearch();
          } else {
            context.read<MovieProvider>().searchMovies(value);
          }
          setState(() {}); // Refresh suffix icon
        },
        decoration: InputDecoration(
          hintText: 'Search movies...',
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    context.read<MovieProvider>().clearSearch();
                    _searchFocus.unfocus();
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: const Color(0xFF1A1A1A),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE50914), width: 1.5),
          ),
        ),
      ),
    );
  }

  // ─── Category Filter Chips ───────────────────────────────────────────────

  Widget _buildCategoryFilter() {
    return Consumer<MovieProvider>(
      builder: (context, provider, _) {
        if (provider.isSearching) return const SizedBox.shrink();

        return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = provider.categories[index];
              final isSelected = provider.selectedCategory == cat['key'];

              return _CategoryChip(
                category: cat,
                isSelected: isSelected,
                onTap: () {
                  _searchController.clear();
                  provider.fetchMovies(category: cat['key']);
                },
              );
            },
          ),
        );
      },
    );
  }

  // ─── Body ─────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    return Consumer<MovieProvider>(
      builder: (context, provider, _) {
        // Loading state — show shimmer grid
        if (provider.status == AppStatus.loading) {
          return _buildShimmerGrid();
        }

        // Error state — show friendly UI
        if (provider.status == AppStatus.error) {
          return ErrorStateWidget(
            message: provider.errorMessage,
            onRetry: () => provider.fetchMovies(),
          );
        }

        // Empty results
        if (provider.movies.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎭', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 12),
                Text(
                  provider.isSearching
                      ? 'No movies found for that search.'
                      : 'No movies available.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 15),
                ),
              ],
            ),
          );
        }

        // Movie grid
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.62,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: provider.movies.length,
          itemBuilder: (context, index) {
            final movie = provider.movies[index];
            return MovieCard(
              movie: movie,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPage(movie: movie),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 8,
      itemBuilder: (_, __) => const ShimmerCard(),
    );
  }
}

class _CategoryChip extends StatefulWidget {
  final Map<String, String> category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFFE50914)
                : (_isHovered
                    ? const Color(0xFF333333)
                    : const Color(0xFF1A1A1A)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.category['label']!,
            style: TextStyle(
              color: widget.isSelected ? Colors.white : Colors.grey[400],
              fontWeight:
                  widget.isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
