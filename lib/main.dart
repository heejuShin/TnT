import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import './app.dart';
import './addTimeTable.dart';
import './editTimeTable.dart';
import './application.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => ApplicationState(),
        builder: (context, _) => TnT(),
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color(0xff636363),
      ),
      home: TnT(),
    );
  }
}

class myCalendar extends StatefulWidget {
  @override
  _myCalendarState createState() => _myCalendarState();
}

class _myCalendarState extends State<myCalendar> with TickerProviderStateMixin {
  ApplicationState appState = ApplicationState();
  int _selectedIndex = 0;
  // TabController _controller;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // void initState() {
  //   super.initState();
  //   _controller = TabController(vsync: this, length: 2);
  // }

  Future<void> _getDataSource() async {
    await appState.readAllProducts();

    meetings = appState.timetables;
    todolists = appState.todolist;
    todolistsWhole = appState.todolist;
  }

  List<Meeting> meetings = <Meeting>[];
  List<Schedule> todolists = <Schedule>[];
  List<Schedule> todolistsWhole = <Schedule>[];

  bool _checkbox = false;
  bool _checkbox1 = false;
  bool _checkbox2 = false;
  bool _checkbox3 = false;
  bool _isDue = false;
  final textController = TextEditingController();
  final monthController = TextEditingController();
  final dayController = TextEditingController();
  String _selectedDate = "";

  //
  // onPressed: () {
  // Navigator.pushNamed(context, '/addTimeTable');
  // },

  @override
  Widget build(BuildContext context) {
    _getDataSource();
    final List<Widget> _tabWidgets = [
      MonthlyCalendar(meetingList: meetings),
      WeeklyCalendar(meetingList: meetings),
      DailyCalendar(meetingList: meetings),
      addTimeTable()
    ];

    return Scaffold(
      body: _tabWidgets[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: 'month',
              backgroundColor: Color(0xffe0e0e0)),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'week',
              backgroundColor: Color(0xffe0e0e0)),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day),
            label: 'day',
            backgroundColor: Color(0xffe0e0e0),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'add',
              backgroundColor: Color(0xffe0e0e0)),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff636363),
        onTap: _onItemTapped,
        iconSize: 22,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
              ),
              context: context,
              builder: (context) {
                print(MediaQuery.of(context).viewInsets.bottom);
                return SingleChildScrollView(
                    child: Container(
                  // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: AddTodoScreen(),
                ));
              },
              isScrollControlled: true);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

// ??????
class MonthlyCalendar extends StatefulWidget {
  MonthlyCalendar({Key key, @required this.meetingList}) : super(key: key);
  List<Meeting> meetingList;

  @override
  _MonthlyCalendarState createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('calendar'),
        actions: [
          IconButton(
              icon: Icon(Icons.list),
              color: Color(0xff636363),
              iconSize: 28,
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    context: context,
                    builder: (context) => AddTaskScreen(),
                    isScrollControlled: true);
              }),
          IconButton(
              icon: Icon(Icons.settings),
              color: Color(0xff636363),
              iconSize: 28,
              onPressed: () {
                Navigator.pushNamed(context, '/setting');
              })
        ],
      ),
      body: Container(
        // padding: EdgeInsets.all(10),
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(widget.meetingList),
          monthViewSettings: MonthViewSettings(
            showAgenda: true,
            // appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
          ),
        ),
      ),
    );
  }
}

// ??????
class WeeklyCalendar extends StatefulWidget {
  WeeklyCalendar({Key key, @required this.meetingList}) : super(key: key);
  List<Meeting> meetingList;

  @override
  _WeeklyCalendarState createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('calendar'),
          actions: [
            IconButton(
                icon: Icon(Icons.list),
                color: Color(0xff636363),
                iconSize: 28,
                onPressed: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      context: context,
                      builder: (context) => AddTaskScreen(),
                      isScrollControlled: true);
                }),
            IconButton(
                icon: Icon(Icons.settings),
                color: Color(0xff636363),
                iconSize: 28,
                onPressed: () {})
          ],
        ),
        body: Container(
          // padding: EdgeInsets.all(10),
          child: SfCalendar(
            view: CalendarView.week,
            dataSource: MeetingDataSource(widget.meetingList),
          ),
        ));
  }
}

// ??????
class DailyCalendar extends StatefulWidget {
  DailyCalendar({Key key, @required this.meetingList}) : super(key: key);
  List<Meeting> meetingList;

  @override
  _DailyCalendarState createState() => _DailyCalendarState();
}

class _DailyCalendarState extends State<DailyCalendar> {
  bool _ischecked = false;
  bool _ischecked2 = false;
  bool _ischecked3 = false;

  TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('calendar'),
        actions: [
          IconButton(
              icon: Icon(Icons.list),
              color: Color(0xff636363),
              iconSize: 28,
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    context: context,
                    builder: (context) => AddTaskScreen(),
                    isScrollControlled: true);
              }),
          IconButton(
              icon: Icon(Icons.settings),
              color: Color(0xff636363),
              iconSize: 28,
              onPressed: () {})
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: SfCalendar(
                  view: CalendarView.day,
                  dataSource: MeetingDataSource(widget.meetingList),
                ),
              ),
//              Padding(
//                padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
//                child: Text('TODAY'),
//              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Consumer<ApplicationState>(
                        builder: (context, appState, _) => Expanded(
                          child: ListView(
                            children: appState.todolist.map((item) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                    value: _ischecked,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _ischecked = value;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      item.eventName,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        )),
                    Divider(
                      color: Colors.black45,
                    ),
//                    Padding(
//                      padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
//                      child: Text('WHOLE'),
//                    ),
                    Consumer<ApplicationState>(
                        builder: (context, appState, _) => Expanded(
                              child: ListView(
                                children: appState.todolistWhole.map((item) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Checkbox(
                                        value: _ischecked,
                                        onChanged: (value) {
                                          setState(() {
                                            _ischecked = !_ischecked;
                                          });
                                        },
                                      ),
                                      Expanded(child: Text(item.eventName)),
                                      IconButton(
                                          icon: Icon(Icons.minimize),
                                          iconSize: 13,
                                          color: Colors.blue,
                                          onPressed: () {})
                                    ],
                                  );
                                }).toList(),
                              ),
                            ))
                  ],
                ),
              )
            ],
          )),
    );
  }
}

// ??????, ?????? ?????? ???????????? ??????
class addWidget extends StatefulWidget {
  @override
  _addWidgetState createState() => _addWidgetState();
}

class _addWidgetState extends State<addWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('hello'),
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  bool _checkbox = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Container(
            child: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TabBar(
                tabs: [
                  Tab(text: "??????"),
                  Tab(text: "??????"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    ListView(
                      padding: EdgeInsets.symmetric(horizontal: 7.0),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: _checkbox,
                              onChanged: (value) {
                                setState(() {
                                  print(_checkbox);
                                  _checkbox = !_checkbox;
                                });
                              },
                            ),
                            Expanded(child: Text('OODP ????????????')),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: _checkbox,
                              onChanged: (value) {
                                setState(() {
                                  print(_checkbox);
                                  _checkbox = !_checkbox;
                                });
                              },
                            ),
                            Expanded(child: Text('????????? ?????????')),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: _checkbox,
                              onChanged: (value) {
                                setState(() {
                                  print(_checkbox);
                                  _checkbox = !_checkbox;
                                });
                              },
                            ),
                            Expanded(child: Text('????????????')),
                          ],
                        ),
                      ],
                    ),
                    ListView(
                      padding: EdgeInsets.symmetric(horizontal: 7.0),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: _checkbox,
                              onChanged: (value) {
                                setState(() {
                                  print(_checkbox);
                                  _checkbox = !_checkbox;
                                });
                              },
                            ),
                            Expanded(child: Text('????????? ????????? ?????????')),
                            IconButton(
                                icon: Icon(Icons.add),
                                iconSize: 13,
                                color: Colors.redAccent,
                                onPressed: () {})
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: _checkbox,
                              onChanged: (value) {
                                setState(() {
                                  print(_checkbox);
                                  _checkbox = !_checkbox;
                                });
                              },
                            ),
                            Expanded(child: Text('????????????')),
                            IconButton(
                                icon: Icon(Icons.add),
                                iconSize: 13,
                                color: Colors.redAccent,
                                onPressed: () {})
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: _checkbox,
                              onChanged: (value) {
                                setState(() {
                                  print(_checkbox);
                                  _checkbox = !_checkbox;
                                });
                              },
                            ),
                            Expanded(child: Text('????????? ?????????')),
                            IconButton(
                                icon: Icon(Icons.minimize),
                                iconSize: 13,
                                color: Colors.blue,
                                onPressed: () {})
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: _checkbox,
                              onChanged: (value) {
                                setState(() {
                                  print(_checkbox);
                                  _checkbox = !_checkbox;
                                });
                              },
                            ),
                            Expanded(child: Text('OODP ????????????')),
                            IconButton(
                                icon: Icon(Icons.minimize),
                                iconSize: 13,
                                color: Colors.blue,
                                onPressed: () {})
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )));
  }
}

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  TextEditingController textController = TextEditingController();
  String _selectedDate = "";
  bool _isDue = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15.0),
        height: 140,
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: '??? ?????? ???????????????.',
                border: UnderlineInputBorder(),
                focusColor: Color(0xff636363),
                fillColor: Color(0xff636363),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    Future<DateTime> selectedDate = showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2018), // ?????????
                        lastDate: DateTime(2030),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light(),
                            child: child,
                          );
                        });
                    selectedDate.then((dateTime) {
                      setState(() {
                        if (dateTime != null)
                          _selectedDate =
                              DateFormat('yyyy-MM-dd').format(dateTime);
                        print(_selectedDate);
                      });
                    });
                  },
                ),
                _selectedDate == "" ? Text('????????? ??????') : Text(_selectedDate),
                SizedBox(
                  width: 20,
                ),
                Checkbox(
                  value: _isDue,
                  onChanged: (value) {
                    print(_isDue);
                    setState(() {
                      _isDue = !_isDue;
                    });
                  },
                ),
                Text('????????? ??????'),
              ],
            )
            // ElevatedButton.icon(
            //   label: Text("????????? ????????? ?????? - ??????"),
            //   icon: Icon(Icons.help),
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.grey,
            //   ),
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/editTimeTable');
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
