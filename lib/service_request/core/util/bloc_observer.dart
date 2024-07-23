import 'package:bloc/bloc.dart';
import 'package:quick_log/quick_log.dart';

Logger logger = const Logger('');

class PrimaryBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    // debugPrint('onCreate -- ${bloc.runtimeType}');
    logger.debug('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // debugPrint('onChange -- ${bloc.runtimeType}, $change');
    logger.fine('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // debugPrint('onError -- ${bloc.runtimeType}, $error');
    logger.error('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    // debugPrint('onClose -- ${bloc.runtimeType}');
    logger.warning('onClose -- ${bloc.runtimeType}');
  }
}
