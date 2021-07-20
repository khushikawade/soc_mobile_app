import 'package:Soc/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutusPage extends StatefulWidget {
  String htmlText;

  @override
  AboutusPage({
    Key? key,
    required this.htmlText,
  }) : super(key: key);
  @override
  _AboutusPageState createState() => _AboutusPageState();
}

class _AboutusPageState extends State<AboutusPage> {
  static const double _kLabelSpacing = 20.0;

  Widget _buildContent1() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _kLabelSpacing),
      child: Wrap(
        children: [
          Html(
            data: widget.htmlText,
            style: {
              "table": Style(
                backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
              ),
              "tr": Style(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              "th": Style(
                padding: EdgeInsets.all(6),
                backgroundColor: Colors.grey,
              ),
              "td": Style(
                padding: EdgeInsets.all(6),
                alignment: Alignment.topLeft,
              ),
              'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
            },
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBarWidget(
          isnewsDescription: false,
        ),
        body: SingleChildScrollView(
          child: _buildContent1(),
        ),
      ),
    );
  }
}
