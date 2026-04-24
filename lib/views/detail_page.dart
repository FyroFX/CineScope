import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/favorites_provider.dart';
import '../services/api_service.dart';

class DetailPage extends StatelessWidget {
  final Movie movie;

  const DetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final posterUrl = movie.posterPath != null
        ? '${ApiService.imageBaseUrl}${movie.posterPath}'
        : null;
    final backdropUrl = movie.backdropPath != null
        ? '${ApiService.backdropBaseUrl}${movie.backdropPath}'
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Backdrop App Bar ────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF0D0D0D),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              Consumer<FavoritesProvider>(
                builder: (context, favProv, _) {
                  final isFav = favProv.isFavorite(movie.id);
                  return IconButton(
                    icon: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFav ? const Color(0xFFE50914) : Colors.white,
                    ),
                    onPressed: () => favProv.toggleFavorite(movie),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (backdropUrl != null)
                    CachedNetworkImage(
                      imageUrl: backdropUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: const Color(0xFF1A1A1A)),
                      errorWidget: (_, __, ___) =>
                          Container(color: const Color(0xFF1A1A1A)),
                    )
                  else
                    Container(color: const Color(0xFF1A1A1A)),
                  // Gradient overlay blending into background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.3, 1.0],
                        colors: [Colors.transparent, Color(0xFF0D0D0D)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Movie Details ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster + meta row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      if (posterUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: posterUrl,
                            width: 115,
                            height: 172,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(width: 16),

                      // Meta
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Rating
                            _MetaRow(
                              icon: Icons.star_rounded,
                              iconColor: const Color(0xFFFFD700),
                              text:
                                  '${movie.voteAverage.toStringAsFixed(1)} / 10',
                            ),
                            const SizedBox(height: 8),

                            // Release date
                            if (movie.releaseDate.isNotEmpty)
                              _MetaRow(
                                icon: Icons.calendar_month_rounded,
                                iconColor: Colors.grey,
                                text: movie.releaseDate,
                              ),
                            const SizedBox(height: 8),

                            // Rating bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: movie.voteAverage / 10,
                                backgroundColor: const Color(0xFF2A2A2A),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFE50914),
                                ),
                                minHeight: 6,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'User Score',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Overview
                  const Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.overview.isNotEmpty
                        ? movie.overview
                        : 'No overview available for this title.',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 15,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _MetaRow({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}
