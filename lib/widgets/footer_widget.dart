import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF2c2c2c),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Name
          const Text(
            'UPSU SHOP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'University of Portsmouth Students\' Union',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Quick Links Section
          _buildFooterSection(
            'Quick Links',
            [
              _FooterLink('Home', '/'),
              _FooterLink('About Us', '/about'),
              _FooterLink('Sale', '/sale'),
              _FooterLink('Collections', '/collections'),
            ],
          ),
          const SizedBox(height: 20),

          // Help & Information Section
          _buildFooterSection(
            'Help & Information',
            [
              _FooterLink('Search', '/search'),
              _FooterLink('Contact Us', '/contact'),
              _FooterLink('Terms & Conditions', '/terms'),
              _FooterLink('Privacy Policy', '/privacy'),
            ],
          ),
          const SizedBox(height: 20),

          // Social Media Section
          const Text(
            'Follow Us',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSocialIcon(Icons.facebook, 'Facebook'),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.camera_alt, 'Instagram'),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.play_arrow, 'Twitter'),
            ],
          ),
          const SizedBox(height: 24),

          // Opening Hours
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Opening Hours',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Monday - Friday: 10am - 4pm',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Online: 24/7',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Copyright
          const Divider(color: Colors.grey, thickness: 0.5),
          const SizedBox(height: 16),
          const Text(
            '© 2025 UPSU. All rights reserved.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(String title, List<_FooterLink> links) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...links.map((link) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate for all links
                    if (link.route == '/') {
                      Navigator.pushNamed(context, '/');
                    } else if (link.route == '/about') {
                      Navigator.pushNamed(context, '/about');
                    } else if (link.route == '/collections') {
                      Navigator.pushNamed(context, '/collections');
                    } else if (link.route == '/sale') {
                      Navigator.pushNamed(context, '/sale');
                    } else if (link.route == '/search') {
                      Navigator.pushNamed(context, '/search');
                    }
                  },
                  child: Text(
                    link.title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // Social media links will be handled later
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _FooterLink {
  final String title;
  final String route;

  _FooterLink(this.title, this.route);
}
