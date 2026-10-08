import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist_provider.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();

    final products = wishlist.wishlistIds
        .map((id) {
          try {
            return wishlist.getProduct(id);
          } catch (_) {
            return null;
          }
        })
        .whereType<dynamic>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: products.isEmpty
          ? _emptyWishlist(context)
          : LayoutBuilder(
              builder: (context, constraints) {
                int columns;

                if (constraints.maxWidth < 600) {
                  columns = 2;
                } else if (constraints.maxWidth < 900) {
                  columns = 3;
                } else if (constraints.maxWidth < 1200) {
                  columns = 4;
                } else {
                  columns = 5;
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: products.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.62,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: product,
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _emptyWishlist(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 70,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Wishlist is Empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Save your favorite products here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/products',
                );
              },
              icon: const Icon(
                Icons.shopping_bag_outlined,
              ),
              label: const Text('Explore Products'),
            ),
          ],
        ),
      ),
    );
  }
}