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

class addTimeTable extends StatefulWidget{

  @override
  _addTimeTableState createState() => _addTimeTableState();
}

class _addTimeTableState extends State<addTimeTable> {

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
            "일정 추가",
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
          onPressed: () {
            Navigator.pop(context);
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

typedef LabelledValueChanged<T, U> = void Function(T label, U value);

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
  PonyModel _ponyModel;

  bool loaded = false;

  @override
  void initState() {
    super.initState();

    initModel();
  }

  void initModel() async {
    _ponyModel = PonyModel();

    await _ponyModel.loadMedia();

    setState(() => loaded = true);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AutovalidateMode _autoValidateMode = AutovalidateMode.onUserInteraction;

  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _allDayKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _startKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _endKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _repeatKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _alarmKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _calendarKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _ageKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _descriptionlKey = GlobalKey<FormState>();

  final FocusNode _nameNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();

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
      print("저장되었습니다.");
    } else {
       print("실패함");
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
    }
  }

  void resetPressed() {
    setState(() => loaded = false);

    initModel();

    _formKey.currentState.reset();
  }

  //todo
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
      label: 'RESET',
      isDestructive: true,
      onPressed: resetPressed,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      bottomSpacing: 4.0,
    );
  }

  CardSettingsButton _buildCardSettingsButton_Save() {
    return CardSettingsButton(
      label: 'SAVE',
      backgroundColor: Colors.green,
      onPressed: savePressed,
    );
  }
  CardSettingsParagraph _buildCardSettingsParagraph_Description(int lines) {
    return CardSettingsParagraph(
      key: _descriptionlKey,
      label: 'Description',
      initialValue: _ponyModel.description,
      numberOfLines: lines,
      focusNode: _descriptionNode,
      onSaved: (value) => _ponyModel.description = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.description = value;
        });
        widget.onValueChanged('Description', value);
      },
    );
  }

  CardSettingsNumberPicker _buildCardSettingsNumberPicker_Age(
      {TextAlign labelAlign}) {
    return CardSettingsNumberPicker(
      key: _ageKey,
      label: 'Age',
      labelAlign: labelAlign,
      initialValue: _ponyModel.age,
      min: 1,
      max: 17,
      stepInterval: 2,
      validator: (value) {
        if (value == null) return 'Age is required.';
        if (value > 20) return 'No grown-ups allwed!';
        if (value < 3) return 'No Toddlers allowed!';
        return null;
      },
      onSaved: (value) => _ponyModel.age = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.age = value;
        });
        widget.onValueChanged('Age', value);
      },
    );
  }

  CardSettingsText _buildCardSettingsText_Name() {
    return CardSettingsText(
      key: _nameKey,
      label: '일정',
      hintText: '일정을 입력해주세요.',
      initialValue: _ponyModel.name,
      //requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      autovalidateMode: _autoValidateMode,
      focusNode: _nameNode,
      inputAction: TextInputAction.next,
      inputActionNode: _descriptionNode,
      //inputMask: '000.000.000.000',
      validator: (value) {
        if (value == null || value.isEmpty) return 'Name is required.';
        return null;
      },
      onSaved: (value) => _ponyModel.name = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.name = value;
        });
        //widget.onValueChanged('Name', value);
      },
    );
  }
  CardSettingsSwitch _buildCardSettingsSwitch_Allday() {
    return CardSettingsSwitch(
      key: _allDayKey,
      label: '종일',
      initialValue: _ponyModel.hasSpots,
      onSaved: (value) => _ponyModel.hasSpots = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.hasSpots = value;
        });
        //widget.onValueChanged('Has Spots?', value);
      },
    );
  }
  CardSettingsDateTimePicker _buildCardSettingsDateTimePicker_Start() {
    return CardSettingsDateTimePicker(
      key: _startKey,
      //icon: Icon(Icons.card_giftcard, color: Colors.yellow[700]),
      label: '시작',
      initialValue: _ponyModel.showDateTime,
      onSaved: (value) => _ponyModel.showDateTime =
          updateJustDate(value, _ponyModel.showDateTime),
      onChanged: (value) {
        setState(() {
          _ponyModel.showDateTime = value;
        });
        //widget.onValueChanged(
        //    'Show Date', updateJustDate(value, _ponyModel.showDateTime));
      },
    );
  }
  CardSettingsDateTimePicker _buildCardSettingsDateTimePicker_End() {
    return CardSettingsDateTimePicker(
      key: _endKey,
      label: '종료',
      //initialValue: _ponyModel.showDateTime,
      //onSaved: (value) => _ponyModel.showDateTime =
      //    updateJustDate(value, _ponyModel.showDateTime),
      onChanged: (value) {
        setState(() {
          _ponyModel.showDateTime = value;
        });
      },
    );
  }
  CardSettingsCheckboxPicker _buildCardSettingsCheckboxPicker_Repeat() {
    return CardSettingsCheckboxPicker(
      key: _repeatKey,
      label: '반복',
      initialValues: _ponyModel.hobbies,
      options: allHobbies,
      autovalidateMode: _autoValidateMode,
      validator: (List<String> value) {
        if (value == null || value.isEmpty)
          return 'You must pick at least one hobby.';

        return null;
      },
      onSaved: (value) => _ponyModel.hobbies = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.hobbies = value;
        });
        //widget.onValueChanged('Hobbies', value);
      },
    );
  }
  CardSettingsListPicker _buildCardSettingsListPicker_Alarm() {
    return CardSettingsListPicker(
      key: _alarmKey,
      label: '알람',
      initialValue: 'N',
      //initialValue: _ponyModel.type,
      //hintText: 'Select One',
      autovalidateMode: _autoValidateMode,
      options: <String>['없음', '5분전', '10분전', '1시간전'],
      values: <String>['N', '5', '10', '1'],
      validator: (String value) {
        if (value == null || value.isEmpty) return 'You must pick a type.';
        return null;
      },
      onSaved: (value) => _ponyModel.type = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.type = value;
        });
        widget.onValueChanged('Type', value);
      },
    );
  }
  CardSettingsListPicker _buildCardSettingsListPicker_Calendar() {
    return CardSettingsListPicker(
      key: _calendarKey,
      label: '캘린더',
      initialValue: 'C',
      //initialValue: _ponyModel.type,
      //hintText: 'Select One',
      autovalidateMode: _autoValidateMode,
      options: <String>['학교', '직장', '친목', '기타'],
      values: <String>['S', 'C', 'F', 'E'],
      validator: (String value) {
        if (value == null || value.isEmpty) return 'You must pick a type.';
        return null;
      },
      onSaved: (value) => _ponyModel.type = value,
      onChanged: (value) {
        setState(() {
          _ponyModel.type = value;
        });
        widget.onValueChanged('Type', value);
      },
    );
  }

}