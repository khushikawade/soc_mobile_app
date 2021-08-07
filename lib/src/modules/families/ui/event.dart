import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/families/bloc/family_bloc.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class EventPage extends StatefulWidget {
  EventPage(
      {required this.isbuttomsheet,
      required this.appBarTitle,
      required this.language});
  String? language;
  bool? isbuttomsheet;
  String? appBarTitle;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  static const double _kLabelSpacing = 15.0;
  FamilyBloc _eventBloc = FamilyBloc();

  @override
  void initState() {
    super.initState();
    _eventBloc.add(CalendarListEvent());
  }

  Widget _buildList(list, int index, mainObj) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SliderWidget(
                      obj: mainObj,
                      issocialpage: false,
                      iseventpage: true,
                      currentIndex: index,
                      date: '',
                      isbuttomsheet: true,
                      language: Globals.selectedLanguage,
                    )));
      },
      child: Container(
          decoration: BoxDecoration(
            border: (index % 2 == 0)
                ? Border.all(color: Theme.of(context).colorScheme.background)
                : Border.all(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(0.0),
            color: (index % 2 == 0)
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.secondary,
          ),
          child: Container(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: _kLabelSpacing * 1,
                    vertical: _kLabelSpacing / 2),
                child: ListTile(
                  leading: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        widget.language != null && widget.language != "English"
                            ? TranslationWidget(
                                message:
                                    Utility.convertDateFormat(list.startDate!)
                                        .toString()
                                        .substring(0, 2),
                                toLanguage: Globals.selectedLanguage,
                                fromLanguage: "en",
                                builder: (translatedMessage) => Text(
                                  translatedMessage.toString(),
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              )
                            : Text(
                                Utility.convertDateFormat(list.startDate!)
                                    .toString()
                                    .substring(0, 2),
                                style: Theme.of(context).textTheme.headline5,
                              ),
                        Globals.selectedLanguage != null &&
                                Globals.selectedLanguage != "English"
                            ? TranslationWidget(
                                message:
                                    Utility.getMonthFromDate(list.startDate!)
                                        .toString()
                                        .split("/")[1],
                                toLanguage: Globals.selectedLanguage,
                                fromLanguage: "en",
                                builder: (translatedMessage) => Text(
                                  translatedMessage.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(
                                          fontWeight: FontWeight.normal,
                                          height: 1.5),
                                ),
                              )
                            : Expanded(
                                child: Text(
                                  Utility.getMonthFromDate(list.startDate!)
                                      .toString()
                                      .split("/")[1],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .copyWith(
                                          fontWeight: FontWeight.normal,
                                          height: 1.5),
                                ),
                              )
                      ],
                    ),
                  ),
                  title: Globals.selectedLanguage != null &&
                          Globals.selectedLanguage != "English"
                      ? TranslationWidget(
                          message: list.titleC!,
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        )
                      : Text(
                          list.titleC ?? '-',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                  subtitle: Globals.selectedLanguage != null &&
                          Globals.selectedLanguage != "English"
                      ? TranslationWidget(
                          message: Utility.convertDateFormat(list.startDate!) +
                              " - " +
                              Utility.convertDateFormat(list.endDate!),
                          toLanguage: Globals.selectedLanguage,
                          fromLanguage: "en",
                          builder: (translatedMessage) => Text(
                            translatedMessage.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(
                                    fontWeight: FontWeight.normal, height: 1.5),
                          ),
                        )
                      : Text(
                          Utility.convertDateFormat(list.startDate!) +
                              " - " +
                              Utility.convertDateFormat(list.endDate!),
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(
                                  fontWeight: FontWeight.normal, height: 1.5),
                        ),
                )),
          )),
    );
  }

  Widget _buildHeading(String tittle) {
    return Container(
      padding: EdgeInsets.only(
          top: _kLabelSpacing / 1.5, bottom: _kLabelSpacing / 1.5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(
            width: 0,
          ),
          color: Theme.of(context).colorScheme.secondary),
      child: Padding(
        padding: const EdgeInsets.only(left: _kLabelSpacing),
        child: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English"
            ? TranslationWidget(
                message: tittle,
                toLanguage: Globals.selectedLanguage,
                fromLanguage: "en",
                builder: (translatedMessage) => Text(
                    translatedMessage.toString(),
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              )
            : Text(tittle,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Theme.of(context).colorScheme.primary)),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        appBarTitle: widget.appBarTitle!,
        isSearch: true,
        isShare: false,
        sharedpopUpheaderText: "",
        sharedpopBodytext: "",
        language: Globals.selectedLanguage,
      ),
      body: SafeArea(
          child: BlocBuilder<FamilyBloc, FamilyState>(
              bloc: _eventBloc,
              builder: (BuildContext contxt, FamilyState state) {
                if (state is FamilyLoading) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator());
                } else if (state is CalendarListSuccess) {
                  return Column(children: [
                    _buildHeading("Upcoming"),
                    Container(
                      child: Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: state.obj!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return state.obj!.length > 0
                                ? _buildList(
                                    state.obj![index], index, state.obj)
                                : Globals.selectedLanguage != null &&
                                        Globals.selectedLanguage != "English"
                                    ? TranslationWidget(
                                        message: "No data found",
                                        toLanguage: Globals.selectedLanguage,
                                        fromLanguage: "en",
                                        builder: (translatedMessage) => Text(
                                          translatedMessage.toString(),
                                        ),
                                      )
                                    : Center(child: Text("No data found"));
                          },
                        ),
                      ),
                    ),
                  ]);
                } else if (state is ErrorLoading) {
                  return Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Globals.selectedLanguage != null &&
                            Globals.selectedLanguage != "English"
                        ? TranslationWidget(
                            message: "Unable to load the data",
                            toLanguage: Globals.selectedLanguage,
                            fromLanguage: "en",
                            builder: (translatedMessage) => Text(
                              translatedMessage.toString(),
                            ),
                          )
                        : Text("Unable to load the data"),
                  );
                } else {
                  return Container();
                }
              })),
    );
  }
}
