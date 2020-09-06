import 'package:flutter/material.dart';
import 'package:sudoku/utilities/solveSudoku.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:collection/collection.dart' show DeepCollectionEquality;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController controller2;
  Animation<Color> _BorderColorAnim;
  Animation<Color> _WrongColorAnim;
  int cellSelected = -1;
  bool isCellEdit = false;
  bool isSubmit = false;
  bool ans = false;
  var blankPos = [];
  List<int> selectedIndexList = new List<int>();
  Function equal = const DeepCollectionEquality().equals;
  var board = [
    [7, 8, 0, 4, 0, 0, 1, 2, 0],
    [6, 0, 0, 0, 7, 5, 0, 0, 9],
    [0, 0, 0, 6, 0, 1, 0, 7, 8],
    [0, 0, 7, 0, 4, 0, 2, 6, 0],
    [0, 0, 1, 0, 5, 0, 9, 3, 0],
    [9, 0, 4, 0, 6, 0, 0, 0, 5],
    [0, 7, 0, 3, 0, 0, 0, 1, 2],
    [1, 2, 0, 0, 0, 7, 4, 0, 0],
    [0, 4, 9, 2, 0, 6, 0, 0, 7]
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] == 0) {
          blankPos.add(9 * i + j);
        }
      }
    }
    controller = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    controller2 =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _BorderColorAnim =
        RainbowColorTween([Colors.blue, Colors.green, Colors.red, Colors.blue])
            .animate(controller)
              ..addListener(() {
                setState(() {});
              })
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  controller.reset();
                  controller.forward();
                } else if (status == AnimationStatus.dismissed) {
                  controller.forward();
                }
              });
    _WrongColorAnim =
        RainbowColorTween([Colors.blue, Colors.red]).animate(controller2)
          ..addListener(() {
            setState(() {
              // isSubmit = false;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller2.reset();
              controller2.forward();
            } else if (status == AnimationStatus.dismissed) {
              controller2.reset();
              // isSubmit = false;
            }
          });
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Widget _buildControlButton({String label, VoidCallback onPress}) {
    return RaisedButton(
      color: Colors.black,
      splashColor: Colors.white,
      elevation: 10,
      onPressed: onPress,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.blue, width: 3),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildCell({int index}) {
    int i, j;
    i = index ~/ 9;
    j = index % 9;

    return GestureDetector(
      onTap: () {
        setState(() {
          ans = false;
          isSubmit = false;
          controller2.reset();
        });
        if (isCellEdit) {
          print('$i $j');
        }

        setState(() {
          if (!(cellSelected == index)) {
            cellSelected = index;
          } else {
            cellSelected = -1;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(4),
        child: Center(
          child: board[i][j] != 0
              ? Text(
                  "${board[i][j]}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              : Text(""),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSubmit
                ? ans ? Colors.lightBlue : _WrongColorAnim.value
                : Colors.lightBlue,
          ),
          color: blankPos.contains(9 * i + j)
              ? board[i][j] >= 0
                  ? cellSelected == index
                      ? Colors.deepPurple
                      : board[i][j] > 0 ? Colors.green : Colors.black
                  : Colors.red
              : Colors.blue,
        ),
      ),
    );
  }

  Widget _buildNumCell({int index}) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.lightBlue, width: 2.0),
        ),
        onPressed: () {
          if (cellSelected >= 0) {
            int i = cellSelected ~/ 9;
            int j = cellSelected % 9;
            setState(() {
              if (blankPos.contains(9 * i + j)) {
                board[i][j] = index;
              }
            });
          }

          print('${index + 1}');
        },
        child: index != 0
            ? Text(
                '${index}',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            : Icon(Icons.highlight_off),
      ),
    );
  }

  Widget _buildNumBar() {
    return blankPos.contains(cellSelected)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                // color: Colors.red,
                height: 70,
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return _buildNumCell(index: index);
                    }),
              ),
            ],
          )
        : isSubmit
            ? Center(
                child: Container(
                child: ans
                    ? Text(
                        'Correct',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 40,
                        ),
                      )
                    : Text(
                        "Wrong",
                        style: TextStyle(
                          color: _WrongColorAnim.value,
                          fontSize: 40,
                        ),
                      ),
              ))
            : Container();
  }

  Widget _buildSudokuTable() {
    return Container(
      // color: Colors.black,
      // height: MediaQuery.of(context).size.width + 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(color: Colors.white, width: 3),
        border: Border.all(
            color: isSubmit
                ? ans ? Colors.green : _WrongColorAnim.value
                : Colors.white,
            width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20.0,
            spreadRadius: 4.0,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              // scrollDirection: Axis.horizontal,
              primary: false,
              itemCount: 81,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              padding: EdgeInsets.all(20),
              itemBuilder: (BuildContext context, int index) {
                return _buildCell(index: index);
              },
            ),
          ),
          Expanded(
            child: Container(
              // color: Colors.blue,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildControlButton(
                    label: 'Solve',
                    onPress: () {
                      controller2.reset();
                      setState(() {
                        cellSelected = -1;
                        solve(board);
                      });
                    },
                  ),
                  _buildControlButton(
                    label: 'Submit',
                    onPress: () {
                      solve(Board);
                      if (equal(board, Board)) {
                        ans = true;
                        isSubmit = true;
                        print("Correct");
                      } else {
                        ans = false;
                        isSubmit = true;
                        controller2.forward();
                        print("Wrong");
                        setState(() {
                          cellSelected = -1;
                        });
                      }
                    },
                  ),
                  _buildControlButton(
                    label: 'Reset',
                    onPress: () {
                      setState(() {
                        cellSelected = -1;
                        controller2.reset();
                        ans = false;
                        isSubmit = false;
                        for (int i = 0; i < blankPos.length; i++) {
                          int x = blankPos[i] ~/ 9;
                          int y = blankPos[i] % 9;
                          board[x][y] = 0;
                          cellSelected = -1;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          _buildControlButton(
            label: 'Backtrack ',
            onPress: () {
              cellSelected = -1;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'SUDOKU',
          style: TextStyle(color: _BorderColorAnim.value),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Colors.lightBlue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildNumBar()),
            Expanded(flex: 5, child: _buildSudokuTable()),
            Expanded(child: _buildNumBar()),
          ],
        ),
      ),
    );
  }
}
