import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class NagpurHeroCarousel extends StatefulWidget {
  final VoidCallback? onExploreTap;

  const NagpurHeroCarousel({super.key, this.onExploreTap});

  @override
  State<NagpurHeroCarousel> createState() => _NagpurHeroCarouselState();
}

class _NagpurHeroCarouselState extends State<NagpurHeroCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.94);
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Zero Mile Heritage Circuit',
      'subtitle': 'Geographical Center of India • 24.5 km Grand Loop',
      'tag': 'ORIGIN SECTOR',
      'tagColor': AppColors.royalBlue,
      'stats': '1,420 Riders • Flag-Off Zone',
      'imageUrl': 'https://images.unsplash.com/photo-1541625602330-2277a4c46182?auto=format&fit=crop&w=1200&q=80',
      'gradient': const [Color(0xFF1E3A8A), Color(0xFF2563EB)],
    },
    {
      'title': 'Deekshabhoomi Sacred Loop',
      'subtitle': 'Architectural Stupa Waypoint • Checkpoint 2',
      'tag': 'MUSTERING ZONE',
      'tagColor': AppColors.royalPurple,
      'stats': 'Hydration Post #1 • First-Aid Base',
      'imageUrl': 'https://images.unsplash.com/photo-1517649763962-0c623266ddc0?auto=format&fit=crop&w=1200&q=80',
      'gradient': const [Color(0xFF4C1D95), Color(0xFF7C3AED)],
    },
    {
      'title': 'Futala Lake Musical Promenade',
      'subtitle': 'Scenic Waterfront Finish Pavilion & Citizen Expo',
      'tag': 'FINISH LINE SPRINT',
      'tagColor': AppColors.royalBlue,
      'stats': 'Podium • Medal Ceremony Area',
      'imageUrl': 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?auto=format&fit=crop&w=1200&q=80',
      'gradient': const [Color(0xFF0F172A), Color(0xFF1D4ED8)],
    },
    {
      'title': 'Wardha Road Metro Flyover',
      'subtitle': 'High-Speed Elevated Green Corridor & Double Decker viaduct',
      'tag': 'VELODROME SECTOR',
      'tagColor': AppColors.royalPurple,
      'stats': 'Police Marshall Escort • 4 Lanes',
      'imageUrl': 'https://images.unsplash.com/photo-1502680390469-be75c86b636f?auto=format&fit=crop&w=1200&q=80',
      'gradient': const [Color(0xFF311042), Color(0xFF6D28D9)],
    },
    {
      'title': 'VNIT Campus & Ambazari Lake',
      'subtitle': 'Collegiate Contingent Hub & Green Woodland Loop',
      'tag': 'COLLEGE HUB',
      'tagColor': AppColors.vibrantEmerald,
      'stats': '38 Contingent Riders Check-in',
      'imageUrl': 'https://images.unsplash.com/photo-1571068316344-75bc76f77890?auto=format&fit=crop&w=1200&q=80',
      'gradient': const [Color(0xFF064E3B), Color(0xFF059669)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _slides.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              final isCurrent = _currentPage == index;

              return AnimatedScale(
                scale: isCurrent ? 1.0 : 0.94,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: (slide['tagColor'] as Color).withValues(alpha: 0.45),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: (slide['tagColor'] as Color).withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // High-res Background Image with graceful fallback
                      Positioned.fill(
                        child: Image.network(
                          slide['imageUrl'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            final gradientColors = slide['gradient'] as List<Color>;
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: AppColors.surfaceCard,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.royalBlue,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Multi-stop Cinematic Gradient Scrim
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.4, 0.85, 1.0],
                              colors: [
                                Colors.black.withValues(alpha: 0.25),
                                Colors.black.withValues(alpha: 0.35),
                                Colors.black.withValues(alpha: 0.85),
                                Colors.black.withValues(alpha: 0.98),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Top Glass Sector Badge
                      Positioned(
                        top: 14,
                        left: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (slide['tagColor'] as Color).withValues(alpha: 0.6),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: slide['tagColor'] as Color,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                slide['tag'] as String,
                                style: TextStyle(
                                  color: slide['tagColor'] as Color,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 9.5,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Top Right Live Badge
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.location_on_rounded, size: 12, color: AppColors.solarOrange),
                              SizedBox(width: 4),
                              Text(
                                'NAGPUR',
                                style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom Content
                      Positioned(
                        bottom: 14,
                        left: 14,
                        right: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              slide['title'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              slide['subtitle'] as String,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.speed_rounded, size: 12, color: slide['tagColor'] as Color),
                                const SizedBox(width: 4),
                                Text(
                                  slide['stats'] as String,
                                  style: TextStyle(
                                    color: (slide['tagColor'] as Color),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _slides.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 22 : 6,
              height: 5,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.royalBlue
                    : AppColors.royalPurple.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
