import 'package:control_panel/components/custom_button.dart';
import 'package:control_panel/components/custom_textfield.dart';
import 'package:control_panel/constants/colors.dart';
import 'package:control_panel/constants/paths.dart';
import 'package:control_panel/pages/home/view/home.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void onSignIn(BuildContext context) {
    if (usernameController.text == 'admin' &&
        passwordController.text == 'secret') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez réessayer. Nom d\'utilisateur ou mot de passe incorrect.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  Paths.logoBlackVoid,
                  width: width * 0.3,
                  height: height * 0.2,
                ),
                const Text(
                  'Veuillez vous identifier'
                  ' pour accéder au panneau de contrôle.',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: height * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.3),
                  child: Divider(
                    thickness: 0.5,
                    color: ProjectColors.greyLight,
                  ),
                ),
                SizedBox(height: height * 0.03),
                CustomTextField(
                  controller: usernameController,
                  labelText: 'Identifiant',
                  obscureText: false,
                ),
                CustomTextField(
                  controller: passwordController,
                  labelText: 'Mot de passe',
                  obscureText: true,
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'id : admin\npassword : secret',
                          ),
                        ),
                      ),
                      child: Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(
                          color: ProjectColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                CustomButton(
                  onTap: () => onSignIn(context),
                  text: 'Se connecter',
                ),
                SizedBox(height: height * 0.04),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.3),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: ProjectColors.greyLight,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Nos partenaires',
                          style: TextStyle(color: ProjectColors.greyDark),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: ProjectColors.greyLight,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Paths.logoGotronic,
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(width: width * 0.02),
                    Image.asset(
                      Paths.logoEsilv,
                      width: 150,
                      height: 100,
                    ),
                    SizedBox(width: width * 0.02),
                    Image.asset(
                      Paths.logoDvic,
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
