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
import '../viewmodel/event_viewmodel.dart';
import '../data/model/registration_model.dart';
import 'event_ref_extensions.dart';

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
    try {
      if (_formKey.currentState!.validate()) {
        // Validation: Check if all required fields are not empty
        if (_nameController.text.isEmpty ||
            _emailController.text.isEmpty ||
            _phoneController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All fields are required')),
          );
          return;
        }

        // Validation: Check email format
        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        if (!emailRegex.hasMatch(_emailController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid email')),
          );
          return;
        }

        // Validation: Check phone format (basic validation)
        if (_phoneController.text.length < 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid phone number')),
          );
          return;
        }

        final registration = RegistrationModel((b) => b
          ..id = ''
          ..eventId = widget.eventId
          ..userId = 'tempUserId_${DateTime.now().millisecondsSinceEpoch}'
          ..fullName = _nameController.text
          ..email = _emailController.text
          ..phone = _phoneController.text
          ..registeredAt = DateTime.now()
          ..checkedIn = false
          ..checkedOut = false
        );

        await ref.eventNotifier.register(registration);

        final state = ref.eventState;

        if (!mounted) return;
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) context.goNamed('eventList');
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.eventState;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: AppText.headingLg('Event Registration'),
        backgroundColor: colors.bgPage,
        elevation: 0,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(child: AppText.bodyMd('Error: ${state.error}', color: colors.error))
          : state.registrationId == null
          ? RegistrationForm(
        eventId: widget.eventId,
        nameController: _nameController,
        emailController: _emailController,
        phoneController: _phoneController,
        formKey: _formKey,
        onSubmit: _submit,
      )
          : RegistrationSuccessView(
        registrationId: state.registrationId!,
      ),
    );
  }
}

class RegistrationForm extends StatelessWidget {
  final String eventId;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;

  const RegistrationForm({
    super.key,
    required this.eventId,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.formKey,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s6),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.headingMd('Register for this event'),
            const SizedBox(height: AppSpacing.s2),
            AppText.bodySm('Please provide your details below to secure your spot.',
                color: context.colors.textSecondary),
            const SizedBox(height: AppSpacing.s8),
            AppTextField(
              label: 'Full Name',
              hint: 'John Doe',
              controller: nameController,
              fullWidth: true,
              prefixIcon: const AppIcon(AppIconName.user, size: 18),
              validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: AppSpacing.s4),
            AppTextField(
              label: 'Email',
              hint: 'john@example.com',
              controller: emailController,
              fullWidth: true,
              prefixIcon: const AppIcon(AppIconName.mail, size: 18),
              validator: (v) => v == null || v.isEmpty ? 'Email is required' : null,
            ),
            const SizedBox(height: AppSpacing.s4),
            AppTextField(
              label: 'Phone Number',
              hint: '+1 234 567 890',
              controller: phoneController,
              fullWidth: true,
              prefixIcon: const AppIcon(AppIconName.phone, size: 18),
              validator: (v) => v == null || v.isEmpty ? 'Phone is required' : null,
            ),
            const SizedBox(height: AppSpacing.s10),
            AppButton.primary(
              label: 'Confirm Registration',
              onPressed: onSubmit,
              fullWidth: true,
              size: AppButtonSize.lg,
              leading: const AppIcon(AppIconName.zap, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationSuccessView extends ConsumerWidget {
  final String registrationId;

  const RegistrationSuccessView({
    super.key,
    required this.registrationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s8),
        child: RegistrationSuccessCard(
          registrationId: registrationId,
          colors: colors,
          onViewMyEvents: () {
            ref.eventNotifier.resetStatus();
            context.goNamed('eventList');
          },
        ),
      ),
    );
  }
}

class RegistrationSuccessCard extends StatelessWidget {
  final String registrationId;
  final dynamic colors;
  final VoidCallback onViewMyEvents;

  const RegistrationSuccessCard({
    super.key,
    required this.registrationId,
    required this.colors,
    required this.onViewMyEvents,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
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
          AppText.bodyMd(
            'We\'ve sent a confirmation email to you.',
            textAlign: TextAlign.center,
            color: colors.textSecondary,
          ),
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
            onPressed: onViewMyEvents,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}