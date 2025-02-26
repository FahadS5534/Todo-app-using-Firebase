import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/config/app.dart';
import 'package:myapp/config/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
      url: "https://tiibkpmsqnoorllngmuu.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRpaWJrcG1zcW5vb3JsbG5nbXV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY3NzcxMjgsImV4cCI6MjA1MjM1MzEyOH0.TlX0vtFKB6_JdRVQqjlfJvGLNGMN38ei3FDq-1pPwf4");
  runApp(MyApp());
}
