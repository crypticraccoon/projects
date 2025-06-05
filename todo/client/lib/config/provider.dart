import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/data/services/api/api.dart';
import 'package:todo/data/services/shared_prefrences_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers {
  //const url = "http://0.0.0.0:3000/v1";
  const url = "http://3.23.112.181/v1";

  return [
    Provider(create: (context) => SharedPreferencesService()),

    Provider(create: (context) => ApiClient(url: url, sp: context.read())),
    ChangeNotifierProvider(
      create:
          (context) => AuthRepository(
            apiClient: context.read(),
            sharedPreferencesService: context.read(),
          ),
    ),

    Provider(
      create: (context) => RegistrationRepository(apiClient: context.read()),
    ),

    Provider(
      create: (context) => RecoveryRepository(apiClient: context.read()),
    ),

    Provider(
      create:
          (context) => TodoRepository(
            sharedPreferencesService: context.read(),
            apiClient: context.read(),
            authRepository: context.read(),
          ),
    ),

    Provider(
      create:
          (context) => UserRepository(
            sharedPreferencesService: context.read(),
            apiClient: context.read(),
            authRepository: context.read(),
          ),
    ),
  ];
}
