import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:walk_city/features/auth/data/repositories/auth_repository.dart';
import 'package:walk_city/core/network/pb_client.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  // Конструктор: Блок, при создании должен знать про свой Репозиторий
  AuthBloc(this._repository) : super(AuthInitial()) {
    // МАРШРУТИЗАТОР: "Если придет LoginEvent, тогда надо в _onLogin"
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
  }

  // ОБРАБОТЧИК ЛОГИНА
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Сразу кричим "ЗАГРУЗКА"

    try {
      // Идем к "Почтальону" (репозиторию)
      final user = await _repository.login(
        email: event.email,
        password: event.password,
      );

      emit(AuthSuccess(user: user)); // Кричим "УСПЕХ"
    } catch (error) {
      emit(AuthFailure(message: _authError(error, isLogin: true)));
    }
  }

  // ОБРАБОТЧИК РЕГИСТРАЦИИ
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    // меняем состояние на новое
    emit(AuthLoading());

    try {
      final user = await _repository.register(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      emit(AuthSuccess(user: user));
    } catch (error) {
      emit(AuthFailure(message: _authError(error, isLogin: false)));
    }
  }

  String _authError(Object error, {required bool isLogin}) {
    if (error is ClientException) {
      if (error.statusCode == 0) {
        return 'Не удалось подключиться к PocketBase (${PbClient.baseUrl}). Проверьте, что сервер запущен и доступен симулятору.';
      }

      final message = error.response['message']?.toString() ?? '';
      final data = error.response['data'];
      final validationText = data is Map
          ? data.values
                .whereType<Map>()
                .map((field) => field['code']?.toString() ?? '')
                .join(' ')
          : '';
      final details = '$message $validationText'.toLowerCase();

      if (details.contains('failed to authenticate') ||
          (isLogin && error.statusCode == 400)) {
        return 'Неверный email, телефон или пароль.';
      }
      if (details.contains('validation_not_unique')) {
        return 'Аккаунт с таким email или телефоном уже существует.';
      }
      if (details.contains('validation_is_email')) {
        return 'Введите корректный email или номер телефона.';
      }
      if (details.contains('validation_length') ||
          details.contains('validation_min')) {
        return 'Пароль должен содержать не менее 8 символов.';
      }
      if (error.statusCode >= 500) {
        return 'PocketBase временно недоступен. Попробуйте ещё раз.';
      }
      if (message.isNotEmpty) return 'Ошибка PocketBase: $message';
      return isLogin
          ? 'Не удалось выполнить вход. Проверьте данные и подключение.'
          : 'Не удалось создать аккаунт. Проверьте данные и правила PocketBase.';
    }
    return isLogin
        ? 'Не удалось выполнить вход: $error'
        : 'Не удалось создать аккаунт: $error';
  }
}
