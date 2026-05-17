import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ===================== SHOP LIST WIDGET =====================

class ShopListWidget extends StatefulWidget {
  final void Function(Map<String, dynamic> shop) onTapShop;

  const ShopListWidget({
    super.key,
    required this.onTapShop,
  });

  @override
  State<ShopListWidget> createState() =>
      _ShopListWidgetState();
}

class _ShopListWidgetState
    extends State<ShopListWidget> {
  late Future<List<Map<String, dynamic>>>
  _shopsFuture;

  @override
  void initState() {
    super.initState();
    _shopsFuture = _fetchShops();
  }

  Future<List<Map<String, dynamic>>>
  _fetchShops() async {
    final response =
        await Supabase.instance.client
            .from('shops')
            .select();

    return List<Map<String, dynamic>>.from(
      response,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<
      List<Map<String, dynamic>>
    >(
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
              snapshot.error.toString(),
            ),
          );
        }

        final shops = snapshot.data ?? [];

        if (shops.isEmpty) {
          return const Center(
            child: Text("No shops found"),
          );
        }

        return SizedBox(
          height: 270,

          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: shops.length,

            separatorBuilder:
                (_, __) =>
                    const SizedBox(width: 12),

            itemBuilder: (context, index) {
              final shop = shops[index];

              return GestureDetector(
                behavior:
                    HitTestBehavior.opaque,

                onTap:
                    () =>
                        widget.onTapShop(shop),

                child: Container(
                  width: 220,

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
  borderRadius: BorderRadius.circular(20),

  child: Stack(
    fit: StackFit.expand,

    children: [
      // FULL IMAGE
      Image.network(
        (shop['image_url'] ?? '')
            .toString(),

        fit: BoxFit.cover,

        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return Container(
            color: Colors.grey[300],

            child: const Center(
              child: Icon(
                Icons.image,
                size: 50,
              ),
            ),
          );
        },
      ),

      // DARK OVERLAY
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
      ),

      // TEXT CONTENT
      Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Spacer(),

            Text(
              (shop['name'] ?? '')
                  .toString(),

              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),

              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            Text(
              (shop['location'] ?? '')
                  .toString(),

              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),

              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
              ),

              child: Text(
                "\$${(shop['price'] ?? '').toString()}",

                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),
                    //   ClipRRect(
                    //     borderRadius:
                    //         const BorderRadius.only(
                    //           topLeft:
                    //               Radius.circular(
                    //                 20,
                    //               ),
                    //           topRight:
                    //               Radius.circular(
                    //                 20,
                    //               ),
                    //         ),

                    //     child: Image.network(
                    //       (shop['image_url'] ??
                    //               '')
                    //           .toString(),

                    //       height: 160,
                    //       width:
                    //           double.infinity,
                    //       fit: BoxFit.cover,

                    //       errorBuilder:
                    //           (
                    //             context,
                    //             error,
                    //             stackTrace,
                    //           ) {
                    //             return Container(
                    //               height: 160,
                    //               color:
                    //                   Colors
                    //                       .grey[300],

                    //               child: const Center(
                    //                 child: Icon(
                    //                   Icons.image,
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //     ),
                    //   ),

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
                              (shop['name'] ??
                                      '')
                                  .toString(),

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
                              (shop['location'] ??
                                      '')
                                  .toString(),

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
                              "\$${(shop['price'] ?? '').toString()}",

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
              );
            },
          ),
        );
      },
    );
  }
}

// ===================== DETAIL SCREEN =====================

class ShopDetailScreen extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String location;
  final String price;

  const ShopDetailScreen({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Image.network(
              imageUrl,

              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,

              errorBuilder:
                  (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return Container(
                      height: 300,
                      color: Colors.grey[300],

                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 80,
                        ),
                      ),
                    );
                  },
            ),

            Padding(
              padding: const EdgeInsets.all(
                16,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    name,

                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(location),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "\$$price",

                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "About Shop",

                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "This shop provides high quality products with affordable prices and excellent customer service.",

                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


