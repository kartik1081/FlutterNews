import 'package:flutter/material.dart';
import 'package:mvvm/auth/controller_auth.dart';
import 'package:mvvm/settings/controller_settings.dart';
import 'package:provider/provider.dart';

import '../local_auth/controller_local_auth.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final int platform = context.watch<SettingsController>().platform;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff252525),
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.005,
          ),
          Consumer<LocalAuthController>(
            builder: (context, localAuth, child) => ListTile(
              onTap: () => localAuth.isBiometricAvailable
                  ? localAuth.changeBiometricAvailability(
                      biometric: !localAuth.isActiveBiometric,
                      platform: platform)
                  : null,
              leading: Icon(
                Icons.fingerprint,
                color: localAuth.isActiveBiometric ? Colors.green : Colors.grey,
              ),
              title: Text(localAuth.isBiometricAvailable
                  ? "Biometric setup"
                  : "Biometric is not available in system"),
              trailing: localAuth.isBiometricAvailable
                  ? Switch(
                      activeColor: Colors.white,
                      inactiveTrackColor: Colors.redAccent,
                      activeTrackColor: Colors.greenAccent,
                      value: localAuth.isActiveBiometric,
                      onChanged: (value) =>
                          localAuth.changeBiometricAvailability(
                              biometric: value, platform: platform),
                    )
                  : const SizedBox(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text("Sign Out"),
            onTap: () => context.read<AuthController>().signOut(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            title: const Text(
              "Delete user",
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              print("1");
              context.read<AuthController>().deleteUser();
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
