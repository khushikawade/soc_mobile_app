import 'package:app/src/locale/app_translations.dart';
import 'package:app/src/modules/home/ui/drawer.dart';
import 'package:app/src/modules/news/ui/newsdescription.dart';
import 'package:app/src/styles/theme.dart';
import 'package:app/src/widgets/customerappbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  static const double _kLabelSpacing = 20.0;

  //STYLE
  static const _knewsHeadingtStyle = TextStyle(
      height: 1.5,
      fontFamily: "Roboto Regular",
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppTheme.kAccentColor);

  static const _kTimeStampStyle = TextStyle(
      fontFamily: "Roboto Regular", fontSize: 13, color: AppTheme.kAccentColor);

//UI WIDGETS

  Widget _buildListItems(int index) {
    int itemsLength = 10; // Replace with Actual Item Count
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewsDescription()));
      },
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: _kLabelSpacing, vertical: _kLabelSpacing / 3),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildnewsHeading(),
                SizedBox(height: _kLabelSpacing / 3),
                _buildTimeStamp(),
                SizedBox(height: _kLabelSpacing / 4),
              ])),
    );
  }

  Widget _buildnewsHeading() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            width: MediaQuery.of(context).size.width * .88,
            child: Text(
              // REPLACE  WITH REAL  NEWS
              "Check out these book suggestions for your summer by  this books  you can improve our genral knowledge !",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: _knewsHeadingtStyle,
            )),
      ],
    );
  }

  Widget _buildTimeStamp() {
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
          style: _kTimeStampStyle,
        )),
      ],
    );
  }

// DIVIDER
  Widget divider() {
    return Container(
      height: 0.6,
      decoration: BoxDecoration(
        color: Color(0xff979AA6),
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return divider();
      },
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItems(index);
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
              _buildList(),
            ],
          ),
        ),
      ),
    );
  }
}
