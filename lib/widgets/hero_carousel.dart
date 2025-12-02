import 'dart:async';
import 'package:flutter/material.dart';
import 'package:union_shop/constants/app_colors.dart';

class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool _isPaused = false;

  final List<CarouselSlide> _slides = const [
    CarouselSlide(
      title: 'Essential Range - Over 20% OFF!',
      description:
          'Over 20% off our Essential Range. Come and grab yours while stock lasts!',
      buttonText: 'BROWSE COLLECTION',
      backgroundColor: AppColors.primary,
      imageUrl: 'assets/images/essential_hoodie.png',
      route: '/collection/essential-range',
    ),
    CarouselSlide(
      title: 'The Print Shack',
      description:
          'Let\'s create something uniquely you with our personalisation service — From £3 for one line of text!',
      buttonText: 'FIND OUT MORE',
      backgroundColor: AppColors.primary,
      imageUrl: 'assets/images/personalization_banner.png',
      route: '/print-shack',
    ),
    CarouselSlide(
      title: 'Hungry?',
      description: 'We got this 🍕',
      buttonText: 'ORDER DOMINO\'S PIZZA NOW',
      backgroundColor: AppColors.primary,
      imageUrl: 'assets/images/portsmouth_pizza.png',
    ),
    CarouselSlide(
      title: 'What\'s your next move...',
      description: 'Are you with us?',
      buttonText: 'FIND YOUR STUDENT ACCOMMODATION',
      backgroundColor: AppColors.primary,
      imageUrl: 'assets/images/signature_hoodie.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isPaused && mounted) {
        if (_currentPage < _slides.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _goToSlide(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _previousSlide() {
    if (_currentPage > 0) {
      _goToSlide(_currentPage - 1);
    } else {
      _goToSlide(_slides.length - 1);
    }
  }

  void _nextSlide() {
    if (_currentPage < _slides.length - 1) {
      _goToSlide(_currentPage + 1);
    } else {
      _goToSlide(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          // PageView for slides
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return _slides[index];
            },
          ),

          // Navigation arrows
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.chevron_left,
                    color: Colors.white, size: 32),
                onPressed: _previousSlide,
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.chevron_right,
                    color: Colors.white, size: 32),
                onPressed: _nextSlide,
              ),
            ),
          ),

          // Pause button
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                icon: Icon(
                  _isPaused ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _togglePause,
              ),
            ),
          ),

          // Dot indicators
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                return GestureDetector(
                  onTap: () => _goToSlide(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class CarouselSlide extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final Color backgroundColor;
  final String imageUrl;
  final String? route;

  const CarouselSlide({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.backgroundColor,
    required this.imageUrl,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.4),
            BlendMode.darken,
          ),
          onError: (error, stackTrace) {},
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: route != null
                    ? () => Navigator.pushNamed(context, route!)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: backgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
