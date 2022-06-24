import 'package:Soc/src/modules/ocr/modal/user_info.dart';
import 'package:Soc/src/services/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../globals.dart';
import '../../../styles/theme.dart';
import '../../../translator/translation_widget.dart';

class CustomDialogBox extends StatefulWidget {
  final UserInformation? profileData;

  const CustomDialogBox({Key? key, this.profileData}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height*0.3,
          width:  MediaQuery.of(context).size.width*0.8,
          padding: EdgeInsets.only(left: 20,top: 45
              + 20, right: 20,bottom: 20
          ),
          margin: EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xff000000) !=
                                  Theme.of(context).backgroundColor
                              ? Color(0xffF7F8F9)
                              : Color(0xff111C20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                            color: AppTheme.kSelectedColor,
                          ),
            boxShadow: [
              BoxShadow(color: Colors.black,offset: Offset(0,10),
              blurRadius: 10
              ),
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Utility.textWidget(context: context, text: widget.profileData!.userName!.replaceAll("%20", " "),textTheme:  Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(fontWeight: FontWeight.bold,color: Color(0xff000000) ==
                                  Theme.of(context).backgroundColor
                              ? Color(0xffFFFFFF)
                              : Color(0xff000000),),),
              SizedBox(height: 10,),
              Utility.textWidget(context: context, text:  widget.profileData!.userEmail!,textTheme:Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: Colors.grey.shade500,
                                  )),
              SizedBox(height: 22,),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width*0.4,
                child: ElevatedButton(
                
                          child: TranslationWidget(
                              message: "Sign Out",
                              fromLanguage: "en",
                              toLanguage: Globals.selectedLanguage,
                              builder: (translatedMessage) {
                                return Text(translatedMessage.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                          color: Color(0xff000000) ==
                                    Theme.of(context).backgroundColor
                                ? Color(0xffFFFFFF)
                                : Color(0xff000000),));
                                
                              }),
                              style: ElevatedButton.styleFrom (
                                shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
         primary: AppTheme.kSelectedColor
           ),
                          onPressed: () {
                            //Globals.iscameraPopup = false;
                                                    },
                        ),
              ),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: FlatButton(
              //       onPressed: (){
              //         Navigator.of(context).pop();
              //       },
              //       child: Text(widget.text,style: TextStyle(fontSize: 18),)),
              // ),
            ],
          ),
        ),
        Positioned(
          left: 20,
            right: 20,
         child:  CircleAvatar(
              backgroundColor: AppTheme.kSelectedColor,
              radius: 52,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 90,
              child: ClipRRect(
                
                borderRadius: BorderRadius.all(Radius.circular(90),),
                
                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    imageUrl: widget.profileData!.profilePicture!,
                                    placeholder: (context, url) => Center(
                                          child: CupertinoActivityIndicator(),
                                        )),
              ),),
            ),
        ),
      ],
    );
  }
}