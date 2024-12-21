import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_crud_pet/features/app/app_model.dart';
import 'package:todos_crud_pet/features/login/login_model.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => LoginModel(
        context: context,
        authRepository: context.read<AppModel>().authRepository,
      ),
      child: const Login(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: context.read<LoginModel>().emailTextController,
              onChanged: context.read<LoginModel>().onEmailChange,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                labelText: 'Email',
                errorText: context.watch<LoginModel>().errorEmail,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: context.read<LoginModel>().passwordTextController,
              onChanged: context.read<LoginModel>().onPasswordChange,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              enableSuggestions: false,
              decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                errorText: context.watch<LoginModel>().errorPassword,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: context.read<LoginModel>().onLoginPress,
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
