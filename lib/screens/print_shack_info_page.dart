import 'package:flutter/material.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/widgets/footer_widget.dart';

class PrintShackInfoPage extends StatelessWidget {
  const PrintShackInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F3),
      body: Column(
        children: [
          const Navbar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 80 : 24,
                      vertical: isDesktop ? 80 : 40,
                    ),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(
                          'The Union Print Shack',
                          style: TextStyle(
                            fontSize: isDesktop ? 48 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Hero Image
                        Container(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  'assets/images/print_shack_hoodie.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 300,
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(
                                          Icons.image,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 80 : 24,
                      vertical: isDesktop ? 60 : 40,
                    ),
                    color: Colors.white,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection(
                            title: 'Make It Yours at The Union Print Shack',
                            content:
                                'Want to add a personal touch? We\'ve got you covered with heat-pressed customisation on all our clothing. Swing by the shop - our team\'s always happy to help you pick the right gear and answer any questions.',
                            isDesktop: isDesktop,
                          ),
                          const SizedBox(height: 40),
                          _buildSection(
                            title: 'Uni Gear or Your Gear - We\'ll Personalise It',
                            content:
                                'Whether you\'re repping your university or putting your own spin on a hoodie you already own, we\'ve got you covered. We can personalise official uni-branded clothing and your own items - just bring them in and let\'s get creative!',
                            isDesktop: isDesktop,
                          ),
                          const SizedBox(height: 40),
                          _buildSection(
                            title: 'Simple Pricing, No Surprises',
                            content:
                                'Customisation starts from just £3 - that\'s it! No hidden fees, no complicated pricing structures. Just straightforward, affordable personalisation to make your gear uniquely yours.',
                            isDesktop: isDesktop,
                          ),
                          const SizedBox(height: 40),
                          _buildSection(
                            title: 'Quick Turnaround',
                            content:
                                'Need it fast? Most orders are ready within 24-48 hours. We know you\'re busy, so we work efficiently to get your customised items back to you as quickly as possible.',
                            isDesktop: isDesktop,
                          ),
                          const SizedBox(height: 40),
                          _buildSection(
                            title: 'How It Works',
                            content:
                                '1. Choose your item (from our store or bring your own)\n2. Pick your design or text\n3. We heat-press it on\n4. You walk out looking great!\n\nIt\'s that simple. Pop into the shop and our friendly team will guide you through the whole process.',
                            isDesktop: isDesktop,
                          ),
                          const SizedBox(height: 60),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/print-shack');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4d2963),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 48,
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                'ORDER PERSONALISATION',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const FooterWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required bool isDesktop,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isDesktop ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: TextStyle(
            fontSize: isDesktop ? 16 : 15,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
