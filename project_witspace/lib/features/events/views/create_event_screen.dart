import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../src/components/app_text.dart';
import '../../../src/components/app_text_field.dart';
import '../../../src/components/app_textarea.dart';
import '../../../src/components/app_button.dart';
import '../../../src/components/app_card.dart';
import '../../../src/components/app_icon.dart';
import '../../../src/tokens/spacing.dart';
import '../../../src/widgets/extensions.dart';
import '../viewmodel/create_event_viewmodel.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Date and Time')),
        );
        return;
      }

      await ref.read(createEventViewModelProvider.notifier).createEvent(
            title: _titleController.text,
            description: _descController.text,
            location: _locationController.text,
            date: _selectedDate!,
            time: _selectedTime!,
            imageUrl: _imageUrlController.text,
          );

      final state = ref.read(createEventViewModelProvider);
      
      if (!mounted) return;
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.error}')),
        );
      } else {
        context.goNamed('eventList');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createEventViewModelProvider);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: AppText.headingLg('Create Event'),
        backgroundColor: colors.bgPage,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Event Title',
                hint: 'e.g. Community Hackathon',
                controller: _titleController,
                fullWidth: true,
                validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: AppSpacing.s4),
              AppTextarea(
                label: 'Description',
                hint: 'Tell us more about the event...',
                controller: _descController,
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.s4),
              AppTextField(
                label: 'Location',
                hint: 'e.g. Conference Room A',
                controller: _locationController,
                fullWidth: true,
                prefixIcon: const AppIcon(AppIconName.mapPin, size: 18),
                validator: (v) => v == null || v.isEmpty ? 'Location is required' : null,
              ),
              const SizedBox(height: AppSpacing.s4),
              AppTextField(
                label: 'Image URL',
                hint: 'https://...',
                controller: _imageUrlController,
                fullWidth: true,
                prefixIcon: const AppIcon(AppIconName.grid, size: 18),
              ),
              const SizedBox(height: AppSpacing.s6),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.label('Date', color: colors.primary),
                        const SizedBox(height: AppSpacing.s1),
                        AppCard(
                          onTap: () async {
                             final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030),
                              );
                              if (date != null) setState(() => _selectedDate = date);
                          },
                          border: true,
                          padding: const EdgeInsets.all(AppSpacing.s3),
                          child: Row(
                            children: [
                              AppIcon(AppIconName.calendar, color: colors.primary),
                              const SizedBox(width: AppSpacing.s2),
                              AppText.bodySm(_selectedDate == null ? 'Select Date' : _selectedDate!.toIso8601String().split('T')[0], color: colors.primary),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.label('Time', color: colors.primary),
                        const SizedBox(height: AppSpacing.s1),
                        AppCard(
                          onTap: () async {
                            final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) setState(() => _selectedTime = time);
                          },
                          border: true,
                          padding: const EdgeInsets.all(AppSpacing.s3),
                          child: Row(
                            children: [
                              AppIcon(AppIconName.clock, color: colors.primary),
                              const SizedBox(width: AppSpacing.s2),
                              AppText.bodySm(_selectedTime == null ? 'Select Time' : _selectedTime!.format(context), color: colors.primary),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s8),
              AppButton.primary(
                label: 'Create Event',
                onPressed: _submit,
                loading: state.isLoading,
                fullWidth: true,
                size: AppButtonSize.lg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
