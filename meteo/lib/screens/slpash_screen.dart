import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meteo/screens/onboarding_screen.dart';

import 'home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();
    Timer(const Duration(seconds: 5),(){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return OnBoardingScreen();
      }));
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white70,
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient:LinearGradient(
            colors: [
              Colors.blue,
              Colors.white70,
            ], begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          )
        ),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                "assets/images/logo.png",
                width: 170,
                height: 170,
              ),
            ),
            const SizedBox(height: 10,),
        Text(
          "Chargement en cours...",
            style: GoogleFonts.roboto(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.white70
            ),
        ),

          ],
        ),

      )
    );
  }
}
