import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import './addTimeTable.dart';
import './editTimeTable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor:  Color(0xff636363),
      ),
      home: myCalendar(),
    );
  }
}

class myCalendar extends StatefulWidget {
  @override
  _myCalendarState createState() => _myCalendarState();
}

class _myCalendarState extends State<myCalendar> with TickerProviderStateMixin {

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


  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    DateTime startTime =
    DateTime(today.year, today.month, today.day, 9, 0, 0);
    DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
        Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false));

    startTime =
        DateTime(today.year, today.month, today.day, 14, 0, 0);
    endTime = startTime.add(const Duration(hours: 3));
    meetings.add(
        Meeting('캡스톤 랩미팅', startTime, endTime, Colors.amberAccent, false));

    startTime =
        DateTime(today.year, today.month, today.day + 2, 19, 0, 0);
    endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
        Meeting('암스트롱 훈련', startTime, endTime, Colors.pinkAccent, false));

    startTime =
        DateTime(today.year, today.month, today.day -5, 19, 0, 0);
    endTime = DateTime(today.year, today.month, today.day -3, 19, 0, 0);
    meetings.add(
        Meeting('Mobile', startTime, endTime, Colors.blue, false));

    return meetings;
  }

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

    List<Meeting> meetingList = _getDataSource();
    final List<Widget> _tabWidgets = [
      MonthlyCalendar(meetingList: meetingList),
      WeeklyCalendar(meetingList: meetingList),
      DailyCalendar(meetingList : meetingList),
      addTimeTable()
    ];

    return Scaffold(
      body: _tabWidgets[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items:  const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: 'month',
              backgroundColor: Color(0xffe0e0e0)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'week',
              backgroundColor: Color(0xffe0e0e0)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day),
            label: 'day',
            backgroundColor: Color(0xffe0e0e0),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'add',
              backgroundColor: Color(0xffe0e0e0)
          ),
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
                    )
                );
              },
              isScrollControlled: true
          );
        },
        child: Icon(Icons.add),

      ),


    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
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

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

// 월간
class MonthlyCalendar extends StatefulWidget {

  MonthlyCalendar({
    Key key,
    @required this.meetingList
  }) : super(key: key);
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
                    isScrollControlled: true
                );
              }
          ),
          IconButton(
              icon: Icon(Icons.settings),
              color: Color(0xff636363),
              iconSize: 28,
              onPressed: () {}
          )
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

// 주간
class WeeklyCalendar extends StatefulWidget {

  WeeklyCalendar({
    Key key,
    @required this.meetingList
  }) : super(key: key);
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
                    isScrollControlled: true
                );
              }
          ),
          IconButton(
              icon: Icon(Icons.settings),
              color: Color(0xff636363),
              iconSize: 28,
              onPressed: () {}
          )
        ],
      ),
      body: Container(
        // padding: EdgeInsets.all(10),
        child: SfCalendar(
          view: CalendarView.week,
          dataSource: MeetingDataSource(widget.meetingList),
        ),
      )
    );
  }
}

// 일간
class DailyCalendar extends StatefulWidget {

  DailyCalendar({
    Key key,
    @required this.meetingList
  }) : super(key: key);
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
    return  Scaffold(
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
                    isScrollControlled: true
                );
              }
          ),
          IconButton(
              icon: Icon(Icons.settings),
              color: Color(0xff636363),
              iconSize: 28,
              onPressed: () {}
          )
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
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      // child: Text('TODAY')
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                            child: Text('TODAY'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                value: _ischecked,
                                onChanged: (bool value) {
                                  setState((){
                                    _ischecked = value;
                                  });
                                },
                              ),
                              Expanded(child:  Text('모앱개 프로젝트', style: TextStyle(fontSize: 13),),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                value: _ischecked2,
                                onChanged: (bool value) {
                                  setState((){
                                    _ischecked2 = value;
                                  });
                                },
                              ),
                              Expanded(child:  Text('캡스톤 미팅', style: TextStyle(fontSize: 13),),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                value: _ischecked3,
                                onChanged: (bool value) {
                                  setState((){
                                    _ischecked3 = value;
                                  });
                                },
                              ),
                              Expanded(child:  Text('모앱개 수업', style: TextStyle(fontSize: 13),),),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.black45,),
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                            child: Text('WHOLE'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                value: _ischecked,
                                onChanged: (value) {
                                  setState(() {
                                    _ischecked = !_ischecked;
                                  });
                                },
                              ),
                              Expanded(child: Text('모앱개 수업')),
                              IconButton(icon: Icon(Icons.minimize), iconSize: 13, color: Colors.blue,onPressed: (){})
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                value: _ischecked2,
                                onChanged: (value) {
                                  setState(() {
                                    _ischecked2 = !_ischecked2;
                                  });
                                },
                              ),
                              Expanded(child: Text('모인활 팀플')),
                              IconButton(icon: Icon(Icons.add), iconSize: 13, color: Colors.redAccent, onPressed: (){})
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                value: _ischecked3,
                                onChanged: (value) {
                                  setState(() {
                                    _ischecked3 = !_ischecked3;
                                  });
                                },
                              ),
                              Expanded(child: Text('캡스톤 작업')),
                              IconButton(icon: Icon(Icons.minimize), iconSize: 13, color: Colors.blue,onPressed: (){})
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}

// 일간, 전체 일정 추가하기 위젯
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
                    Tab(text: "일간"),
                    Tab(text: "전체"),
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
                              Expanded(child: Text('OODP 과제하기')),
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
                              Expanded(child: Text('청소기 돌리기')),
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
                              Expanded(child: Text('운동하기')),
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
                              Expanded(child: Text('모앱개 피그마 만들기')),
                              IconButton(icon: Icon(Icons.add), iconSize: 13, color: Colors.redAccent, onPressed: (){})
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
                              Expanded(child: Text('운동하기')),
                              IconButton(icon: Icon(Icons.add), iconSize: 13, color: Colors.redAccent, onPressed: (){})
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
                              Expanded(child: Text('청소기 돌리기')),
                              IconButton(icon: Icon(Icons.minimize), iconSize: 13, color: Colors.blue,onPressed: (){})
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
                              Expanded(child: Text('OODP 과제하기')),
                              IconButton(icon: Icon(Icons.minimize), iconSize: 13, color: Colors.blue,onPressed: (){})
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
        )
        )
    );
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
                hintText: '할 일을 입력하세요.',
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
                        firstDate: DateTime(2018), // 시작일
                        lastDate: DateTime(2030),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light(),
                            child: child,
                          );
                        }
                    );
                    selectedDate.then((dateTime){
                      setState(() {
                        if(dateTime != null)
                          _selectedDate = DateFormat('yyyy-MM-dd').format(dateTime);
                        print(_selectedDate);
                      });
                    });
                  },
                ),
                _selectedDate == "" ?
                Text('날짜 선택'):
                Text(_selectedDate),

                SizedBox(width: 20,),
                Checkbox(
                  value: _isDue,
                  onChanged: (value) {
                    print(_isDue);
                    setState(() {
                      _isDue = !_isDue;
                    });
                  },
                ),
                Text('마감일 없음'),
              ],
            )
            // ElevatedButton.icon(
            //   label: Text("페이지 확인용 버튼 - 수정"),
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

