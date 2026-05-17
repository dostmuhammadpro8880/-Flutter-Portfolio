
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CarouselItem {
  final int id;
  final String name;
  final String imageUrl;
  final String? description;
  final bool isActive;
  final DateTime createdAt;

  CarouselItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description,
    required this.isActive,
    required this.createdAt,
  });

  // Convert from Supabase JSON
  factory CarouselItem.fromJson(Map<String, dynamic> json) {
    return CarouselItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      description: json['description'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image_url': imageUrl,
      'description': description,
      'is_active': isActive,
    };
  }
}

class CarouselService {
  final _supabase = Supabase.instance.client;
  static const String _tableName = 'carousel_items';

  // Fetch all active carousel items
  Future<List<CarouselItem>> fetchCarouselData() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => CarouselItem.fromJson(item))
          .toList();
    } catch (e) {
      throw 'Failed to fetch carousel data: $e';
    }
  }

  // Add new carousel item
  Future<CarouselItem> addCarouselItem(CarouselItem item) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .insert(item.toJson())
          .select()
          .single();

      return CarouselItem.fromJson(response);
    } catch (e) {
      throw 'Failed to add carousel item: $e';
    }
  }

  // Update carousel item
  Future<CarouselItem> updateCarouselItem(int id, CarouselItem item) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .update(item.toJson())
          .eq('id', id)
          .select()
          .single();

      return CarouselItem.fromJson(response);
    } catch (e) {
      throw 'Failed to update carousel item: $e';
    }
  }

  // Delete carousel item (soft delete)
  Future<void> deleteCarouselItem(int id) async {
    try {
      await _supabase
          .from(_tableName)
          .update({'is_active': false})
          .eq('id', id);
    } catch (e) {
      throw 'Failed to delete carousel item: $e';
    }
  }

  // Toggle active status
  Future<void> toggleCarouselItemStatus(int id, bool isActive) async {
    try {
      await _supabase
          .from(_tableName)
          .update({'is_active': isActive})
          .eq('id', id);
    } catch (e) {
      throw 'Failed to toggle carousel item status: $e';
    }
  }
}

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({super.key});

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  late Future<List<CarouselItem>> _carouselDataFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _carouselDataFuture = CarouselService().fetchCarouselData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CarouselItem>>(
      future: _carouselDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _carouselDataFuture =
                          CarouselService().fetchCarouselData();
                    });
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final carouselItems = snapshot.data ?? [];

        if (carouselItems.isEmpty) {
          return const Center(child: Text('No carousel items available'));
        }

        return Column(
          children: [
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: carouselItems.length,
                itemBuilder: (context, index) {
                  return _buildCarouselCard(carouselItems[index]);
                },
              ),
            ),
            const SizedBox(height: 20),
            SmoothPageIndicator(
              controller: _pageController,
              count: carouselItems.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
                activeDotColor: Color(0xFF667eea),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCarouselCard(CarouselItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped on ${item.name}')),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Image background
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
              // Dark overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // Name text
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.description != null && item.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          item.description!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}