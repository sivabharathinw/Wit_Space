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
import '../viewmodel/edit_event_viewmodel.dart';
import '../viewmodel/event_detail_viewmodel.dart';

class EditEventScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EditEventScreen({super.key, required this.eventId});

  @override
  ConsumerState<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends ConsumerState<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _imageUrlController;
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _initialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _initControllers(event) {
    if (_initialized) return;
    _titleController = TextEditingController(text: event.title);
    _descController = TextEditingController(text: event.description);
    _locationController = TextEditingController(text: event.location);
    _imageUrlController = TextEditingController(text: event.imageUrl);
    _selectedDate = event.date;
    _selectedTime = event.time;
    _initialized = true;
  }

  Future<void> _submit(event) async {
    if (_formKey.currentState!.validate()) {
      await ref.read(editEventViewModelProvider.notifier).updateEvent(
            originalEvent: event,
            title: _titleController.text,
            description: _descController.text,
            location: _locationController.text,
            date: _selectedDate!,
            time: _selectedTime!,
            imageUrl: _imageUrlController.text,
          );

      final state = ref.read(editEventViewModelProvider);
      
      if (!mounted) return;
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.error}')),
        );
      } else {
        context.goNamed('eventDetail', pathParameters: {'eventId': widget.eventId});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventDetailProvider(widget.eventId));
    final updateState = ref.watch(editEventViewModelProvider);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: AppText.headingLg('Edit Event'),
        backgroundColor: colors.bgPage,
        elevation: 0,
      ),
      body: eventAsync.when(
        data: (event) {
          // TODO: check isOwner
          const bool isOwner = true;
          if (!isOwner) {
            return Center(child: AppText.bodyMd('Unauthorized', color: colors.error));
          }

          _initControllers(event);

          return SingleChildScrollView(
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
                                  initialDate: _selectedDate!,
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
                                  AppText.bodySm(_selectedDate!.toIso8601String().split('T')[0], color: colors.primary),
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
                                  initialTime: _selectedTime!,
                                );
                                if (time != null) setState(() => _selectedTime = time);
                              },
                              border: true,
                              padding: const EdgeInsets.all(AppSpacing.s3),
                              child: Row(
                                children: [
                                  AppIcon(AppIconName.clock, color: colors.primary),
                                  const SizedBox(width: AppSpacing.s2),
                                  AppText.bodySm(_selectedTime!.format(context), color: colors.primary),
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
                    label: 'Update Event',
                    onPressed: updateState.isLoading ? null : () => _submit(event),
                    loading: updateState.isLoading,
                    fullWidth: true,
                    size: AppButtonSize.lg,
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: AppText.bodyMd('Error: $error', color: colors.error)),
      ),
    );
  }
}
