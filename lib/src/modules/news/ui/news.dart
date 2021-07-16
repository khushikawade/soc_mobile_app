import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  static const double _kLabelSpacing = 20.0;
  NewsBloc bloc = new NewsBloc();
  @override
  void initState() {
    super.initState();
    bloc.add(FetchNotificationList());
  }

  _launchURL(obj) async {
    if (obj.url != null && obj.url != "") {
      // print("${obj.url}++++++++++++++++++++++++++++++++++++++");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: obj.headings,
                    url: obj.url!,
                  )));
    } else {
      throw 'Could not launch ${obj.url}';
    }
  }

  Widget _buildListItems(NotificationList obj) {
    return InkWell(
      onTap: () {
        _launchURL(obj);
      },
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 3),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildnewsHeading(obj),
                SizedBox(height: _kLabelSpacing / 3),
                _buildTimeStamp(obj),
                SizedBox(height: _kLabelSpacing / 4),
              ])),
    );
  }

  Widget _buildnewsHeading(NotificationList obj) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            width: MediaQuery.of(context).size.width * .88,
            child: Text(
              obj.contents["en"].toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context).textTheme.headline4,
            )),
      ],
    );
  }

  Widget _buildTimeStamp(NotificationList obj) {
    DateTime now = DateTime.now(); //REPLACE WITH ACTUAL DATE
    String newsTimeStamp = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            child: Text(
          "${newsTimeStamp}",
          style: Theme.of(context).textTheme.subtitle1,
        )),
      ],
    );
  }

// DIVIDER
  Widget divider() {
    return Container(
      height: 0.4,
      decoration: BoxDecoration(
        color: Color(0xff979AA6),
      ),
    );
  }

  Widget _buildList(obj) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return divider();
      },
      itemCount: obj.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItems(obj[index]);
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder(
                  bloc: bloc,
                  builder: (BuildContext context, NewsState state) {
                    if (state is NewsLoaded) {
                      return state.obj != null
                          ? _buildList(state.obj)
                          : Center(
                              child: Text("No Data found"),
                            );
                    } else if (state is NewsLoading) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                        )),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
