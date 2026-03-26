import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/auth_provider.dart';
import '../../../core/utils/error_helpers.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('アカウント')),
      body: ListView(
        children: [
          // User info
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('メールアドレス'),
            subtitle: Text(user?.email ?? ''),
          ),
          const Divider(),

          // Privacy policy
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('プライバシーポリシー'),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => launchUrl(
              Uri.parse(
                  'https://shunseiw-ctrl.github.io/zaiquest/privacy-policy.html'),
              mode: LaunchMode.externalApplication,
            ),
          ),
          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('ログアウト'),
            onTap: () => _showLogoutDialog(context, ref),
          ),
          const Divider(),

          // Delete account
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.delete_forever),
              label: const Text('アカウントを削除'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
              ),
              onPressed: () => _showDeleteDialog(context, ref),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'アカウントを削除すると、お気に入りやメモなど全てのデータが完全に削除されます。この操作は取り消せません。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ログアウト'),
        content: const Text('ログアウトしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).signOut();
              Navigator.of(ctx).pop();
              context.go('/');
            },
            child: const Text('ログアウト'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('アカウント削除'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('この操作は取り消せません。全てのデータが削除されます。'),
              const SizedBox(height: 16),
              const Text('確認のため「削除」と入力してください:'),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: '削除',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: controller.text == '削除'
                  ? () async {
                      Navigator.of(ctx).pop();
                      await _executeDelete(context, ref);
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('アカウントを削除'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _executeDelete(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authNotifierProvider.notifier).deleteAccount();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('アカウントを削除しました')),
        );
        context.go('/');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    }
  }
}
