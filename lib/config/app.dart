import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/auth/data/FirebaseAuthRepo.dart';
import 'package:myapp/features/auth/auth/presentation/auth_cubit.dart';
import 'package:myapp/features/auth/auth/presentation/auth_states.dart';
import 'package:myapp/features/home/home_page.dart';
import 'package:myapp/features/auth/auth/presentation/login_page.dart';

import 'package:myapp/themes/light_mode.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authRepo = Firebaseauthrepo();
 
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(authRepo)..check()),
      
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home:
            BlocConsumer<AuthCubit, AuthStates>(builder: (context, authStates) {
          if (authStates is Authenticated) {
            return  HomePage(userId: authStates.user.uid,);
          } else if (authStates is Unauthenticated) {
            return const LoginPage();
          }
          if (authStates is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const SizedBox.shrink();
          }
        }, listener: (context, authstates) {
          if (authstates is Authenticated) {
            // Perform navigation to the HomePage if needed
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) =>  HomePage(userId: authstates.user.uid,)));
          } else if (authstates is Unauthenticated) {
            // Perform navigation to the LoginPage if needed
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          }
        }),
      ),
    );
  }
}
