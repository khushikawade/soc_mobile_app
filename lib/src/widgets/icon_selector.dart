import 'package:flutter/material.dart';

class IconSelectorWidget extends StatelessWidget {
  final icon;
  final String iconType;
  IconSelectorWidget(this.icon, this.iconType);
  
  Widget _iconBuilder(icon, iconType){
    if(iconType == 'asset'){
      return Image.asset('assets/images/image-icons/$icon.png');
    }else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _iconBuilder(icon, iconType);
  }
}