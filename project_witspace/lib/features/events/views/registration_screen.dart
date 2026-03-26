import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../src/components/app_text.dart';
import '../../../src/components/app_text_field.dart';
import '../../../src/components/app_button.dart';
import '../../../src/components/app_card.dart';
import '../../../src/components/app_icon.dart';
import '../../../src/tokens/spacing.dart';
import '../../../src/widgets/extensions.dart';
import '../viewmodel/registration_viewmodel.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  final String eventId;

  const RegistrationScreen({super.key, required this.eventId});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(registrationViewModelProvider.notifier).register(
            eventId: widget.eventId,
            fullName: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationViewModelProvider);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: AppText.headingLg('Event Registration'),
        backgroundColor: colors.bgPage,
        elevation: 0,
      ),
      body: state.when(
        data: (registrationId) {
          if (registrationId == null) {
            return _buildForm();
          } else {
            return _buildSuccess(registrationId);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: AppText.bodyMd('Error: $error', color: colors.error)),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s6),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.headingMd('Register for this event'),
            const SizedBox(height: AppSpacing.s2),
            AppText.bodySm('Please provide your details below to secure your spot.', color: context.colors.textSecondary),
            const SizedBox(height: AppSpacing.s8),
            AppTextField(
              label: 'Full Name',
              hint: 'John Doe',
              controller: _nameController,
              fullWidth: true,
              prefixIcon: const AppIcon(AppIconName.user, size: 18),
              validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: AppSpacing.s4),
            AppTextField(
              label: 'Email',
              hint: 'john@example.com',
              controller: _emailController,
              fullWidth: true,
              prefixIcon: const AppIcon(AppIconName.mail, size: 18),
              validator: (v) => v == null || v.isEmpty ? 'Email is required' : null,
            ),
            const SizedBox(height: AppSpacing.s4),
            AppTextField(
              label: 'Phone Number',
              hint: '+1 234 567 890',
              controller: _phoneController,
              fullWidth: true,
              prefixIcon: const AppIcon(AppIconName.phone, size: 18),
              validator: (v) => v == null || v.isEmpty ? 'Phone is required' : null,
            ),
            const SizedBox(height: AppSpacing.s10),
            AppButton.primary(
              label: 'Confirm Registration',
              onPressed: _submit,
              fullWidth: true,
              size: AppButtonSize.lg,
              leading: const AppIcon(AppIconName.zap, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess(String registrationId) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s8),
        child: AppCard(
          shadow: AppCardShadow.lg,
          padding: const EdgeInsets.all(AppSpacing.s8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s4),
                decoration: BoxDecoration(
                  color: colors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: AppIcon(AppIconName.check, color: colors.success, size: 48),
              ),
              const SizedBox(height: AppSpacing.s6),
              AppText.headingLg('Registration Successful!'),
              const SizedBox(height: AppSpacing.s4),
              AppText.bodyMd('We\'ve sent a confirmation email to you.', textAlign: TextAlign.center, color: colors.textSecondary),
              const SizedBox(height: AppSpacing.s8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.s6),
                decoration: BoxDecoration(
                  color: colors.bgPage,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    AppText.labelSm('TICKET ID', color: colors.textMuted),
                    const SizedBox(height: AppSpacing.s2),
                    AppText.statValue(registrationId, color: colors.primary),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              AppButton.secondary(
                label: 'View My Events',
                onPressed: () {
                  ref.read(registrationViewModelProvider.notifier).reset();
                  context.goNamed('eventList');
                },
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
