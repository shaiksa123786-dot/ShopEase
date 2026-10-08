import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

// EXPERIMENT 7: Form with multiple input fields + validation.
// EXPERIMENT 8: Animation on successful order placement.

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cardController = TextEditingController();

  bool _placingOrder = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _placingOrder = true;
    });

    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    context.read<CartProvider>().clearCart();

    setState(() {
      _placingOrder = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          contentPadding: const EdgeInsets.all(30),
          content: TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0,
              end: 1,
            ),
            duration: const Duration(
              milliseconds: 600,
            ),
            curve: Curves.elasticOut,
            builder: (
              context,
              value,
              child,
            ) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF2E7D5B),
                    size: 65,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Order Placed!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your order has been placed successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).popUntil(
                        (route) => route.isFirst,
                      );
                    },
                    child: const Text(
                      'Continue Shopping',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          final isDesktop =
              constraints.maxWidth >= 900;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 60 : 18,
              vertical: 25,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1100,
                ),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _checkoutForm(),
                          ),
                          const SizedBox(width: 25),
                          SizedBox(
                            width: 340,
                            child: _orderSummary(cart),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _checkoutForm(),
                          const SizedBox(height: 25),
                          _orderSummary(cart),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _checkoutForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.location_on_outlined,
            'Delivery Information',
          ),

          const SizedBox(height: 15),

          _textField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null ||
                  value.trim().length < 3) {
                return 'Enter your full name';
              }
              return null;
            },
          ),

          const SizedBox(height: 14),

          _textField(
            controller: _addressController,
            label: 'Shipping Address',
            hint: 'House no, street, city, state',
            icon: Icons.home_outlined,
            maxLines: 3,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Address is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 14),

          _textField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: '10-digit mobile number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              final digits =
                  value?.replaceAll(
                        RegExp(r'\D'),
                        '',
                      ) ??
                      '';

              if (digits.length != 10) {
                return 'Enter a valid 10-digit phone number';
              }

              return null;
            },
          ),

          const SizedBox(height: 25),

          _sectionTitle(
            Icons.payment_outlined,
            'Payment Information',
          ),

          const SizedBox(height: 15),

          _textField(
            controller: _cardController,
            label: 'Card Number',
            hint: 'Enter 16-digit card number',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            validator: (value) {
              final digits =
                  value?.replaceAll(
                        RegExp(r'\D'),
                        '',
                      ) ??
                      '';

              if (digits.length != 16) {
                return 'Card number must be 16 digits';
              }

              return null;
            },
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: Color(0xFF2E7D5B),
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Your payment information is securely processed.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2E7D5B),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: _placingOrder
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton.icon(
                    onPressed: _placeOrder,
                    icon: const Icon(
                      Icons.lock_outline,
                    ),
                    label: const Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _sectionTitle(
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2E7D5B),
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _orderSummary(CartProvider cart) {
    final subtotal = cart.totalPrice;
    const delivery = 0.0;
    final total = subtotal + delivery;

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
            CrossAxisAlignment.start,
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
            'Items',
            '${cart.itemCount}',
          ),

          const SizedBox(height: 12),

          _summaryRow(
            'Subtotal',
            '₹${subtotal.toStringAsFixed(0)}',
          ),

          const SizedBox(height: 12),

          _summaryRow(
            'Delivery',
            'FREE',
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

          const Row(
            children: [
              Icon(
                Icons.verified_outlined,
                size: 18,
                color: Color(0xFF2E7D5B),
              ),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Safe and secure shopping',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
            fontWeight: bold
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 18 : 14,
            fontWeight: bold
                ? FontWeight.bold
                : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}