import 'dart:async';

import 'package:flutter/material.dart';

import '../service/weather_client_api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> cities = [
    'Paris',
    'Berlin',
    'Londres',
    'Rome',
    'Barcelone',
  ];

  final PageController _pageController = PageController(initialPage: 0);
  bool pageControllerInitialized = false;

  Timer? timer;
  double progress = 0.0;
  List<Map<String, dynamic>> weatherData = [];
  List<String> loadingMessages = [
    'Nous téléchargeons les données...',
    'C\'est presque fini...',
    'Plus que quelques secondes avant d\'avoir le résultat...',
  ];
  int messageIndex = 0;

  WeatherService weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      setState(() {
        messageIndex = (messageIndex + 1) % loadingMessages.length;
      });
    });
    initializePageController();
    startLoadingTimer();
    fetchWeatherData();
  }

  @override
  void dispose() {
    timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> initializePageController() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.addListener(pageControllerListener);
      } else {
        initializePageController();
      }
    });
  }

  Future<void> startLoadingTimer() async {
    final startTime = DateTime.now();
    const totalDuration = Duration(seconds: 60);

    while (DateTime.now().difference(startTime) < totalDuration) {
      setState(() {
        progress =
            DateTime.now().difference(startTime).inMilliseconds / totalDuration.inMilliseconds;
      });

      await Future.delayed(const Duration(milliseconds: 100));
    }

    setState(() {
      progress = 1.0;
    });
  }

  Future<void> fetchWeatherData() async {
    setState(() {
      weatherData.clear();
    });

    for (int i = 0; i < cities.length; i++) {
      final weather = await weatherService.getCurrentWeather(cities[i]);

      setState(() {
        weatherData.add({
          'ville': cities[i],
          'temperature': weatherService.convertToCelsius(weather['main']['temp']),
          'couvertureNuageuse': weather['clouds']['all'],
        });
      });

      await Future.delayed(const Duration(seconds: 10));

      if (pageControllerInitialized && i < cities.length - 1) {
        _pageController.nextPage(
          duration: const Duration(seconds: 1),
          curve: Curves.ease,
        );
      }
    }
  }

  void pageControllerListener() {
    if (_pageController.hasClients && _pageController.position.hasContentDimensions) {
      setState(() {
        pageControllerInitialized = true;
      });
    }
  }

  Widget _buildWeatherList() {
    return Expanded(
      child: ListView.builder(
        itemCount: weatherData.length,
        itemBuilder: (context, index) {
          final data = weatherData[index];
          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(
                data['ville'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Row(
                children: [
                  const Icon(Icons.thermostat_outlined),
                  const SizedBox(width: 4.0),
                  Text(
                    '${data['temperature'].toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  const Icon(Icons.cloud_outlined),
                  const SizedBox(width: 4.0),
                  Text(
                    '${data['couvertureNuageuse']}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Column(
      children: [
        Text(
          loadingMessages[messageIndex],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        CircularProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          strokeWidth: 10.0,
        ),
        const SizedBox(height: 20),
        Text(
          'Chargement ${(progress * 100).toStringAsFixed(0)}%',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRetryButton() {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            progress = 0.0;
            weatherData.clear();
            startLoadingTimer();
            fetchWeatherData();
          });
        },
        child: const Text('Recommencer'),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Actu Météo',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (progress == 1.0)
                _buildWeatherList()
              else
                _buildLoadingScreen(),
              const SizedBox(height: 20),
              if (progress == 1.0) _buildRetryButton(),
            ],
          ),
        ),
      ),
    );
  }
}
