import 'services/authentication.dart';
import 'services/firestore.dart';
import 'package:get_it/get_it.dart';
//import 'services/navigation_service.dart';
//import 'services/dialog_service.dart';

final GetIt locator = GetIt();

void setupLocator() {
  //locator.registerLazySingleton(() => NavigationService());
  //locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => Auth());
  locator.registerLazySingleton(() => FirestoreService());
}