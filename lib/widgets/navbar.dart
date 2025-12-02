import 'package:flutter/material.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/services/cart_service.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Announcement Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: const Color(0xFF4d2963),
            child: const Text(
              'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Main Navigation
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 16,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/'),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'The UNION',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d2963),
                          fontFamily: 'Brush Script MT',
                        ),
                      );
                    },
                  ),
                ),

                // Desktop Navigation Links
                if (isDesktop) ...[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _NavLink(
                          label: 'Home',
                          onTap: ModalRoute.of(context)?.settings.name == '/'
                              ? null
                              : () => Navigator.pushNamed(context, '/'),
                          isDisabled:
                              ModalRoute.of(context)?.settings.name == '/',
                        ),
                        _NavLink(
                          label: 'Shop',
                          onTap: ModalRoute.of(context)?.settings.name ==
                                  '/collections'
                              ? null
                              : () =>
                                  Navigator.pushNamed(context, '/collections'),
                          isDisabled: ModalRoute.of(context)?.settings.name ==
                              '/collections',
                        ),
                        const _PrintShackDropdown(),
                        _NavLink(
                          label: 'SALE!',
                          onTap:
                              ModalRoute.of(context)?.settings.name == '/sale'
                                  ? null
                                  : () => Navigator.pushNamed(context, '/sale'),
                          isDisabled:
                              ModalRoute.of(context)?.settings.name == '/sale',
                        ),
                        _NavLink(
                          label: 'About',
                          onTap: ModalRoute.of(context)?.settings.name ==
                                  '/about'
                              ? null
                              : () => Navigator.pushNamed(context, '/about'),
                          isDisabled:
                              ModalRoute.of(context)?.settings.name == '/about',
                        ),
                      ],
                    ),
                  ),
                ],

                // Icons (always visible)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, size: 24),
                      onPressed: () {
                        Navigator.pushNamed(context, '/search');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_outline, size: 24),
                      onPressed: () {
                        final authService = AuthService();
                        if (authService.isSignedIn) {
                          Navigator.pushNamed(context, '/account');
                        } else {
                          Navigator.pushNamed(context, '/login');
                        }
                      },
                    ),
                    IconButton(
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.shopping_bag_outlined, size: 24),
                          ListenableBuilder(
                            listenable: CartService(),
                            builder: (context, _) {
                              final itemCount = CartService().itemCount;
                              if (itemCount == 0) {
                                return const SizedBox.shrink();
                              }

                              return Positioned(
                                right: -6,
                                top: -6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4d2963),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    itemCount > 99
                                        ? '99+'
                                        : itemCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/cart'),
                    ),
                    if (!isDesktop)
                      IconButton(
                        icon: const Icon(Icons.menu, size: 24),
                        onPressed: () => _showMobileMenu(context),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Menu',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.topRight,
          child: Material(
            color: Colors.white,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  // Header with announcement bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    color: const Color(0xFF4d2963),
                    child: const Text(
                      'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  // Navigation header with logo and close button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo
                        Image.asset(
                          'assets/images/logo.png',
                          height: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                              'The UNION',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4d2963),
                                fontFamily: 'Brush Script MT',
                              ),
                            );
                          },
                        ),
                        // Icons
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.search, size: 24),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/search');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.person_outline, size: 24),
                              onPressed: () {
                                Navigator.pop(context);
                                final authService = AuthService();
                                if (authService.isSignedIn) {
                                  Navigator.pushNamed(context, '/account');
                                } else {
                                  Navigator.pushNamed(context, '/login');
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.shopping_bag_outlined,
                                  size: 24),
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Shopping cart coming soon!'),
                                  ),
                                );
                              },
                            ),
                            // Close button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.lightBlue.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 24),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Menu Items
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade50,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _MobileMenuItem(
                            label: 'Home',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/');
                            },
                            hasChevron: false,
                          ),
                          const Divider(height: 1),
                          _MobileMenuItem(
                            label: 'Shop',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/collections');
                            },
                            hasChevron: true,
                          ),
                          const Divider(height: 1),
                          _MobileMenuItem(
                            label: 'The Print Shack',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/print-shack');
                            },
                            hasChevron: true,
                          ),
                          const Divider(height: 1),
                          _MobileMenuItem(
                            label: 'SALE!',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/sale');
                            },
                            hasChevron: false,
                          ),
                          const Divider(height: 1),
                          _MobileMenuItem(
                            label: 'About',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/about');
                            },
                            hasChevron: false,
                          ),
                          const Divider(height: 1),
                          _MobileMenuItem(
                            label: 'UPSU.net',
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('External link'),
                                ),
                              );
                            },
                            hasChevron: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _NavLink({
    required this.label,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MouseRegion(
        onEnter:
            widget.isDisabled ? null : (_) => setState(() => _isHovered = true),
        onExit: widget.isDisabled
            ? null
            : (_) => setState(() => _isHovered = false),
        cursor: widget.isDisabled
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.isDisabled ? null : widget.onTap,
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: widget.isDisabled
                  ? Colors.grey
                  : (_isHovered ? const Color(0xFF4d2963) : Colors.black87),
              decoration: _isHovered && !widget.isDisabled
                  ? TextDecoration.underline
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool hasChevron;

  const _MobileMenuItem({
    required this.label,
    required this.onTap,
    this.hasChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            if (hasChevron)
              const Icon(
                Icons.chevron_right,
                color: Colors.black54,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

class _PrintShackDropdown extends StatefulWidget {
  const _PrintShackDropdown();

  @override
  State<_PrintShackDropdown> createState() => _PrintShackDropdownState();
}

class _PrintShackDropdownState extends State<_PrintShackDropdown> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 40),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'The Print Shack',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _isHovering ? const Color(0xFF4d2963) : Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: _isHovering ? const Color(0xFF4d2963) : Colors.black87,
              ),
            ],
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'about',
            child: const Text('About'),
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamed(context, '/about');
              });
            },
          ),
          PopupMenuItem(
            value: 'personalisation',
            child: const Text('Personalisation'),
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamed(context, '/print-shack');
              });
            },
          ),
        ],
      ),
    );
  }
}
