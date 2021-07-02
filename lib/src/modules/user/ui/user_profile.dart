import 'package:app/src/modules/user/bloc/user_bloc.dart';
import 'package:app/src/modules/user/ui/login.dart';
import 'package:app/src/services/custom_flutter_icons.dart';
import 'package:app/src/services/utility.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/app_bar_with_overlapped_body.dart';
import 'package:app/src/widgets/back_button_widget.dart';
import 'package:app/src/widgets/icon_selector.dart';
import 'package:app/src/widgets/models/custom_app_bar.dart';
import 'package:app/src/widgets/spacer_widget.dart';
import 'package:app/src/widgets/profile_picture_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserBloc _bloc = new UserBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _profileCard() => Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(CustomFlutterIcons.edit),
                        onPressed: () {},
                        iconSize: 18,
                        color: Theme.of(context).iconTheme.color,
                      )),
                  SpacerWidget(16.0),
                  Text(
                    "John Doe",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: AppTheme.kFontColor1),
                  ),
                  SpacerWidget(8.0),
                  Text(
                    "Team bedrijfsbureau",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: AppTheme.kSecondaryColor),
                  ),
                  SizedBox(
                    height: 40,
                    child: ListTile(
                      leading: Icon(CustomFlutterIcons.call),
                      title: Text('212-000-668'),
                    ),
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Icon(
                        CustomFlutterIcons.email,
                        size: 18,
                      ),
                    ),
                    title: Text('john.doe@gmail.com'),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ProfilePictureWidget(
              url:
                  'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50.jpg',
              radius: 86.0,
            ),
          ),
        ],
      );

  Widget _body() => Container(
      padding: const EdgeInsets.only(
          left: AppTheme.kBodyPadding, right: AppTheme.kBodyPadding),
      width: Utility.displayWidth(context),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _profileCard(),
            SpacerWidget(10),
            Card(
              child: ListTile(
                title: Text('Push-meldingen',
                    style: Theme.of(context).textTheme.caption),
              ),
            ),
            SpacerWidget(10),
            Card(
              child: ListTile(
                title: Text(
                  'Wachtwoord wijzigen',
                  style: Theme.of(context).textTheme.caption,
                ),
                trailing: IconSelectorWidget('change_password_icon', 'asset'),
              ),
            ),
            SpacerWidget(10),
            Card(
              child: ListTile(
                title: Text('Uitloggen',
                    style: Theme.of(context).textTheme.caption),
                trailing: IconSelectorWidget('logout_icon', 'asset'),
                onTap: () {
                  _bloc.add(LogOut());
                },
              ),
            ),
            BlocListener<UserBloc, UserState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is LoggedOut) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      ModalRoute.withName('/'));
                }
                if (state is ErrorReceived) {
                  if (state.err != null && state.err != "") {
                    Utility.showSnackBar(_scaffoldKey, "${state.err}", context);
                  }
                }
              },
              child: Container(),
            )
          ],
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return OverlappedAppBar(
      scaffoldKey: _scaffoldKey,
      customAppBar: CustomAppBar(leading: BackButtonWidget()),
      topOverFlow: 90,
      body: _body(),
    );
  }
}
