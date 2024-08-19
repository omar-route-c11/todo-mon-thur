import 'package:flutter/material.dart';
import 'package:todo/auth/login_screen.dart';
import 'package:todo/tabs/tasks/default_elevated_button.dart';
import 'package:todo/tabs/tasks/default_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextFormField(
                controller: nameController,
                hintText: 'Name',
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return 'Name can not be less than 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                controller: emailController,
                hintText: 'Email',
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return 'Email can not be less than 5 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                controller: passwordController,
                hintText: 'Password',
                validator: (value) {
                  if (value == null || value.trim().length < 8) {
                    return 'Password can not be less than 8 characters';
                  }
                  return null;
                },
                isPassword: true,
              ),
              const SizedBox(height: 32),
              DefaultElevatedButton(
                label: 'Create Account',
                onPressed: register,
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName),
                child: const Text('Already have an account?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    if (formKey.currentState!.validate()) {
      // Register logic
    }
  }
}
