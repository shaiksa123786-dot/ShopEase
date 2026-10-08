import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../providers/auth_provider.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primary = Color(0xFF2E7D5B);
  static const Color lightGreen = Color(0xFFE8F5E9);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 25,
        title: const Text(
          'ShopEase',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          // HOME
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: const Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
          ),

          // PRODUCTS
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/products');
            },
            child: const Text(
              'Products',
              style: TextStyle(color: Colors.white),
            ),
          ),

          // WISHLIST ❤️
          IconButton(
            tooltip: 'Wishlist',
            icon: const Icon(
              Icons.favorite_border,
              size: 25,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/wishlist');
            },
          ),
        IconButton(
  tooltip: 'Profile',
  icon: const Icon(
    Icons.person_outline,
    size: 25,
  ),
  onPressed: () {
    final auth = context.read<AuthProvider>();

    if (auth.isLoggedIn) {
      Navigator.pushNamed(context, '/profile');
    } else {
      Navigator.pushNamed(context, '/login');
    }
  },
),

          // CART 🛒
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),

              if (cart.itemCount > 0)
                Positioned(
                  right: 4,
                  top: 8,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.itemCount}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 20),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _heroSection(context),
            _categorySection(context),
            _offerBanner(context),
            _featuredProducts(context),
            _benefitsSection(),
            _footer(),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HERO
  // =========================================================

  Widget _heroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 60,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE8F5E9),
            Color(0xFFF6F8F6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1150,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final mobile = constraints.maxWidth < 700;

              if (mobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _heroText(context),
                    const SizedBox(height: 30),
                    _heroShoppingCard(),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: _heroText(context),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: _heroShoppingCard(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _heroText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 18,
              ),
              SizedBox(width: 5),
              Text(
                'New deals every day',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Shop Smart.\nLive Better.',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            height: 1.05,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'Discover amazing products, great prices,\nand everything you need in one place.',
          style: TextStyle(
            fontSize: 17,
            color: Colors.black54,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 28),

        Row(
          children: [
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
              label: const Text('Shop Now'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 15,
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/products',
                );
              },
              child: const Text('Explore Products'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroShoppingCard() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFCDE8D8),
            Color(0xFFE8F5E9),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 25,
            right: 25,
            child: _floatingCircle(
              Icons.favorite,
              Colors.redAccent,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 25,
            child: _floatingCircle(
              Icons.star,
              Colors.orange,
            ),
          ),
          const Center(
            child: Icon(
              Icons.shopping_bag_rounded,
              size: 130,
              color: primary,
            ),
          ),
          Positioned(
            bottom: 22,
            right: 25,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Best Deals ✨',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingCircle(
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  // =========================================================
  // CATEGORIES
  // =========================================================

  Widget _categorySection(BuildContext context) {
    final categories = [
      {
        'name': 'Electronics',
        'icon': Icons.devices_outlined,
      },
      {
        'name': 'Fashion',
        'icon': Icons.checkroom_outlined,
      },
      {
        'name': 'Jewellery',
        'icon': Icons.diamond_outlined,
      },
      {
        'name': 'Home & Living',
        'icon': Icons.home_outlined,
      },
      {
        'name': 'Beauty',
        'icon': Icons.face_outlined,
      },
      {
        'name': 'Footwear',
        'icon': Icons.shopping_bag_outlined,
      },
      {
        'name': 'Kitchen',
        'icon': Icons.kitchen_outlined,
      },
      {
        'name': 'Gifts',
        'icon': Icons.card_giftcard_outlined,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 45,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1150,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeading(
                'Shop by Category',
                'Find everything you need',
              ),

              const SizedBox(height: 25),

              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  int columns;

                  if (width < 500) {
                    columns = 2;
                  } else if (width < 800) {
                    columns = 4;
                  } else {
                    columns = 8;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/products',
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(14),
                                decoration:
                                    const BoxDecoration(
                                  color: lightGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  category['icon'] as IconData,
                                  color: primary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                category['name'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // OFFER BANNER
  // =========================================================

  Widget _offerBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1150,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 25,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2E7D5B),
                  Color(0xFF4CA879),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final mobile = constraints.maxWidth < 600;

                return mobile
                    ? Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          _offerText(),
                          const SizedBox(height: 15),
                          _offerButton(context),
                        ],
                      )
                    : Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          _offerText(),
                          _offerButton(context),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _offerText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🔥 Special Shopping Deals',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Discover amazing products at special prices.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _offerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/products',
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: primary,
      ),
      child: const Text(
        'View Deals',
      ),
    );
  }

  // =========================================================
  // FEATURED PRODUCTS
  // =========================================================

  Widget _featuredProducts(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 50,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1150,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeading(
                'Featured Products',
                'Popular picks just for you',
              ),

              const SizedBox(height: 25),

              LayoutBuilder(
                builder: (context, constraints) {
                  int columns;

                  if (constraints.maxWidth < 500) {
                    columns = 2;
                  } else if (constraints.maxWidth < 800) {
                    columns = 3;
                  } else if (constraints.maxWidth < 1050) {
                    columns = 4;
                  } else {
                    columns = 5;
                  }

                  final products =
                      sampleProducts.take(10).toList();

                  return GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
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

              const SizedBox(height: 30),

              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/products',
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                  ),
                  label: const Text(
                    'View All Products',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // BENEFITS
  // =========================================================

  Widget _benefitsSection() {
    final benefits = [
      {
        'icon': Icons.local_shipping_outlined,
        'title': 'Fast Delivery',
        'text': 'Quick and reliable delivery',
      },
      {
        'icon': Icons.verified_outlined,
        'title': 'Quality Products',
        'text': 'Products you can trust',
      },
      {
        'icon': Icons.lock_outline,
        'title': 'Secure Payment',
        'text': 'Safe and secure checkout',
      },
      {
        'icon': Icons.support_agent_outlined,
        'title': '24/7 Support',
        'text': 'We are here to help',
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 40,
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final mobile = constraints.maxWidth < 700;

              return Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 30,
                runSpacing: 30,
                children: benefits.map((benefit) {
                  return SizedBox(
                    width: mobile
                        ? constraints.maxWidth * 0.42
                        : 220,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            color: lightGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            benefit['icon'] as IconData,
                            color: primary,
                            size: 27,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          benefit['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          benefit['text'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SECTION HEADING
  // =========================================================

  Widget _sectionHeading(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // FOOTER
  // =========================================================

  Widget _footer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 45,
      ),
      color: const Color(0xFF173D2D),
      child: const Column(
        children: [
          Icon(
            Icons.shopping_bag_rounded,
            color: Colors.white,
            size: 38,
          ),
          SizedBox(height: 12),
          Text(
            'ShopEase',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Shop smart. Live better.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 20),
          Divider(
            color: Colors.white24,
          ),
          SizedBox(height: 15),
          Text(
            '© 2026 ShopEase. All rights reserved.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}