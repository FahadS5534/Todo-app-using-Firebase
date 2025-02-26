import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/components/my_text_field.dart';
import 'package:myapp/features/auth/auth/presentation/auth_cubit.dart';
import 'package:myapp/features/auth/auth/presentation/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "So nice to see you!",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            "Register with a new Account",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 10.0,
          ),
          MyTextField(
              hintText: "John Doe",
              label: "Name",
              obscureText: false,
              controller: _nameController),
          const SizedBox(
            height: 25.0,
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
          MyTextField(
              hintText: "********",
              label: "Confirm your Password",
              obscureText: true,
              controller: _confirmpasswordController),
          const SizedBox(
            height: 25.0,
          ),
          TextButton(
            onPressed: () async {
              final authCubit = context.read<AuthCubit>();
              if (_emailController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please fill all the fields")));
              } else if (_passwordController.text !=
                  _confirmpasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Passwords doesn't match")));
              } else {
                try {
                  // Call the signup function
                  await authCubit.SignUpUserW(
                    _nameController.text,
                    _emailController.text,
                    _passwordController.text,
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } catch (e) {
                  // Optional: Handle any uncaught errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
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
            child: const Text("Sign up"),
          ),
          const SizedBox(
            height: 25.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Already have an account?  ",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text(
                "Log In",
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Poppins',
                    decoration: TextDecoration.underline),
              ),
            )
          ])
        ])),
      ),
    );
  }
}
