import 'package:Soc/src/modules/families/Submodule/resource/modal/resourcemodal.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/app_bar.dart';
import 'package:Soc/src/widgets/customList.dart';
import 'package:Soc/src/widgets/inapp_url_launcher.dart';

import 'package:Soc/src/widgets/searchfield.dart';
import 'package:flutter/material.dart';

class Resources extends StatefulWidget {
  @override
  _ResourcesState createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  static const double _kLabelSpacing = 17.0;

  FocusNode myFocusNode = new FocusNode();
  // final TextStyle _kheadingStyle = TextStyle(
  //   height: 1.5,
  //   fontFamily: "Roboto Medium",
  //   fontSize: 16,
  //   color: AppTheme.kFontColor2,
  // );

  // final TextStyle formtextStyle = TextStyle(
  //   fontFamily: "Roboto Regular",
  //   fontSize: 14,
  //   color: AppTheme.kAccentColor,
  // );

  static const List<ResourcesModal> ResourcesList = const <ResourcesModal>[
    const ResourcesModal(
      resource: '5/24 Family Letter',
    ),
    const ResourcesModal(
      resource: 'Family Letter March 10 2021',
    ),
    const ResourcesModal(
      resource: 'SupportingFamilies During COVID-19',
    ),
    const ResourcesModal(
      resource: 'Complete Blue Card Emergency Contact',
    ),
    const ResourcesModal(
      resource: 'Complete Blue Card Emergency Contact',
    ),
  ];

  Widget _buildSearchfield() {
    return SearchFieldWidget();
  }

  Widget _buildList(int index) {
    return ListWidget(index, _buildresource(index));
  }

  Widget _buildresource(int index) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => InAppUrlLauncer(
                    title: "",
                    url: "www.google.com",
                  ))),
      child: Row(
        children: [
          Text(
            ResourcesList[index].resource,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isnewsDescription: false,
        isnewsSearchPage: false,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchfield(),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return _buildList(index);
                },
              ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
