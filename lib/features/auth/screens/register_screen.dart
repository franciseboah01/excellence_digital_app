import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/network/api_exceptions.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _obscurePassword = ValueNotifier(true);
  final _obscureConfirm = ValueNotifier(true);
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _obscurePassword.dispose();
    _obscureConfirm.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez accepter les conditions d\'utilisation.'),
          backgroundColor: EdcTheme.warning,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.register(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmationController.text,
        telephone: _telephoneController.text.trim().isEmpty 
            ? null 
            : _telephoneController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Inscription réussie ! Vérifiez votre email.'),
          backgroundColor: EdcTheme.success,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: EdcTheme.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Titre
                Text(
                  'Rejoignez-nous ! 🚀',
                  style: Theme.of(context).textTheme.headlineMedium,
                ).animate().fadeIn(duration: 400.ms),
                
                const SizedBox(height: 8),
                
                Text(
                  'Créez votre compte pour accéder à toutes nos formations',
                  style: Theme.of(context).textTheme.bodyMedium,
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                
                const SizedBox(height: 32),
                
                // Nom
                TextFormField(
                  controller: _nomController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    hintText: 'Votre nom',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Champ requis' : null,
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: -20, end: 0),
                
                const SizedBox(height: 16),
                
                // Prénom
                TextFormField(
                  controller: _prenomController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    hintText: 'Votre prénom',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Champ requis' : null,
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideX(begin: 20, end: 0),
                
                const SizedBox(height: 16),
                
                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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
                ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideX(begin: -20, end: 0),
                
                const SizedBox(height: 16),
                
                // Téléphone
                TextFormField(
                  controller: _telephoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone (optionnel)',
                    hintText: '+225 07 00 00 00 00',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 500.ms).slideX(begin: 20, end: 0),
                
                const SizedBox(height: 16),
                
                // Mot de passe
                ValueListenableBuilder(
                  valueListenable: _obscurePassword,
                  builder: (context, obscure, _) {
                    return TextFormField(
                      controller: _passwordController,
                      obscureText: obscure,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: '8 caractères minimum',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => _obscurePassword.value = !obscure,
                        ),
                      ),
                      validator: (v) {
                        if (v?.isEmpty == true) return 'Champ requis';
                        if (v!.length < 8) return '8 caractères minimum';
                        return null;
                      },
                    );
                  },
                ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
                
                const SizedBox(height: 16),
                
                // Confirmation
                ValueListenableBuilder(
                  valueListenable: _obscureConfirm,
                  builder: (context, obscure, _) {
                    return TextFormField(
                      controller: _passwordConfirmationController,
                      obscureText: obscure,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleRegister(),
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => _obscureConfirm.value = !obscure,
                        ),
                      ),
                      validator: (v) {
                        if (v != _passwordController.text) return 'Les mots de passe ne correspondent pas';
                        return null;
                      },
                    );
                  },
                ).animate().fadeIn(duration: 400.ms, delay: 700.ms),
                
                const SizedBox(height: 20),
                
                // Conditions
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _acceptTerms,
                        onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                        activeColor: EdcTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            const TextSpan(text: 'J\'accepte les '),
                            TextSpan(
                              text: 'conditions d\'utilisation',
                              style: TextStyle(color: EdcTheme.primaryLight, decoration: TextDecoration.underline),
                            ),
                            const TextSpan(text: ' et la '),
                            TextSpan(
                              text: 'politique de confidentialité',
                              style: TextStyle(color: EdcTheme.primaryLight, decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 800.ms),
                
                const SizedBox(height: 24),
                
                // Bouton
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Créer mon compte'),
                ).animate().fadeIn(duration: 400.ms, delay: 900.ms).slideY(begin: 20, end: 0),
                
                const SizedBox(height: 16),
                
                // Lien connexion
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Déjà un compte ? ', style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Se connecter'),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 1000.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}