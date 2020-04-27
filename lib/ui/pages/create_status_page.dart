import 'package:cs4261a1/locator.dart';
import 'package:cs4261a1/ui/widgets/temp_input.dart';
import 'package:cs4261a1/services/dialog.dart';
import 'package:cs4261a1/services/firestore.dart';
import 'package:cs4261a1/services/navigation.dart';
import 'package:cs4261a1/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:cs4261a1/models/status.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';


class StatusMaterial extends StatefulWidget {
  @override
  _StatusMaterialState createState() => new _StatusMaterialState();
}
class _StatusMaterialState extends State {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final Auth _auth = locator<Auth>();
  final _formKey = GlobalKey<FormState>();
  final _status = Status();


  @override
  Widget build(BuildContext context) {
    _status.initState();

    return Scaffold(
        appBar: AppBar(title: Text('Record Symptoms')),
        body: Container(
            padding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DateTimePickerFormField(
                              inputType: InputType.date,
                              format: DateFormat('dd-MM-yyyy'),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.grey[200],),
                              onChanged: (selectedDate) => setState(
                                        () => _status.date = selectedDate),

                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Temperature'),
                            inputFormatters: [DecimalTextInputFormatter(decimalRange: 1)],
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your temperature.';
                              } else if (double.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              } else if (double.tryParse(value) > 46.1 ||
                                  double.tryParse(value) < 15.1) {
                                return '15.1 < Temperature < 46.2';
                              }
                              return null;
                            },
                            onSaved: (val) =>
                                setState(() => _status.temp = double.parse(val)),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                            child: Text('Other Symptoms'),
                          ),
                          CheckboxListTile(
                              title: const Text('Tiredness'),
                              value: _status.tiredness,
                              onChanged: (bool val) {
                                setState(() =>
                                _status.tiredness = val);
                              }),
                          CheckboxListTile(
                              title: const Text('Body Ache'),
                              value: _status.bodyache,
                              onChanged: (bool val) {
                                setState(() =>
                                _status.bodyache = val);
                              }),
                          CheckboxListTile(
                              title: const Text('Sore Throat'),
                              value: _status.soreThroat,
                              onChanged: (bool val) {
                                setState(() =>
                                _status.soreThroat = val);
                              }),
                          CheckboxListTile(
                              title: const Text('Nasal Congestion'),
                              value: _status.nasalCongestion,
                              onChanged: (bool val) {
                                setState(() =>
                                _status.nasalCongestion = val);
                              }),
                          CheckboxListTile(
                              title: const Text('Diarrhoea'),
                              value: _status.diarrhoea,
                              onChanged: (bool val) {
                                setState(() =>
                                _status.diarrhoea = val);
                              }),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: RaisedButton(
                                  onPressed: () {
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      _status.userId = _auth.getCurrentUser().toString();
                                      addStatus(_status);
                                      _showDialog(context);
                                    }
                                  },
                                  child: Text('Save'))),
                        ])))));
  }
  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }

  Future addStatus(Status status) async {
    var result;
    result = await _firestoreService
          .createStatus(status);
    if (result is String) {
      await _dialogService.showDialog(
        title: 'Cound not create status',
        description: result,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Status successfully Added',
        description: 'Your status has been created',
      );
    }

    _navigationService.pop();
  }
}

