import 'package:supabase_flutter/supabase_flutter.dart';

/// Map any error to a user-friendly Japanese message.
String friendlyErrorMessage(Object error) {
  final msg = error.toString().toLowerCase();

  if (msg.contains('socket') ||
      msg.contains('network') ||
      msg.contains('connection') ||
      msg.contains('timeout')) {
    return 'ネットワークに接続できません';
  }

  if (error is PostgrestException) {
    return 'データの取得に失敗しました';
  }

  if (error is AuthException) {
    return '認証エラーが発生しました';
  }

  return '予期しないエラーが発生しました';
}
