import 'package:get_it/get_it.dart';
import 'package:gogo_mvp/presentation/presentation.dart';
import 'package:gogo_mvp/presentation/src/core/global_container/main_container.dart';
import 'package:gogo_mvp_data/data.dart';
import 'package:gogo_mvp_domain/domain.dart';

class DiInitializer {
  static Future<void> init({
    required void Function() onContainerReady,
  }) async {
    final getIt = GetIt.instance;
    await DataLayerDiInitializer.init(getIt);
    DomainLayerDiInitializer.init(getIt);
    _gogoRouteHelperInit(getIt);
    _rxContainerInit(getIt, onContainerReady);
  }

  static void _gogoRouteHelperInit(GetIt getIt) {
    getIt.registerSingleton(GoGoRouteHelper());
  }

  static void _rxContainerInit(GetIt getIt, void Function() onContainerReady) {
    getIt.registerLazySingleton(() {
      final container = MainContainer();
      onContainerReady();
      return container;
    });
  }

  DiInitializer._();
}
