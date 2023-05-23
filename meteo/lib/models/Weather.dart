class Weather {
  final String ville;
  final double temperature;
  final int couvertureNuageuse;

  Weather({
    required this.ville,
    required this.temperature,
    required this.couvertureNuageuse,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final currentWeather = json['current'];

    return Weather(
      ville: json['city_name'] as String,
      temperature: currentWeather['temp'].toDouble(),
      couvertureNuageuse: currentWeather['clouds']['all'] as int,
    );
  }
}
