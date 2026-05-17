import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HotelsPage extends StatefulWidget {
  const HotelsPage({super.key});

  @override
  State<HotelsPage> createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  late Future<List<Map<String, dynamic>>> _hotelsFuture;

  @override
  void initState() {
    super.initState();
    _hotelsFuture = _fetchHotels();
    _subscribeToHotels();
  }

  Future<List<Map<String, dynamic>>> _fetchHotels() async {
    try {
      final response = await Supabase.instance.client
          .from('hotels')
          .select();

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Error fetching hotels: $e");
      return [];
    }
  }

  void _subscribeToHotels() {
    Supabase.instance.client
        .channel('hotels-channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'hotels',
          callback: (payload) {
            setState(() {
              _hotelsFuture = _fetchHotels();
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
        title: const Text("Hotels"),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
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
            padding: const EdgeInsets.all(16),
            itemCount: hotels.length,

            itemBuilder: (context, index) {
              final hotel = hotels[index];

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),

                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder:
                            (_) => HotelDetailScreen(
                              hotelData: hotel,
                            ),
                      ),
                    );
                  },

                  child: Hero(
                    tag: 'hotel-image-${hotel['id']}',

                    child: HotelContainer(
                      name:
                          hotel['name'] ?? 'Unknown Hotel',

                      imageUrl:
                          hotel['image_url'] ??
                          'https://via.placeholder.com/400x300',

                      location:
                          hotel['location'] ??
                          'Unknown Location',
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HOTEL CARD
// ─────────────────────────────────────────────

class HotelContainer extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String location;

  const HotelContainer({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),

          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                name,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 18,
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                    child: Text(
                      location,

                      overflow:
                          TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HOTEL DETAIL SCREEN
// ─────────────────────────────────────────────

class HotelDetailScreen extends StatelessWidget {
  final Map<String, dynamic> hotelData;

  const HotelDetailScreen({
    super.key,
    required this.hotelData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.white,

            leading: Padding(
              padding: const EdgeInsets.all(8),

              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag:
                    'hotel-image-${hotelData['id']}',

                child: Image.network(
                  hotelData['image_url'] ??
                      'https://via.placeholder.com/400x300',

                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    hotelData['name'] ??
                        'Unknown Hotel',

                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          hotelData['location'] ??
                              'Unknown Location',

                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "About Hotel",

                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Luxury hotel with comfortable rooms and best services.",

                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Room Booking Coming Soon",
                                ),
                              ),
                            );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),

                      child: const Text(
                        "Book Room",

                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}