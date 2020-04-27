import 'package:cs4261a1/locator.dart';
import 'package:cs4261a1/models/status.dart';
import 'package:cs4261a1/services/dialog.dart';
import 'package:cs4261a1/services/firestore.dart';
import 'package:cs4261a1/services/navigation.dart';
import 'package:cs4261a1/viewmodels/base_model.dart';
import 'package:flutter/foundation.dart';

class CreatePostViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Status _edittingStatus;

  bool get _editting => _edittingStatus != null;

  Future addStatus({@required String date,
  @required int temp,
  @required bool tiredness,
  @required bool bodyache,
  @required bool nasalCongestion,
  @required bool soreThroat,
  @required bool diarrhoea}) async {
    setBusy(true);

    Status status = new Status(
        date: date,
        userId: _edittingStatus.userId,
        temp: temp,
        tiredness: tiredness,
        bodyache: bodyache,
        nasalCongestion: nasalCongestion,
        soreThroat: soreThroat,
        diarrhoea: diarrhoea);
    var result;

    if (!_editting) {
      result = await _firestoreService
          .createStatus(status);
    } else {
      result = await _firestoreService.updateStatus(status);
    }

    setBusy(false);

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

  void setEdittingStatus(Status edittingStatus) {
    _edittingStatus = edittingStatus;
  }
}