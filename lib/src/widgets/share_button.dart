import 'package:Soc/src/modules/setting/settiings/ui/appshare.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ButtonWidget extends StatelessWidget {
  static const double _kLabelSpacing = 17.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_kLabelSpacing),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShareApp(),
                  ),
                );
              },
              child: Text("Share this app"),
            ),
          ),
          SizedBox(
            width: _kLabelSpacing / 2,
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () => _onShareWithEmptyOrigin(context),
              child: Text("I need support"),
            ),
          ),
        ],
      ),
    );
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    await Share.share("text");
  }
}
