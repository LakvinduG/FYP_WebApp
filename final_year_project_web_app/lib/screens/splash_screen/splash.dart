import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:final_year_project_web_app/screens/login_screen/login.dart';

/// SplashScreen
///
/// Displays an introductory video when the web app starts.
/// Features:
/// - Plays a full-screen logo video on app load
/// - Automatically navigates to LoginScreen after video finishes
/// - Shows a loading indicator until video is ready
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // =========================
  //  STATE VARIABLES
  // =========================
  late VideoPlayerController _controller;
  
  // =========================
  //  INITIALIZATION
  // =========================
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/FYP_WEB_LOGO.mp4")
      ..initialize().then((_) {
        setState(() {}); 
        _controller.play();
      });
    
    // Listen to video playback to navigate after completion
    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >= _controller.value.duration) {
        _navigateToLogin();
      }
    });
  }
  
  
  // =========================
  //  NAVIGATION
  // =========================
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
  
  // =========================
  //  CLEANUP
  // =========================
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  // =========================
  //  UI BUILD
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
