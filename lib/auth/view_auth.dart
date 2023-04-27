import 'package:flutter/material.dart';
import 'package:mvvm/auth/controller_auth.dart';
import 'package:mvvm/settings/controller_settings.dart';
import 'package:provider/provider.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final int platform = context.watch<SettingsController>().platform;
    // bool loading = context.watch<AuthController>
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(20.0),
        child: context.watch<AuthController>().loading
            ? const CircularProgressIndicator(
                color: Color(0xff252525),
              )
            : InkWell(
                onTap: () {
                  context
                      .read<AuthController>()
                      .signinWithGoogle(platform: platform);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.black87,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: size.width * 0.05,
                          child: Image.asset("assets/chrome.png")),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      const Text(
                        "Sign-in with Google",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
