import 'package:flutter/material.dart';

class CommonButtonWidget extends StatelessWidget {
  final String buttonText;
  final ValueChanged? onTap;
  final bool? isLoading;
  CommonButtonWidget(
      {Key? key, required this.buttonText, this.onTap, this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Material(
    //     elevation: 8,
    //     color: Colors.transparent,
    //     child: InkWell(
    //       onTap: () {
    //         FocusScopeNode currentFocus = FocusScope.of(context);
    //         if (!currentFocus.hasPrimaryFocus) {
    //           currentFocus.unfocus();
    //         }
    //         onTap(true);
    //       },
    //       child: Container(
    //         height: 60,
    //         width: MediaQuery.of(context).size.width,
    //         child: Container(
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(5),
    //                 gradient: LinearGradient(
    //                     stops: [0.1, 1],
    //                     begin: Alignment.topLeft,
    //                     end: Alignment.bottomRight,
    //                     colors: [
    //                       Theme.of(context).primaryColor.withOpacity(0.7),
    //                       Theme.of(context).primaryColor,
    //                     ])),
    //             padding: EdgeInsets.only(right: 3, left: 17),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: <Widget>[
    //                 Row(
    //                   children: <Widget>[
    //                     Text(
    //                       "$buttonText",
    //                       style: TextStyle(
    //                           color: Theme.of(context)
    //                               .buttonTheme
    //                               .colorScheme
    //                               .onSurface,
    //                           fontWeight: FontWeight.bold),
    //                     ),
    //                   ],
    //                 ),
    //                 Padding(
    //                     padding: const EdgeInsets.all(5.0),
    //                     child: isLoading != null && isLoading
    //                         ? Padding(
    //                             padding: EdgeInsets.only(right: 7),
    //                             child: Container(
    //                               height: 21,
    //                               width: 21,
    //                               child: CircularProgressIndicator(
    //                                   strokeWidth: 2,
    //                                   valueColor:
    //                                       new AlwaysStoppedAnimation<Color>(
    //                                     Theme.of(context)
    //                                         .buttonTheme
    //                                         .colorScheme
    //                                         .onSurface,
    //                                   )),
    //                             ),
    //                           )
    //                         : Row(
    //                             children: [
    //                               SizedBox(
    //                                 width: 3,
    //                                 child: Divider(
    //                                   color: Theme.of(context)
    //                                       .buttonTheme
    //                                       .colorScheme
    //                                       .onSurface,
    //                                   thickness: 3,
    //                                 ),
    //                               ),
    //                               Icon(
    //                                 Icons.arrow_forward,
    //                                 color: Theme.of(context)
    //                                     .buttonTheme
    //                                     .colorScheme
    //                                     .onSurface,
    //                               ),
    //                             ],
    //                           ))
    //                 // Icon(
    //                 //   Icons.arrow_forward,
    //                 //   color: overrides.whiteColor,
    //                 //   size: 28.0,
    //                 //   semanticLabel: 'Text to announce in accessibility modes',
    //                 // ),
    //               ],
    //             )),
    //       ),
    //     ),
    //   ),
    // );

    return ElevatedButton(
      // child: Text("$buttonText"),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$buttonText',
          ),
          isLoading != null && isLoading!
              ? Container(
                  margin: EdgeInsets.only(left: 15),
                  height: 20,
                  width: 20,
                  // padding: EdgeInsets.all(1),
                  child: CircularProgressIndicator(
                      strokeWidth: 1,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimary)),
                )
              : Container(),
        ],
      ),
      onPressed: () {
        onTap!(true);
      },

      // shape: new RoundedRectangleBorder(
      //   borderRadius: new BorderRadius.circular(5.0),
      // ),
    );
  }
}
