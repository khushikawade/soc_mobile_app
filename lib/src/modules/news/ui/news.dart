import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/ui/app_bar_widget.dart';
import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/translator/translation_widget.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  static const double _kIconSize = 48.0;
  static const double _kLabelSpacing = 20.0;
  NewsBloc bloc = new NewsBloc();
  var object;
  String newsTimeStamp = '';

  @override
  void initState() {
    super.initState();
    bloc.add(FetchNotificationList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildListItems(obj, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _kLabelSpacing,
        vertical: _kLabelSpacing / 2,
      ),
      color: (index % 2 == 0)
          ? Theme.of(context).backgroundColor
          : Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SliderWidget(
                        obj: object,
                        currentIndex: index,
                        issocialpage: false,
                        iseventpage: false,
                        date: "$newsTimeStamp",
                        isbuttomsheet: true,
                        language: Globals.selectedLanguage,
                      )));
        },
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              height: _kIconSize * 1.5,
              child: obj.image != null
                  ? ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: obj.image!,
                        height: _kIconSize * 1.5,
                        width: _kIconSize * 1.4,
                        placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )
                  : Container(
                      height: _kIconSize * 1.5,
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: Globals.homeObjet["App_Logo__c"],
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            width: _kIconSize * 1.4,
                            height: _kIconSize * 1.5,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              width: _kLabelSpacing / 2,
            ),
            Expanded(
              flex: 5,
              child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildnewsHeading(obj),
                        // SizedBox(height: _kLabelSpacing / 3),
                        // Container(child: _buildTimeStamp(obj)),
                        // SizedBox(height: _kLabelSpacing / 4),
                      ])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildnewsHeading(obj) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Globals.selectedLanguage != null &&
                Globals.selectedLanguage != "English"
            ? TranslationWidget(
                message: obj.contents["en"] ?? '-',
                fromLanguage: "en",
                toLanguage: Globals.selectedLanguage,
                builder: (translatedMessage) => Text(
                  // obj.titleC.toString(),
                  translatedMessage.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              )
            : Text(
                obj.contents["en"] ?? '-',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline4,
              ));
  }

  // Widget _buildTimeStamp(NotificationList obj) {
  //   DateTime now = DateTime.now(); //REPLACE WITH ACTUAL DATE
  //   newsTimeStamp = DateFormat('yyyy/MM/dd').format(now);
  //   return Container(
  //       child: Text(
  //     "${newsTimeStamp}",
  //     style: Theme.of(context).textTheme.subtitle1,
  //   ));
  // }

  Widget _buildList(obj) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: obj.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildListItems(obj[index], index);
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder(
                bloc: bloc,
                builder: (BuildContext context, NewsState state) {
                  if (state is NewsLoaded) {
                    return state.obj != null && state.obj!.length > 0
                        ? _buildList(state.obj)
                        : Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Globals.selectedLanguage != null &&
                                    Globals.selectedLanguage != "English"
                                ? TranslationWidget(
                                    message: "No news found",
                                    toLanguage: Globals.selectedLanguage,
                                    fromLanguage: "en",
                                    builder: (translatedMessage) =>
                                        Text(translatedMessage))
                                : Text("No news found"),
                          );
                  } else if (state is NewsLoading) {
                    return Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  } else if (state is NewsErrorReceived) {
                    return Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Globals.selectedLanguage != null &&
                              Globals.selectedLanguage != "English"
                          ? TranslationWidget(
                              message: "Unable to load the data",
                              toLanguage: Globals.selectedLanguage,
                              fromLanguage: "en",
                              builder: (translatedMessage) =>
                                  Text(translatedMessage))
                          : Text("Unable to load the data"),
                    );
                  } else if (state is NewsLoading) {
                    return Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  } else if (state is NewsErrorReceived) {
                    return Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Text("Unable to load the data"),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
            BlocListener<NewsBloc, NewsState>(
              bloc: bloc,
              listener: (context, state) async {
                if (state is NewsLoaded) {
                  object = state.obj;
                }
              },
              child: Container(),
            ),
          ],
        ));
  }
}
