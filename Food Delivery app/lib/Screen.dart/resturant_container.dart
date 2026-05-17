import 'package:flutter/material.dart';

class ClassContainer extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String location;

  const ClassContainer({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,

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

            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,

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
                  const Icon(Icons.location_on, color: Colors.white, size: 18),

                  const SizedBox(width: 5),

                  Expanded(
                    child: Text(
                      location,

                      overflow: TextOverflow.ellipsis,

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

class ClassDetailScreen extends StatelessWidget {
  final Map<String, dynamic> classData;

  const ClassDetailScreen({super.key, required this.classData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: CustomScrollView(
        slivers: [
          // APP BAR
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,

            leading: Padding(
              padding: const EdgeInsets.all(8),

              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),

            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'class-image-${classData['id']}',

                child: Stack(
                  fit: StackFit.expand,

                  children: [
                    Image.network(
                      classData['image_url'] ??
                          'https://via.placeholder.com/400x300',

                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],

                          child: const Icon(Icons.broken_image, size: 80),
                        );
                      },
                    ),

                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,

                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // BODY
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // NAME
                  Text(
                    classData['name'] ?? 'Unknown Restaurant',

                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // LOCATION
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          classData['location'] ?? 'Unknown Location',

                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // PRICE + RATING
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),

                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),

                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Column(
                            children: [
                              const Icon(
                                Icons.attach_money,
                                color: Colors.orange,
                                size: 28,
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                "Price",

                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                classData['price']?.toString() ?? '\$0',

                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),

                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.15),

                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Column(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 28,
                              ),

                              const SizedBox(height: 8),

                              // const Text(
                              //   "Rating",

                              //   style: TextStyle(
                              //     color: Colors.black54,
                              //     fontSize: 15,
                              //   ),
                              // ),
                              Text(
                                classData['price']?.toString() ?? 'No Price',

                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                classData['rating']?.toString() ?? 'No Rating',

                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ABOUT TITLE
                  const Text(
                    "Description",

                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  // DESCRIPTION
                  Text(
                    classData['description'] ?? 'No description available.',

                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 58,

                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Booking Coming Soon")),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      child: const Text(
                        "Book Now",

                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


