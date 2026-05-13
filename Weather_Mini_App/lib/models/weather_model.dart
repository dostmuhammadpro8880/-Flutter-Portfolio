class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String description;
  final String iconCode;
  final String mainCondition;
  final int visibility;
  final DateTime sunrise;
  final DateTime sunset;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.description,
    required this.iconCode,
    required this.mainCondition,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      pressure: json['main']['pressure'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      iconCode: json['weather'][0]['icon'] ?? '01d',
      mainCondition: json['weather'][0]['main'] ?? '',
      visibility: json['visibility'] as int? ?? 0,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
          (json['sys']['sunrise'] as int) * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(
          (json['sys']['sunset'] as int) * 1000),
    );
  }

  String get iconUrl =>
      'https://openweathermap.org/img/wn/$iconCode@2x.png';

  String get formattedTemp => '${temperature.round()}°C';
  String get formattedFeelsLike => '${feelsLike.round()}°C';
  String get formattedTempMin => '${tempMin.round()}°C';
  String get formattedTempMax => '${tempMax.round()}°C';
  String get capitalizedDescription =>
      description.split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
}
