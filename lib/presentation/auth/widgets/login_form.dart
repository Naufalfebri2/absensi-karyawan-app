import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';
import '../../../core/widgets/loading_overlay.dart';
import 'auth_text_field.dart';
import 'auth_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingOverlay.showOverlay(context);
        } else {
          LoadingOverlay.hideOverlay();
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }

        if (state.isSuccess == true) {
          Navigator.pushReplacementNamed(context, "/home");
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            AuthTextField(
              label: "Email",
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AuthTextField(label: "Password", controller: passC, obscure: true),
            const SizedBox(height: 24),
            AuthButton(
              text: "Login",
              enabled: !state.isLoading,
              onPressed: () {
                context.read<LoginCubit>().login(
                  emailC.text.trim(),
                  passC.text.trim(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
