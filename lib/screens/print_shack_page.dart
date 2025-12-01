import 'package:flutter/material.dart';
import 'package:union_shop/utils/snackbar_utils.dart';

class PrintShackPage extends StatefulWidget {
  const PrintShackPage({super.key});

  @override
  State<PrintShackPage> createState() => _PrintShackPageState();
}

class _PrintShackPageState extends State<PrintShackPage> {
  String _selectedLines = 'One Line of Text';
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  int _quantity = 1;

  final List<String> _lineOptions = [
    'One Line of Text',
    'Two Lines of Text',
  ];

  @override
  void dispose() {
    _line1Controller.dispose();
    _line2Controller.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Personalisation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        Container(
          width: double.infinity,
          height: 400,
          color: Colors.white,
          child: Image.asset(
            'assets/images/print_shack_hoodie.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade200,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'YOUR\nNAME\nHERE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4d2963),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Thumbnail Images
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildThumbnail('assets/images/personalisation.png'),
              const SizedBox(width: 12),
              _buildThumbnail('assets/images/personalisation_back.png'),
            ],
          ),
        ),

        // Product Details
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personalisation',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '£3.00',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tax included.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // Lines Dropdown
              const Text(
                'Per Line: One Line of Text',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedLines,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items: _lineOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLines = newValue!;
                    // Clear second line when switching to one line
                    if (_selectedLines == 'One Line of Text') {
                      _line2Controller.clear();
                    }
                  });
                },
              ),
              const SizedBox(height: 24),

              // Personalisation Line 1
              const Text(
                'Personalisation Line 1:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _line1Controller,
                maxLength: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  setState(() {}); // Update character count
                },
              ),
              const SizedBox(height: 16),

              // Personalisation Line 2 (conditional)
              if (_selectedLines == 'Two Lines of Text') ...[
                const Text(
                  'Personalisation Line 2:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _line2Controller,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {}); // Update character count
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Quantity
              const Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 20),
                          onPressed: _decrementQuantity,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: _incrementQuantity,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    SnackbarUtils.showAddedToCart(
                      context,
                      'Personalisation',
                      onViewCart: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4d2963),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'ADD TO CART',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Pricing Info
              Text(
                '£3 for one line of text! £5 for two!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'One line of text is 10 characters.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),

              // Warning Text
              Text(
                'Please ensure all spellings are correct before submitting your purchase as we will print your item with the exact wording you provide. We will not be responsible for any incorrect spellings printed onto your garment. Personalised items do not qualify for refunds.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Images
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 500,
                  color: Colors.white,
                  child: Image.asset(
                    'assets/images/print_shack_hoodie.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 100, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'YOUR\nNAME\nHERE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4d2963),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildThumbnail('assets/images/print_shack_hoodie.png'),
                    const SizedBox(width: 12),
                    _buildThumbnail('assets/images/print_shack_hoodie.png'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 60),

          // Right side - Product Details
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personalisation',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '£3.00',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tax included.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),

                // Lines Dropdown
                const Text(
                  'Per Line: One Line of Text',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedLines,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: _lineOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLines = newValue!;
                      if (_selectedLines == 'One Line of Text') {
                        _line2Controller.clear();
                      }
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Personalisation Line 1
                const Text(
                  'Personalisation Line 1:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _line1Controller,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),

                // Personalisation Line 2 (conditional)
                if (_selectedLines == 'Two Lines of Text') ...[
                  const Text(
                    'Personalisation Line 2:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _line2Controller,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Quantity
                const Text(
                  'Quantity',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20),
                        onPressed: _decrementQuantity,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: _incrementQuantity,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      SnackbarUtils.showAddedToCart(
                        context,
                        'Personalisation',
                        onViewCart: () {
                          Navigator.pushNamed(context, '/cart');
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4d2963),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'ADD TO CART',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Pricing Info
                Text(
                  '£3 for one line of text! £5 for two!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'One line of text is 10 characters.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 24),

                // Warning Text
                Text(
                  'Please ensure all spellings are correct before submitting your purchase as we will print your item with the exact wording you provide. We will not be responsible for any incorrect spellings printed onto your garment. Personalised items do not qualify for refunds.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(String imagePath) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: Icon(Icons.image, color: Colors.grey.shade400),
          );
        },
      ),
    );
  }
}
