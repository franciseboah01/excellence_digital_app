import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/network/api_exceptions.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.forgotPassword(_emailController.text.trim());

      if (!mounted) return;
      setState(() => _emailSent = true);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: EdcTheme.danger),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mot de passe oublié')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _emailSent ? _buildSuccessView() : _buildFormView(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.lock_reset, size: 64, color: EdcTheme.primaryLight),
          const SizedBox(height: 24),
          Text(
            'Réinitialiser le mot de passe',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Entrez votre adresse email pour recevoir un lien de réinitialisation.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSendResetLink(),
            decoration: const InputDecoration(
              labelText: 'Adresse email',
              hintText: 'exemple@email.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) {
              if (v?.isEmpty == true) return 'Champ requis';
              if (!v!.contains('@')) return 'Email invalide';
              return null;
            },
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSendResetLink,
            child: _isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Envoyer le lien'),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('← Retour à la connexion'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.check_circle_outline, size: 72, color: EdcTheme.success),
        const SizedBox(height: 24),
        Text(
          'Email envoyé !',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 400.ms).scale(),
        const SizedBox(height: 12),
        Text(
          'Vérifiez votre boîte mail et suivez les instructions.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        OutlinedButton.icon(
          onPressed: () => _handleSendResetLink(),
          icon: const Icon(Icons.refresh),
          label: const Text('Renvoyer le lien'),
        ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('← Retour à la connexion'),
        ),
      ],
    );
  }
}