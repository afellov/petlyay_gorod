import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:walk_city/core/network/pb_client.dart';
import 'package:walk_city/features/auth/data/models/user_model.dart';

class AuthRepository {
  final _pb = PbClient.instance;

  // PocketBase supports either email or the unique phone identity field.
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final identity = normalizeIdentity(email);
    final isEmail = identity.contains('@');
    final body = <String, dynamic>{
      if (isEmail) 'email': identity else 'phone': identity,
      'password': password,
      'passwordConfirm': password,
      'name': name.trim(),
    };

    await _pb.collection('users').create(body: body);
    return login(email: identity, password: password);
  }

  static String normalizeIdentity(String value) {
    final identity = value.trim();
    if (identity.contains('@')) return identity;
    return identity.replaceAll(RegExp(r'[\s()\-]'), '');
  }

  Future<void> uploadAvatar(File imageFile) async {
    final user = _pb.authStore.record;
    if (user == null) throw StateError('Пользователь не авторизован.');
    final updated = await _pb
        .collection('users')
        .update(
          user.id,
          files: [await http.MultipartFile.fromPath('avatar', imageFile.path)],
        );
    _pb.authStore.save(_pb.authStore.token, updated);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final authData = await _pb
        .collection('users')
        .authWithPassword(normalizeIdentity(email), password);
    return UserModel.fromJson(authData.record.toJson());
  }

  Future<UserModel> updateProfile({required String name}) async {
    final user = _pb.authStore.record;
    if (user == null) throw StateError('Пользователь не авторизован.');
    final updated = await _pb
        .collection('users')
        .update(user.id, body: {'name': name.trim()});
    _pb.authStore.save(_pb.authStore.token, updated);
    return UserModel.fromJson(updated.toJson());
  }

  Future<void> requestPasswordReset(String email) async {
    await _pb.collection('users').requestPasswordReset(email.trim());
  }
}
