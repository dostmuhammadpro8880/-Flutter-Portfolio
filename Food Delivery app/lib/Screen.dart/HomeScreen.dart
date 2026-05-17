import 'package:final_exam_project/Screen.dart/Clothshope.dart';
import 'package:final_exam_project/Screen.dart/_showAddClassDialog.dart';
import 'package:final_exam_project/Screen.dart/hotels_container.dart';
import 'package:final_exam_project/Screen.dart/resturant_container.dart';
import 'package:final_exam_project/Screen.dart/drawer.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Login_Screen.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _classesFuture;
late Future<List<Map<String, dynamic>>> _hotelsFuture;
late Future<List<Map<String, dynamic>>> _shopsFuture;
  @override
  void initState() {
    super.initState();
    _classesFuture = _fetchClasses();
    _hotelsFuture = _fetchHotels();
    _shopsFuture = _fetchShops();
    _subscribeToChanges();
  }

  Future<List<Map<String, dynamic>>> _fetchClasses() async {
    try {
      final response = await Supabase.instance.client.from('classes').select();

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }
Future<List<Map<String, dynamic>>> _fetchHotels() async {
  try {
    final response = await Supabase.instance.client
        .from('hotels')
        .select();

    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    debugPrint("Hotel Error: $e");
    return [];
  }
}

Future<List<Map<String, dynamic>>> _fetchShops() async {
  try {
    final response = await Supabase.instance.client
        .from('shops')
        .select();

    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    debugPrint("Shop Error: $e");
    return [];
  }
}
  void _subscribeToChanges() {
    Supabase.instance.client
        .channel('classes-channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'classes',
          callback: (payload) {
            setState(() {
              _classesFuture = _fetchClasses();
            });
          },
        )
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
  backgroundColor: Colors.white,

  appBar: AppBar(
    title: const Text("Restaurant App"),
    centerTitle: true,
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
  ),
// drawer: AppDrawer(email: email, customId: customId, logout: logout),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CarouselSlider(),
          const Text(
            "Popular Restaurants",

            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 260,

            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _classesFuture,

              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                    ),
                  );
                }

                final classes = snapshot.data ?? [];

                if (classes.isEmpty) {
                  return const Center(
                    child: Text("No Data Found"),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: classes.length,

                  itemBuilder: (context, index) {
                    final classData = classes[index];

                    return Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                      ),

                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder:
                                  (_) => ClassDetailScreen(
                                    classData: classData,
                                  ),
                            ),
                          );
                        },

                        child: Hero(
                          tag:
                              'class-image-${classData['id']}',

                          child: SizedBox(
                            width: 300,

                            child: ClassContainer(
                              name:
                                  classData['name'] ??
                                  'Unknown',

                              imageUrl:
                                  classData['image_url'] ??
                                  'https://via.placeholder.com/400x300',

                              location:
                                  classData['location'] ??
                                  'Unknown Location',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Hotels",

            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

SizedBox(
  height: 260,

  child: FutureBuilder<List<Map<String, dynamic>>>(
    future: _hotelsFuture,

    builder: (context, snapshot) {
      if (snapshot.connectionState ==
          ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {
        return Center(
          child: Text(
            "Error: ${snapshot.error}",
          ),
        );
      }

      final hotels = snapshot.data ?? [];

      if (hotels.isEmpty) {
        return const Center(
          child: Text("No Hotels Found"),
        );
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hotels.length,

        itemBuilder: (context, index) {
          final hotelData = hotels[index];

          return Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),

            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder:
                        (_) => HotelDetailScreen(
                          hotelData: hotelData,
                        ),
                  ),
                );
              },

              child: Hero(
                tag:
                    'hotel-image-${hotelData['id']}',

                child: SizedBox(
                  width: 300,

                  child: HotelContainer(
                    name:
                        hotelData['name'] ??
                        'Unknown Hotel',

                    imageUrl:
                        hotelData['image_url'] ??
                        'https://via.placeholder.com/400x300',

                    location:
                        hotelData['location'] ??
                        'Unknown Location',
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  ),
),

SizedBox(height: 20,),

         const Text(
            "Clothes",

            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

SizedBox(height: 20,),

SizedBox(
  height: 270,

  child: FutureBuilder<List<Map<String, dynamic>>>(
    future: _shopsFuture,

    builder: (context, snapshot) {
      if (snapshot.connectionState ==
          ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {
        return Center(
          child: Text(
            "Error: ${snapshot.error}",
          ),
        );
      }

      final shops = snapshot.data ?? [];

      if (shops.isEmpty) {
        return const Center(
          child: Text("No Shops Found"),
        );
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: shops.length,

        itemBuilder: (context, index) {
          final shopData = shops[index];

          return Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),

            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder:
                        (_) => ShopDetailScreen(
                          name:
                              shopData['name'] ??
                              '',

                          imageUrl:
                              shopData['image_url'] ??
                              '',

                          location:
                              shopData['location'] ??
                              '',

                          price:
                              shopData['price']
                                  .toString(),
                        ),
                  ),
                );
              },

              child: SizedBox(
                width: 220,

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                          20,
                        ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.1),

                        blurRadius: 6,
                        offset: const Offset(
                          0,
                          3,
                        ),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.only(
                              topLeft:
                                  Radius.circular(
                                    20,
                                  ),
                              topRight:
                                  Radius.circular(
                                    20,
                                  ),
                            ),

                        child: Image.network(
                          shopData['image_url'] ??
                              '',

                          height: 160,
                          width:
                              double.infinity,
                          fit: BoxFit.cover,

                          errorBuilder:
                              (
                                context,
                                error,
                                stackTrace,
                              ) {
                                return Container(
                                  height: 160,
                                  color:
                                      Colors
                                          .grey[300],

                                  child: const Center(
                                    child: Icon(
                                      Icons.image,
                                    ),
                                  ),
                                );
                              },
                        ),
                      ),

                      Padding(
                        padding:
                            const EdgeInsets.all(
                              10,
                            ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            Text(
                              shopData['name'] ??
                                  '',

                              style:
                                  const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),

                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              shopData['location'] ??
                                  '',

                              style: TextStyle(
                                color:
                                    Colors
                                        .grey[700],
                              ),

                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              "\$${shopData['price'] ?? ''}",

                              style:
                                  const TextStyle(
                                    color:
                                        Colors
                                            .green,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  ),
),

    ],
      ),
    ),
  ),
);
   }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(
                icon: Icons.home_rounded,
                isSelected: selectedIndex == 0,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                icon: Icons.food_bank_outlined,
                isSelected: selectedIndex == 1,
              ),
              label: 'Foods',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                icon: Icons.shopping_bag,
                isSelected: selectedIndex == 2,
              ),
              label: 'Shops',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon({required IconData icon, required bool isSelected}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.blueAccent.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, size: isSelected ? 26 : 24),
    );
  }
}

// import 'package:supabase_flutter/supabase_flutter.dart';

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
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
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
                      _carouselDataFuture = CarouselService()
                          .fetchCarouselData();
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Tapped on ${item.name}')));
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
                    if (item.description != null &&
                        item.description!.isNotEmpty)
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
