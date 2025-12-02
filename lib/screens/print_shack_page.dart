import 'package:flutter/material.dart';
import 'package:union_shop/widgets/navbar.dart';
import 'package:union_shop/widgets/footer_widget.dart';

class PrintShackPage extends StatelessWidget {
  const PrintShackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      backgroundColor: Colors.white,
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
                    child: Column(
                      children: [
                        Text(
                          'The Union Print Shack',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isDesktop ? 48 : 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4d2963),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Hero Image Placeholder
                        Container(
                          width: double.infinity,
                          height: isDesktop ? 400 : 300,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  'assets/images/print_shack_hoodie.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.checkroom,
                                        size: 80,
                                        color: Color(0xFF4d2963),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: const Color(0xFF4dd0e1),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.anchor,
                                          size: 60,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'PRINT SHACK',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'FOR ALL YOUR PERSONALISATION NEEDS',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Image.asset(
                                  'assets/images/personalisation_back.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade300,
                                      child: const Center(
                                        child: Text(
                                          'YOUR\\nNAME\\nHERE',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4d2963),
                                          ),
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

                  // Content Sections
                  Container(
                    color: const Color(0xFFF5F5F3),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 80 : 24,
                      vertical: isDesktop ? 60 : 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          title: 'Make It Yours at The Union Print Shack',
                          content:
                              "Want to add a personal touch? We've got you covered with heat-pressed customisation on all our clothing. Swing by the shop - our team's always happy to help you pick the right gear and answer any questions.",
                          isDesktop: isDesktop,
                        ),
                        SizedBox(height: isDesktop ? 48 : 32),
                        _buildSection(
                          title: "Uni Gear or Your Gear - We'll Personalise It",
                          content:
                              "Whether you're repping your university or putting your own spin on a hoodie you already own, we've got you covered. We can personalise official uni-branded clothing and your own items - just bring them in and let's get creative!",
                          isDesktop: isDesktop,
                        ),
                        SizedBox(height: isDesktop ? 48 : 32),
                        _buildSection(
                          title: 'Simple Pricing, No Surprises',
                          content:
                              "Customising your gear won't break the bank - just £3 for one line of text or a small chest logo, and £5 for two lines or a large back logo. Turnaround time is up to three working days, and we'll let you know as soon as it's ready to collect.",
                          isDesktop: isDesktop,
                        ),
                        SizedBox(height: isDesktop ? 48 : 32),
                        _buildSection(
                          title: 'Personalisation Terms & Conditions',
                          content:
                              'We will print your clothing exactly as you have provided it to us, whether online or in person. We are not responsible for any spelling errors. Please ensure your chosen text is clearly displayed in either capitals or lowercase. Refunds are not provided for any personalised items.',
                          isDesktop: isDesktop,
                        ),
                        SizedBox(height: isDesktop ? 48 : 32),
                        _buildSection(
                          title: 'Ready to Make It Yours?',
                          content:
                              "Pop in or get in touch today - let's create something uniquely you with our personalisation service - The Union Print Shack!",
                          isDesktop: isDesktop,
                        ),
                        SizedBox(height: isDesktop ? 60 : 40),

                        // Opening Hours
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Opening Hours',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4d2963),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                '❄️ Winter Break Closure Dates ❄️',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Closing 4pm 19/12/2025',
                                style: TextStyle(fontSize: 14),
                              ),
                              const Text(
                                'Reopening 10am 05/01/2026',
                                style: TextStyle(fontSize: 14),
                              ),
                              const Text(
                                'Last post date: 12pm on 18/12/2025',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                              const Text(
                                '(Term Time)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                'Monday - Friday 10am - 4pm',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                '(Outside of Term Time / Consolidation Weeks)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                'Monday - Friday 10am - 3pm',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                              const Text(
                                'Purchase online 24/7',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Footer
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
            fontSize: isDesktop ? 28 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
