import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../services/profile_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_header.dart';

enum _ProfileStatus { idle, loading, content, error }

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.profileService,
    required this.isActive,
  });

  final ProfileService profileService;

  /// El perfil se carga la primera vez que la pestaña se muestra.
  final bool isActive;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfileStatus _status = _ProfileStatus.idle;
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _loadProfile();
  }

  @override
  void didUpdateWidget(ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && _status == _ProfileStatus.idle) _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _status = _ProfileStatus.loading);

    try {
      final profile = await widget.profileService.fetchProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _status = _ProfileStatus.content;
      });
    } on ProfileException {
      if (!mounted) return;
      setState(() => _status = _ProfileStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        children: [
          const AppHeader(title: 'Perfil'),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return switch (_status) {
      _ProfileStatus.idle => const SizedBox.shrink(),
      _ProfileStatus.loading => const Center(
        child: CircularProgressIndicator(
          key: ValueKey('profile-loading'),
          semanticsLabel: 'Cargando perfil',
        ),
      ),
      _ProfileStatus.content => _ProfileContent(profile: _profile!),
      _ProfileStatus.error => _ProfileError(onRetry: _loadProfile),
    };
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final usernameLabel = profile.usernameLabel;
    final email = profile.email;
    final welcomeMessage = profile.welcomeMessage;

    return SingleChildScrollView(
      key: const ValueKey('profile-content'),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        children: [
          const _ProfileAvatar(),
          const SizedBox(height: 24),
          Semantics(
            header: true,
            child: Text(
              profile.fullName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.profileName,
            ),
          ),
          if (usernameLabel != null) ...[
            const SizedBox(height: 8),
            Text(
              usernameLabel,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.profileUsername,
            ),
          ],
          if (email != null) ...[
            const SizedBox(height: 8),
            Text(
              email,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.profileEmail,
            ),
          ],
          const SizedBox(height: 24),
          _PaymentMethodSection(paymentMethod: profile.paymentMethod),
          if (welcomeMessage != null) ...[
            const SizedBox(height: 24),
            Text(
              welcomeMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.profileWelcome,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: 88,
        height: 88,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.outline),
        ),
        child: const Icon(
          Icons.person_outline,
          size: 48,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _PaymentMethodSection extends StatelessWidget {
  const _PaymentMethodSection({required this.paymentMethod});

  final PaymentMethod? paymentMethod;

  @override
  Widget build(BuildContext context) {
    final method = paymentMethod;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: const Text(
            'Método de pago asociado',
            style: AppTextStyles.optionsTitle,
          ),
        ),
        const SizedBox(height: 12),
        MergeSemantics(
          child: Container(
            key: const ValueKey('profile-payment-method'),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.outlineSoft),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: method == null
                ? const Text(
                    'No tienes un método de pago asociado',
                    style: AppTextStyles.profileEmail,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(method.title, style: AppTextStyles.paidAmount),
                      const SizedBox(height: 4),
                      Text(method.maskedNumber, style: AppTextStyles.infoValue),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('profile-error'),
      padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ExcludeSemantics(
            child: Icon(Icons.error_outline, size: 48, color: AppColors.error),
          ),
          const SizedBox(height: 16),
          const Text(
            'No pudimos cargar tu perfil',
            textAlign: TextAlign.center,
            style: AppTextStyles.optionsTitle,
          ),
          const SizedBox(height: 8),
          const Text(
            'Revisa tu conexión e inténtalo de nuevo.',
            textAlign: TextAlign.center,
            style: AppTextStyles.stateMessage,
          ),
          const SizedBox(height: 24),
          Center(
            child: FilledButton(
              key: const ValueKey('profile-retry'),
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(160, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Reintentar', style: AppTextStyles.formButton),
            ),
          ),
        ],
      ),
    );
  }
}
