// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/movie_provider.dart';
import 'providers/favorites_provider.dart';
import 'views/home_page.dart';
import 'views/search_page.dart';
import 'views/favorites_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final favProvider = FavoritesProvider();
  await favProvider.loadFavorites();
  runApp(CineScopeApp(favoritesProvider: favProvider));
}

class CineScopeApp extends StatelessWidget {
  final FavoritesProvider favoritesProvider;
  const CineScopeApp({super.key, required this.favoritesProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider.value(value: favoritesProvider),
      ],
      child: MaterialApp(
        title: 'CineScope',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE50914),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _pages = [HomePage(), FavoritesPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: IndexedStack(
        index: _currentIndex == 2 ? 1 : 0,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF111111),
        indicatorColor: const Color(0xFF2A0A0A),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const SearchPage()));
            return;
          }
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie, color: Color(0xFFE50914)),
            label: 'Movies',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded, color: Color(0xFFE50914)),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon:
                Icon(Icons.favorite_rounded, color: Color(0xFFE50914)),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
