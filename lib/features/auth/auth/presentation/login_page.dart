import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/components/my_text_field.dart';
import 'package:myapp/features/auth/auth/presentation/auth_cubit.dart';
import 'package:myapp/features/auth/auth/presentation/register_paage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Hello Again!",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            "Sign in to your account",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 10.0,
          ),
          MyTextField(
              hintText: "info@xyz.com",
              label: "Email",
              obscureText: false,
              controller: _emailController),
          const SizedBox(
            height: 25.0,
          ),
          MyTextField(
              hintText: "********",
              label: "Password",
              obscureText: true,
              controller: _passwordController),
          const SizedBox(
            height: 25.0,
          ),
          TextButton(
            onPressed: () {
              login();
            },
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all<Size>(const Size(500, 80)),
              backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            child: const Text("Log In"),
          ),
          const SizedBox(
            height: 25.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Don't have an account?  ",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 16,
                      color:  Color(0xFF9C8DF2),
                      fontFamily: 'Poppins',
                      decoration: TextDecoration.underline),
                ))
          ])
        ])),
      ),
    );
  }

  void login() {
    final authCubit = context.read<AuthCubit>();
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all the fields")));
    } else {
      authCubit.loginUserW(_emailController.text, _passwordController.text);
      
    }
  }
}
