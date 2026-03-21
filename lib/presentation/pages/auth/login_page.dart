import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  bool _isSending = false;
  bool _isSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendMagicLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() => _isSending = true);
    try {
      await ref.read(authNotifierProvider.notifier).signInWithMagicLink(email);
      setState(() {
        _isSent = true;
        _isSending = false;
      });
    } catch (e) {
      setState(() => _isSending = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラー: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _isSent ? _buildSentView(theme) : _buildFormView(theme),
      ),
    );
  }

  Widget _buildSentView(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mark_email_read, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            'メールを確認してください',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            '${_emailController.text} にログインリンクを送信しました。\nメール内のリンクをタップしてログインしてください。',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () => setState(() => _isSent = false),
            child: const Text('別のメールアドレスで試す'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.lock_outline, size: 64, color: theme.colorScheme.primary),
        const SizedBox(height: 24),
        Text(
          'ZAIQUESTにログイン',
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'メールアドレスを入力すると、ログインリンクが届きます。',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          decoration: const InputDecoration(
            labelText: 'メールアドレス',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          onSubmitted: (_) => _sendMagicLink(),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _isSending ? null : _sendMagicLink,
          child: _isSending
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('マジックリンクを送信'),
        ),
      ],
    );
  }
}
