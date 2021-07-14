import 'package:flutter/material.dart';

class StudentPage extends StatelessWidget {
  static const double _kLableSpacing = 8.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: _kLableSpacing / 2,
            mainAxisSpacing: _kLableSpacing,
            children: List.generate(Grids.length, (index) {
              return Center(
                child: SelectIcon(grid: Grids[index]),
              );
            })));
  }
}

class Grid {
  const Grid({required this.title, required this.icon});
  final String title;
  final String icon;
}

const List<Grid> Grids = const <Grid>[
  const Grid(title: 'Request', icon: 'assets/images/request_img.png'),
  const Grid(title: 'Graduation', icon: 'assets/images/graduation.png'),
  const Grid(title: 'Google Class', icon: 'assets/images/googleclassroom.png'),
  const Grid(title: 'Classdojo', icon: 'assets/images/classdojo.png'),
  const Grid(title: 'PupilPath', icon: 'assets/images/pupilpath.png'),
  const Grid(title: 'Meets', icon: 'assets/images/meet.png'),
  const Grid(title: 'Zoom', icon: 'assets/images/Zoom.png'),
  const Grid(title: 'IXL', icon: 'assets/images/IXL.png'),
  const Grid(title: 'PBS Kids', icon: 'assets/images/PBS_kids_img.png'),
  const Grid(title: 'EDpuzzle', icon: 'assets/images/Edpuzzle.png'),
  const Grid(title: 'PearDeck', icon: 'assets/images/PearDeack.png'),
  const Grid(title: 'NearPod', icon: 'assets/images/nearpod.png'),
];

class SelectIcon extends StatelessWidget {
  const SelectIcon({required this.grid});
  final Grid grid;
  static const double _kIconSize = 105.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: Image.asset(
                  grid.icon,
                  fit: BoxFit.cover, // this is the solution for border
                  width: _kIconSize,
                  height: _kIconSize,
                ),
              ),
              Text(grid.title, style: Theme.of(context).textTheme.caption),
            ]),
      ),
    );
  }
}
