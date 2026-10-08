import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/product.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/auth_provider.dart';
import 'theme/app_theme.dart';

import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const ShopEaseApp());
}

class ShopEaseApp extends StatelessWidget {
  const ShopEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
     providers: [
  ChangeNotifierProvider(
    create: (_) => CartProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => WishlistProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => AuthProvider(),
  ),
],
      child: MaterialApp(
        title: 'ShopEase',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,

        initialRoute: '/',

        routes: {
          // Main pages
          '/': (context) => const HomeScreen(),
          '/products': (context) => const ProductsScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/wishlist': (context) => const WishlistScreen(),

          // Account pages
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/profile': (context) => const ProfileScreen(),
        },

        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            final product = settings.arguments as Product;

            return MaterialPageRoute(
              builder: (context) {
                return ProductDetailScreen(
                  product: product,
                );
              },
            );
          }

          return null;
        },
      ),
    );
  }
}