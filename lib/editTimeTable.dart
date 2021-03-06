import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'model.dart';

typedef LabelledValueChanged<T, U> = void Function(T label, U value);
bool loaded = false;
TimeTableModel _timeTableModel;
AutovalidateMode _autoValidateMode = AutovalidateMode.onUserInteraction;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
final GlobalKey<FormState> _allDayKey = GlobalKey<FormState>();
final GlobalKey<FormState> _startKey = GlobalKey<FormState>();
final GlobalKey<FormState> _endKey = GlobalKey<FormState>();
final GlobalKey<FormState> _repeatKey = GlobalKey<FormState>();
final GlobalKey<FormState> _alarmKey = GlobalKey<FormState>();
final GlobalKey<FormState> _calendarKey = GlobalKey<FormState>();

final FocusNode _nameNode = FocusNode();
final FocusNode _descriptionNode = FocusNode();

class editTimeTable extends StatefulWidget{

  @override
  _editTimeTableState createState() => _editTimeTableState();
}

class _editTimeTableState extends State<editTimeTable> {

  @override
  Widget build(context){
    var orientation = MediaQuery.of(context).orientation;
    bool _showMaterialonIOS = true;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<ExampleFormState> _formWidgetKey =
    GlobalKey<ExampleFormState>();
    void showSnackBar(String label, dynamic value) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(label + ' = ' + value.toString()),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "?????? ??????",
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        leading:
        IconButton(
          icon: Icon(
            Icons.autorenew,
          ),
          color: Colors.black54,
          onPressed: () async {
            setState(() => loaded = false);
            _timeTableModel = TimeTableModel();
            await _timeTableModel.loadMedia();
            await setState(() => loaded = true);
            //_formKey.currentState.reset();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
            ),
            color: Colors.black54,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ExampleForm(orientation, _showMaterialonIOS, _scaffoldKey,
          key: _formWidgetKey, onValueChanged: showSnackBar),
    );
  }
}

class ExampleForm extends StatefulWidget {
  const ExampleForm(
      this.orientation,
      this.showMaterialonIOS,
      this.scaffoldKey, {
        this.onValueChanged,
        Key key,
      }) : super(key: key);

  final Orientation orientation;
  final bool showMaterialonIOS;
  final GlobalKey<ScaffoldState> scaffoldKey;

  final LabelledValueChanged<String, dynamic> onValueChanged;

  @override
  ExampleFormState createState() => ExampleFormState();
}

class ExampleFormState extends State<ExampleForm> {

  @override
  void initState() {
    super.initState();

    initModel();
  }

  void initModel() async {
    _timeTableModel = TimeTableModel();

    await _timeTableModel.loadMedia();

    setState(() => loaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      return Form(
        key: _formKey,
        child: (widget.orientation == Orientation.portrait)
            ? _buildPortraitLayout()
            : _buildLandscapeLayout(),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Future savePressed() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print("?????????????????????.");
    } else {
      print("?????????");
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
    }
  }

  void canclePressed() {

  }

  void resetPressed() {
    setState(() => loaded = false);

    initModel();

    _formKey.currentState.reset();
  }
  CardSettings _buildPortraitLayout() {
    return CardSettings.sectioned(
      showMaterialonIOS: widget.showMaterialonIOS,
      labelWidth: 150,
      contentAlign: TextAlign.right,
      cardless: false,
      children: <CardSettingsSection>[
        CardSettingsSection(
          children: <CardSettingsWidget>[
            _buildCardSettingsText_Name(),
            _buildCardSettingsSwitch_Allday(),
            _buildCardSettingsDateTimePicker_Start(),
            _buildCardSettingsDateTimePicker_End(),
            _buildCardSettingsCheckboxPicker_Repeat(),
            _buildCardSettingsListPicker_Alarm(),
            _buildCardSettingsListPicker_Calendar(),
          ],
        ),
        CardSettingsSection(
          children: <CardSettingsWidget>[
            _buildCardSettingsButton_Save(),
            _buildCardSettingsButton_Reset(),
          ],
        ),
      ],
    );
  }

  CardSettings _buildLandscapeLayout() {
    return CardSettings.sectioned(
      showMaterialonIOS: widget.showMaterialonIOS,
      labelPadding: 12.0,
      children: <CardSettingsSection>[
        CardSettingsSection(
          children: <CardSettingsWidget>[
            _buildCardSettingsText_Name(),
            //_buildCardSettingsListPicker_Type(),
            CardFieldLayout(
              <CardSettingsWidget>[
                //_buildCardSettingsNumberPicker_Age(labelAlign: TextAlign.right),
              ],
              flexValues: [2, 1],
            ),
            _buildCardSettingsSwitch_Allday(),
            _buildCardSettingsDateTimePicker_Start(),
            _buildCardSettingsDateTimePicker_End(),
            _buildCardSettingsCheckboxPicker_Repeat(),
            _buildCardSettingsListPicker_Alarm(),
            _buildCardSettingsListPicker_Calendar(),
          ],
        ),
        CardSettingsSection(
          children: <CardSettingsWidget>[
            CardFieldLayout(<CardSettingsWidget>[
              _buildCardSettingsButton_Save(),
              _buildCardSettingsButton_Reset(),
            ]),
          ],
        ),
      ],
    );
  }

  CardSettingsButton _buildCardSettingsButton_Reset() {
    return CardSettingsButton(
      label: '??????',
      isDestructive: true,
      //onPressed: resetPressed,
      onPressed: () {
        Navigator.pop(context);
      },
      backgroundColor: Color(0xfff2d8d3),
      textColor: Colors.black,
      bottomSpacing: 4.0,
    );
  }

  CardSettingsButton _buildCardSettingsButton_Save() {
    return CardSettingsButton(
      label: '??????',
      backgroundColor: Color(0xffd7f2d3),
      //backgroundColor: Colors.green,
      onPressed: savePressed,
    );
  }
  CardSettingsText _buildCardSettingsText_Name() {
    return CardSettingsText(
      key: _nameKey,
      label: '??????',
      hintText: '????????? ??????????????????.',
      initialValue: _timeTableModel.name,
      //requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      autovalidateMode: _autoValidateMode,
      focusNode: _nameNode,
      inputAction: TextInputAction.next,
      inputActionNode: _descriptionNode,
      //inputMask: '000.000.000.000',
      validator: (value) {
        if (value == null || value.isEmpty) return '????????? ??????????????????.';
        return null;
      },
      onSaved: (value) => _timeTableModel.name = value,
      onChanged: (value) {
        setState(() {
          _timeTableModel.name = value;
        });
        //widget.onValueChanged('Name', value);
      },
    );
  }
  CardSettingsSwitch _buildCardSettingsSwitch_Allday() {
    return CardSettingsSwitch(
      key: _allDayKey,
      label: '??????',
      initialValue: _timeTableModel.isAllday,
      onSaved: (value) => _timeTableModel.isAllday = value,
      onChanged: (value) {
        setState(() {
          _timeTableModel.isAllday = value;
        });
      },
    );
  }
  CardSettingsDateTimePicker _buildCardSettingsDateTimePicker_Start() {
    return CardSettingsDateTimePicker(
      key: _startKey,
      label: '??????',
      initialValue: _timeTableModel.start,
      onSaved: (value) => _timeTableModel.start =
          updateJustDate(value, _timeTableModel.start),
      onChanged: (value) {
        setState(() {
          _timeTableModel.start = value;
        });
      },
    );
  }
  CardSettingsDateTimePicker _buildCardSettingsDateTimePicker_End() {
    return CardSettingsDateTimePicker(
      key: _endKey,
      label: '??????',
      initialValue: _timeTableModel.end,
      onSaved: (value) =>  _timeTableModel.end =
          updateJustDate(value,  _timeTableModel.end),
      onChanged: (value) {
        setState(() {
          _timeTableModel.end = value;
        });
      },
    );
  }
  CardSettingsCheckboxPicker _buildCardSettingsCheckboxPicker_Repeat() {
    return CardSettingsCheckboxPicker(
      key: _repeatKey,
      label: '??????',
      initialValues:  _timeTableModel.repeats,
      options: allRepeats,
      autovalidateMode: _autoValidateMode,
      validator: (List<String> value) {
        return null;
      },
      onSaved: (value) =>  _timeTableModel.repeats = value,
      onChanged: (value) {
        setState(() {
          _timeTableModel.repeats = value;
        });
      },
    );
  }
  CardSettingsListPicker _buildCardSettingsListPicker_Alarm() {
    return CardSettingsListPicker(
      key: _alarmKey,
      label: '??????',
      initialValue:  _timeTableModel.alarm,
      autovalidateMode: _autoValidateMode,
      options: allAlarms,
      values: allAlarmsValues,
      validator: (String value) {
        if (value == null || value.isEmpty) return '??????????????????.';
        return null;
      },
      onSaved: (value) => _timeTableModel.alarm = value,
      onChanged: (value) {
        setState(() {
          _timeTableModel.alarm = value;
        });
      },
    );
  }
  CardSettingsListPicker _buildCardSettingsListPicker_Calendar() {
    return CardSettingsListPicker(
      key: _calendarKey,
      label: '?????????',
      initialValue: _timeTableModel.calendar,
      autovalidateMode: _autoValidateMode,
      options: allCalendars,
      values: allCalendarsValues,
      validator: (String value) {
        if (value == null || value.isEmpty) return '??????????????????.';
        return null;
      },
      onSaved: (value) => _timeTableModel.calendar = value,
      onChanged: (value) {
        setState(() {
          _timeTableModel.calendar = value;
        });
        //widget.onValueChanged('Type', value);
      },
    );
  }

}