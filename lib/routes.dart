import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/pose_guide_screen.dart';
import 'screens/image_pose_detector.dart';
import 'screens/live_pose_detector.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/login_screen.dart'; // ✅ Add login
import 'screens/signup_screen.dart'; 

Map<String, WidgetBuilder> getAppRoutes() {
  return {
    "/home": (context) => HomeScreen(), // ✅ Change "/" to "/home"
    "/about": (context) => AboutScreen(),
    "/poseGuide": (context) => PoseGuideScreen(),
    "/poseDetection": (context) => ImagePoseDetector(),
    "/livePose": (context) => LivePoseDetector(),
    "/leaderboard": (context) => LeaderboardScreen(),
    "/profile": (context) => UserProfileScreen(),
    "/login": (context) => LoginScreen(), // ✅ Add login route
    "/signup": (context) => SignUpScreen(), // ✅ Add signup route
  };
}
