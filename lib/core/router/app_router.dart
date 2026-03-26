import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/search/search_page.dart';
import '../../presentation/pages/detail/product_detail_page.dart';
import '../../presentation/pages/comparison/comparison_page.dart';
import '../../presentation/pages/favorites/favorites_page.dart';
import '../../presentation/pages/account/account_page.dart';
import '../../presentation/providers/auth_provider.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final authState = ValueNotifier<User?>(ref.read(authNotifierProvider));
  ref.listen<User?>(authNotifierProvider, (_, next) {
    authState.value = next;
  });

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: authState,
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoginRoute = state.matchedLocation == '/login';

      // Favorites requires auth
      if (state.matchedLocation == '/favorites' && !isLoggedIn) {
        return '/login';
      }
      // Already logged in, no need to show login page
      if (isLoginRoute && isLoggedIn) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailPage(productId: id);
        },
      ),
      GoRoute(
        path: '/compare',
        builder: (context, state) => const ComparisonPage(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => const AccountPage(),
      ),
    ],
  );

  ref.onDispose(() {
    authState.dispose();
    router.dispose();
  });

  return router;
}
