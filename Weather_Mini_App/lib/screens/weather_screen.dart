import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/weather_info_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  final FocusNode _focusNode = FocusNode();

  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _scaleAnimation =
        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);

    // Load default city on startup
    _fetchWeather('Lahore');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather(String city) async {
    _focusNode.unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _weather = null;
    });
    _fadeController.reset();
    _scaleController.reset();

    try {
      final weather = await _weatherService.fetchWeather(city);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
      _fadeController.forward();
      _scaleController.forward();
    } on WeatherException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    }
  }

  List<Color> _getGradientColors(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'clear':
        return [const Color(0xFF1565C0), const Color(0xFF42A5F5)];
      case 'clouds':
        return [const Color(0xFF37474F), const Color(0xFF78909C)];
      case 'rain':
      case 'drizzle':
        return [const Color(0xFF1A237E), const Color(0xFF5C6BC0)];
      case 'thunderstorm':
        return [const Color(0xFF212121), const Color(0xFF424242)];
      case 'snow':
        return [const Color(0xFF1E88E5), const Color(0xFFB3E5FC)];
      case 'mist':
      case 'fog':
      case 'haze':
        return [const Color(0xFF455A64), const Color(0xFF90A4AE)];
      default:
        return [const Color(0xFF0D47A1), const Color(0xFF1976D2)];
    }
  }

  IconData _getWeatherIcon(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny_rounded;
      case 'clouds':
        return Icons.cloud_rounded;
      case 'rain':
        return Icons.grain_rounded;
      case 'drizzle':
        return Icons.water_drop_rounded;
      case 'thunderstorm':
        return Icons.bolt_rounded;
      case 'snow':
        return Icons.ac_unit_rounded;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.cloud_queue_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }

  String _formatTime(DateTime dt) => DateFormat('hh:mm a').format(dt);

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors(_weather?.mainCondition);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '🌤 WeatherNow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      DateFormat('EEE, MMM d').format(DateTime.now()),
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.85), fontSize: 14),
                    ),
                  ],
                ),
              ),

              // ── Search Bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (val) => _fetchWeather(val.trim()),
                    decoration: InputDecoration(
                      hintText: 'Search city...',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send_rounded,
                            color: Colors.white70),
                        onPressed: () =>
                            _fetchWeather(_searchController.text.trim()),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ── Content ──
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 16),
                            Text('Fetching weather...',
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      )
                    : _errorMessage != null
                        ? _buildErrorView()
                        : _weather != null
                            ? _buildWeatherView()
                            : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_off_rounded,
                  size: 60, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              'Oops!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  _fetchWeather(_searchController.text.trim());
                }
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade700,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherView() {
    final w = _weather!;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // ── City Name ──
            Text(
              '${w.cityName}, ${w.country}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Updated just now',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.6), fontSize: 12),
            ),

            const SizedBox(height: 20),

            // ── Weather Icon + Temperature ──
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  _getWeatherIcon(w.mainCondition),
                  size: 90,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              w.formattedTemp,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 72,
                fontWeight: FontWeight.w200,
                letterSpacing: -2,
              ),
            ),

            Text(
              w.capitalizedDescription,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, letterSpacing: 0.5),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('H: ${w.formattedTempMax}',
                    style: TextStyle(color: Colors.white.withOpacity(0.8))),
                const SizedBox(width: 16),
                Text('L: ${w.formattedTempMin}',
                    style: TextStyle(color: Colors.white.withOpacity(0.8))),
              ],
            ),

            const SizedBox(height: 28),

            // ── Info Cards Grid ──
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                WeatherInfoCard(
                  icon: Icons.thermostat_rounded,
                  label: 'Feels Like',
                  value: w.formattedFeelsLike,
                  iconColor: Colors.orangeAccent,
                ),
                WeatherInfoCard(
                  icon: Icons.water_drop_rounded,
                  label: 'Humidity',
                  value: '${w.humidity}%',
                  iconColor: Colors.lightBlueAccent,
                ),
                WeatherInfoCard(
                  icon: Icons.air_rounded,
                  label: 'Wind Speed',
                  value: '${w.windSpeed} m/s',
                  iconColor: Colors.greenAccent,
                ),
                WeatherInfoCard(
                  icon: Icons.compress_rounded,
                  label: 'Pressure',
                  value: '${w.pressure} hPa',
                  iconColor: Colors.purpleAccent,
                ),
                WeatherInfoCard(
                  icon: Icons.visibility_rounded,
                  label: 'Visibility',
                  value: '${(w.visibility / 1000).toStringAsFixed(1)} km',
                  iconColor: Colors.amberAccent,
                ),
                WeatherInfoCard(
                  icon: Icons.wb_sunny_outlined,
                  label: 'Sunrise',
                  value: _formatTime(w.sunrise),
                  iconColor: Colors.yellowAccent,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Sunset Card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _sunItem(
                      Icons.wb_twilight_rounded, 'Sunrise', _formatTime(w.sunrise)),
                  Container(
                      height: 40, width: 1, color: Colors.white.withOpacity(0.3)),
                  _sunItem(Icons.nightlight_round, 'Sunset',
                      _formatTime(w.sunset)),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sunItem(IconData icon, String label, String time) {
    return Column(
      children: [
        Icon(icon, color: Colors.amberAccent, size: 28),
        const SizedBox(height: 6),
        Text(time,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.6), fontSize: 12)),
      ],
    );
  }
}
