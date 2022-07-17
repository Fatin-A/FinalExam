import 'package:get_it/get_it.dart';

typedef RegisterCallback = void Function(GetIt);

class ServiceLocator {
  static final GetIt _locator = GetIt.instance;
  static GetIt get locator => _locator;
  static void init(RegisterCallback register) => register(_locator);
}
