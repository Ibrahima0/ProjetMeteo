import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meteo/models/onboarding.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'home_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<Widget> onBoardingList = [];
  late int selectedPage;
  late final PageController _pageController;

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);
    super.initState();
    onBoardingList = [
      const OnBoardingWidget(
        photo: "m3.png",
        title: "Restez informé sur la météo",
        desc:
        "L'application météo qui vous permet de suivre les prévisions météorologiques de votre région et d'autres parties du monde.",
      ),
      const OnBoardingWidget(
        photo: "m4.png",
        title: "Personnalisez votre expérience",
        desc:
        "Personnalisez votre tableau de bord météo en choisissant les informations qui vous intéressent : température, humidité, vitesse du vent, etc.",
      ),
      const OnBoardingWidget(
        photo: "m5.png",
        title: "Alertes météo",
        desc:
        "Recevez des alertes en temps réel sur les conditions météorologiques extrêmes, comme les tempêtes, les tornades, les inondations, les tempêtes de neige, etc. pour rester en sécurité.",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 500,
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      selectedPage = page;
                    });
                  },
                  children: onBoardingList,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                        }));
                  },
                  icon: const Icon(
                    Icons.navigate_next,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Commencer",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: PageViewDotIndicator(
                    currentItem: selectedPage,
                    count: 3,
                    unselectedColor: Colors.blue.withOpacity(0.5),
                    selectedColor: Colors.blue,
                    duration: const Duration(milliseconds: 200),
                    boxShape: BoxShape.circle,
                    size: const Size(8, 8),
                    unselectedSize: const Size(6, 6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardingWidget extends StatelessWidget {
  final String photo, title, desc;

  const OnBoardingWidget({
    Key? key,
    required this.photo,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/$photo",
              width: 200.0,
              height: 200.0,
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                desc,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}