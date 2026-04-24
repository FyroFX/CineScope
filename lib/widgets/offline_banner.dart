import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/movie_provider.dart';

/// A thin banner shown at the top of the screen when the app is in offline mode,
/// indicating that cached data is being displayed.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, _) {
        if (!provider.isOffline) return const SizedBox.shrink();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          color: const Color(0xFF2C2000),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                color: Color(0xFFFFB300),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You\'re offline — showing last cached data',
                  style: TextStyle(
                    color: Colors.orange[300],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
