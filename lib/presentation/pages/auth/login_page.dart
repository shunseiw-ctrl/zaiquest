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
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _useMagicLink = false;
  bool _magicLinkSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithPassword() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .signInWithPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ログインエラー: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMagicLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .signInWithMagicLink(email);
      setState(() => _magicLinkSent = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラー: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _magicLinkSent
            ? _buildSentView(theme)
            : _buildFormView(theme),
      ),
    );
  }

  Widget _buildSentView(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Icon(Icons.mark_email_read,
              size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text('メールを確認してください',
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(
            '${_emailController.text} にログインリンクを送信しました。\nメール内のリンクをタップしてログインしてください。',
            textAlign: TextAlign.center,
            style:
                theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () =>
                setState(() { _magicLinkSent = false; _useMagicLink = false; }),
            child: const Text('パスワードでログイン'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 60),
        Icon(Icons.lock_outline, size: 64, color: theme.colorScheme.primary),
        const SizedBox(height: 24),
        Text('ZAIQUESTにログイン',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center),
        const SizedBox(height: 32),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          decoration: const InputDecoration(
            labelText: 'メールアドレス',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          onSubmitted: (_) =>
              _useMagicLink ? _sendMagicLink() : _signInWithPassword(),
        ),
        if (!_useMagicLink) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'パスワード',
              prefixIcon: Icon(Icons.lock_outlined),
            ),
            onSubmitted: (_) => _signInWithPassword(),
          ),
        ],
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _isLoading
              ? null
              : (_useMagicLink ? _sendMagicLink : _signInWithPassword),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_useMagicLink ? 'マジックリンクを送信' : 'ログイン'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => setState(() => _useMagicLink = !_useMagicLink),
          child: Text(_useMagicLink
              ? 'パスワードでログイン'
              : 'マジックリンクでログイン'),
        ),
      ],
    );
  }
}
