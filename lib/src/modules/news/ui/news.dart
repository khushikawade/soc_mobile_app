import 'package:Soc/src/modules/news/bloc/news_bloc.dart';
import 'package:Soc/src/modules/news/model/notification_list.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/sliderpagewidget.dart';
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
  var object;
  String newsTimeStamp = '';

  @override
  void initState() {
    super.initState();
    bloc.add(FetchNotificationList());
  }

  Widget _buildListItems(obj, index) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => Newdescription(
        //               obj: obj,
        //               date: newsTimeStamp,
        //             )));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SliderWidget(
                      obj: object,
                      currentIndex: index,
                      issocialpage: false,
                      date: newsTimeStamp,
                    )));
      },
      child: Container(
          padding: EdgeInsets.symmetric(
              vertical: _kLabelSpacing / 3, horizontal: _kLabelSpacing),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildnewsHeading(obj),
                SizedBox(height: _kLabelSpacing / 3),
                Container(child: _buildTimeStamp(obj)),
                SizedBox(height: _kLabelSpacing / 4),
              ])),
    );
  }

  Widget _buildnewsHeading(NotificationList obj) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                obj.contents["en"],
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline4,
              )),
        ),
      ],
    );
  }

  Widget _buildTimeStamp(NotificationList obj) {
    DateTime now = DateTime.now(); //REPLACE WITH ACTUAL DATE
    newsTimeStamp = DateFormat('yyyy/MM/dd').format(now);
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
        color: AppTheme.kDividerColor,
      ),
    );
  }

  Widget _buildList(obj) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return divider();
      },
      itemCount: obj.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItems(obj[index], index);
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
                          backgroundColor: Theme.of(context).accentColor,
                        )),
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
          ),
        ),
      ),
    );
  }
}
