
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: items.isEmpty
          ? _emptyCart(context)
          : LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 900;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 50 : 16,
                    vertical: 20,
                  ),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _cartItems(
                                context,
                                items,
                              ),
                            ),
                            const SizedBox(width: 25),
                            SizedBox(
                              width: 350,
                              child: _orderSummary(
                                context,
                                cart,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _cartItems(
                              context,
                              items,
                            ),
                            const SizedBox(height: 20),
                            _orderSummary(
                              context,
                              cart,
                            ),
                          ],
                        ),
                );
              },
            ),
    );
  }

  // =========================================================
  // EMPTY CART
  // =========================================================

  Widget _emptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 70,
                color: Color(0xFF2E7D5B),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Add products to your cart and they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
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
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Start Shopping'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // CART ITEMS
  // =========================================================

  Widget _cartItems(
    BuildContext context,
    List<CartItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Shopping Cart',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${items.length} ${items.length == 1 ? 'item' : 'items'}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        ...items.map(
          (item) => _cartItemCard(
            context,
            item,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // PRODUCT CARD
  // =========================================================

  Widget _cartItemCard(
    BuildContext context,
    CartItem item,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.product.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey.shade100,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 35,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 15),

          // DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.brand,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      item.product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      item.product.formattedOriginalPrice,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration:
                            TextDecoration.lineThrough,
                      ),
                    ),

                    const SizedBox(width: 8),

                    if (item.product.discountPercentage > 0)
                      Text(
                        '${item.product.discountPercentage}% OFF',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // QUANTITY
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          _quantityButton(
                            context,
                            Icons.remove,
                            () {
                              context
                                  .read<CartProvider>()
                                  .decrementQuantity(
                                    item.product.id,
                                  );
                            },
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          _quantityButton(
                            context,
                            Icons.add,
                            () {
                              context
                                  .read<CartProvider>()
                                  .incrementQuantity(
                                    item.product.id,
                                  );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 15),

                    TextButton.icon(
                      onPressed: () {
                        context
                            .read<CartProvider>()
                            .removeItem(
                              item.product.id,
                            );
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                      ),
                      label: const Text('Remove'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ITEM TOTAL
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Text(
              '₹${item.total.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // QUANTITY BUTTON
  // =========================================================

  Widget _quantityButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Icon(
          icon,
          size: 18,
        ),
      ),
    );
  }

  // =========================================================
  // ORDER SUMMARY
  // =========================================================

  Widget _orderSummary(
    BuildContext context,
    CartProvider cart,
  ) {
    const double deliveryFee = 0;

    final subtotal = cart.totalPrice;
    final discount = 0.0;
    final total = subtotal + deliveryFee - discount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          _summaryRow(
            'Subtotal',
            '₹${subtotal.toStringAsFixed(0)}',
          ),

          const SizedBox(height: 12),

          _summaryRow(
            'Delivery',
            deliveryFee == 0
                ? 'FREE'
                : '₹${deliveryFee.toStringAsFixed(0)}',
            valueColor: Colors.green,
          ),

          const SizedBox(height: 12),

          _summaryRow(
            'Discount',
            discount == 0
                ? '₹0'
                : '-₹${discount.toStringAsFixed(0)}',
            valueColor: Colors.green,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Divider(),
          ),

          _summaryRow(
            'Total',
            '₹${total.toStringAsFixed(0)}',
            bold: true,
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/checkout',
                );
              },
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 19,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 15,
                color: Colors.grey,
              ),
              SizedBox(width: 5),
              Text(
                'Secure checkout',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SUMMARY ROW
  // =========================================================

  Widget _summaryRow(
    String title,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: bold ? 16 : 14,
            fontWeight:
                bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 18 : 14,
            fontWeight:
                bold ? FontWeight.bold : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
