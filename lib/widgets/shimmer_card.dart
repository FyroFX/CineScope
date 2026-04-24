import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A reusable shimmer skeleton that mimics the MovieCard shape.
/// Shown in a grid while data is being fetched from the API.
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E1E1E),
      highlightColor: const Color(0xFF2C2C2C),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster placeholder
            Expanded(
              child: Container(color: const Color(0xFF1E1E1E)),
            ),
            // Info placeholder
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: double.infinity,
                    color: const Color(0xFF1E1E1E),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 12,
                    width: 100,
                    color: const Color(0xFF1E1E1E),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 10,
                    width: 40,
                    color: const Color(0xFF1E1E1E),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
