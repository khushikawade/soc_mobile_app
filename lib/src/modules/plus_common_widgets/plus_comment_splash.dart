import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/graded_plus/modal/user_info.dart';
import 'package:Soc/src/services/google_authentication.dart';
import 'package:Soc/src/services/user_profile.dart';
import 'package:flutter/material.dart';

class PlusSplashScreen extends StatefulWidget {
  const PlusSplashScreen({Key? key}) : super(key: key);

  @override
  State<PlusSplashScreen> createState() => _PlusSplashScreenState();
}

class _PlusSplashScreenState extends State<PlusSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: googlesignin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasData) {
          return _buildSplashScreen();
        } else if (snapshot.hasData) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Future<bool> googlesignin() async {
    List<UserInformation> _profileData =
        await UserGoogleProfile.getUserProfile();
    var result = await Authentication.refreshAuthenticationToken(
        refreshToken: _profileData[0].refreshToken);
    return true;
  }

  Widget _buildSplashScreen() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              Globals.themeType == 'Dark'
                  ? 'assets/images/graded+_light.png'
                  : 'assets/images/graded+_dark.png',
              fit: BoxFit.cover,
              //    height: 50,
            )));
  }
}
