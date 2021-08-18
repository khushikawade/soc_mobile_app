import 'package:Soc/oss_licenses.dart';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/setting/licencedetail.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/error_message_widget.dart';
import 'package:Soc/src/widgets/no_data_found_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Licenceinfo extends StatefulWidget {
  Licenceinfo({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;
  @override
  _LicenceinfoState createState() => _LicenceinfoState();
}

class _LicenceinfoState extends State<Licenceinfo> {
  static const double _kLabelSpacing = 20.0;
  FocusNode myFocusNode = new FocusNode();
  OSSLicensesInfo obj = new OSSLicensesInfo();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final HomeBloc _homeBloc = new HomeBloc();
  var _list;
  @override
  void initState() {
    super.initState();
    _list = obj.ossLicenses.values.toList();
  }

  Widget _buildList(
    list,
    int index,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LicenceDetailPage(
                      index: index,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          border: (index % 2 == 0)
              ? Border.all(color: Theme.of(context).backgroundColor)
              : Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(0.0),
          color: (index % 2 == 0)
              ? Theme.of(context).backgroundColor
              : Theme.of(context).colorScheme.secondary,
        ),
        child: Container(
            child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: _kLabelSpacing * 1, vertical: _kLabelSpacing),
          child: Globals.selectedLanguage != null &&
                  Globals.selectedLanguage != "English"
              ? TranslationWidget(
                  message: list[index]["name"] ?? '-',
                  fromLanguage: "en",
                  toLanguage: Globals.selectedLanguage,
                  builder: (translatedMessage) => Text(
                    translatedMessage,
                    style: Theme.of(context).textTheme.headline2!,
                    textAlign: TextAlign.start,
                  ),
                )
              : Text(
                  list[index]["name"] ?? '-',
                  style: Theme.of(context).textTheme.headline2!,
                ),
        )),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          isSearch: false,
          isShare: false,
          appBarTitle: "Open Source Licence",
          sharedpopUpheaderText: '',
          sharedpopBodytext: '',
          language: Globals.selectedLanguage,
        ),
        body: SafeArea(
          child: RefreshIndicator(
            key: refreshKey,
            child: Column(children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 20),
                  scrollDirection: Axis.vertical,
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _list.length > 0
                        ? _buildList(
                            _list,
                            index,
                          )
                        : NoDataFoundErrorWidget();
                  },
                ),
              ),
              Container(
                height: 0,
                width: 0,
                child: BlocListener<HomeBloc, HomeState>(
                  bloc: _homeBloc,
                  listener: (context, state) async {
                    if (state is BottomNavigationBarSuccess) {
                      AppTheme.setDynamicTheme(Globals.appSetting, context);
                      Globals.homeObjet = state.obj;
                      setState(() {});
                    }
                  },
                  child: Container(),
                ),
              ),
            ]),
            onRefresh: refreshPage,
          ),
        ));
  }

  Future refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchBottomNavigationBar());
  }
}
