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
import '../../../src/tokens/radius.dart';
import '../viewmodel/event_viewmodel.dart';
import '../data/model/event_model.dart';
import 'event_ref_extensions.dart';

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
    try {
      if (_formKey.currentState!.validate()) {
        // Validation: Check if date and time are selected
        if (_selectedDate == null || _selectedTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select Date and Time')),
          );
          return;
        }

        // Validation: Check if all required fields are not empty
        if (_titleController.text.isEmpty ||
            _descController.text.isEmpty ||
            _locationController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All fields are required')),
          );
          return;
        }

        final updatedEvent = event.rebuild((b) => b
          ..title = _titleController.text
          ..description = _descController.text
          ..location = _locationController.text
          ..date = _selectedDate!
          ..time = _selectedTime!
          ..imageUrl = _imageUrlController.text
        );

        await ref.eventNotifier.updateEvent(updatedEvent);

        final state = ref.eventState;

        if (!mounted) return;
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        } else {
          context.goNamed('eventDetail', pathParameters: {'eventId': widget.eventId});
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update event: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.eventState;
    final event = eventState.events.where((e) => e.id == widget.eventId).firstOrNull;
    final colors = context.colors;

    final bool isNotFound = event == null;
    if (!isNotFound) {
      _initControllers(event!);
    }

    return Scaffold(
      appBar: AppBar(
        title: AppText.headingLg('Edit Event'),
        backgroundColor: colors.bgPage,
        elevation: 0,
      ),
      body: eventState.isLoading && eventState.events.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : isNotFound
              ? Center(child: AppText.bodyMd('Event not found', color: colors.error))
              : EditEventForm(
                  event: event!,
                  formKey: _formKey,
                  titleController: _titleController,
                  descController: _descController,
                  locationController: _locationController,
                  imageUrlController: _imageUrlController,
                  selectedDate: _selectedDate!,
                  selectedTime: _selectedTime!,
                  onDateChanged: (date) => setState(() => _selectedDate = date),
                  onTimeChanged: (time) => setState(() => _selectedTime = time),
                  onSubmit: () => _submit(event),
                  isLoading: eventState.isLoading,
                ),
    );
  }
}

class EditEventForm extends StatelessWidget {
  final EventModel event;
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController locationController;
  final TextEditingController imageUrlController;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final Function(DateTime) onDateChanged;
  final Function(TimeOfDay) onTimeChanged;
  final VoidCallback onSubmit;
  final bool isLoading;

  const EditEventForm({
    super.key,
    required this.event,
    required this.formKey,
    required this.titleController,
    required this.descController,
    required this.locationController,
    required this.imageUrlController,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Event Title',
              hint: 'e.g. Community Hackathon',
              controller: titleController,
              fullWidth: true,
              validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: AppSpacing.s4),
            AppTextarea(
              label: 'Description',
              hint: 'Tell us more about the event...',
              controller: descController,
              fullWidth: true,
            ),
            const SizedBox(height: AppSpacing.s4),
            AppTextField(
              label: 'Location',
              hint: 'e.g. Conference Room A',
              controller: locationController,
              fullWidth: true,
              prefixIcon: const AppIcon(AppIconName.mapPin, size: 18),
              validator: (v) => v == null || v.isEmpty ? 'Location is required' : null,
            ),
            const SizedBox(height: AppSpacing.s4),
            AppTextField(
              label: 'Image URL',
              hint: 'https://...',
              controller: imageUrlController,
              fullWidth: true,
              prefixIcon: const AppIcon(AppIconName.grid, size: 18),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: imageUrlController,
              builder: (context, value, _) {
                final imageUrl = value.text;
                if (imageUrl.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.label('Image Preview', color: colors.primary),
                      const SizedBox(height: AppSpacing.s2),
                      AppCard(
                        padding: EdgeInsets.zero,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: Image.network(
                            imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 200,
                              width: double.infinity,
                              color: colors.border.withOpacity(0.5),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppIcon(AppIconName.grid, size: 48, color: colors.textMuted),
                                    const SizedBox(height: AppSpacing.s2),
                                    AppText.bodySm('Invalid Image URL', color: colors.textMuted),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) onDateChanged(date);
                        },
                        border: true,
                        padding: const EdgeInsets.all(AppSpacing.s3),
                        child: Row(
                          children: [
                            AppIcon(AppIconName.calendar, color: colors.primary),
                            const SizedBox(width: AppSpacing.s2),
                            AppText.bodySm(
                                selectedDate.toIso8601String().split('T')[0],
                                color: colors.primary),
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
                            initialTime: selectedTime,
                          );
                          if (time != null) onTimeChanged(time);
                        },
                        border: true,
                        padding: const EdgeInsets.all(AppSpacing.s3),
                        child: Row(
                          children: [
                            AppIcon(AppIconName.clock, color: colors.primary),
                            const SizedBox(width: AppSpacing.s2),
                            AppText.bodySm(selectedTime.format(context), color: colors.primary),
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
              onPressed: isLoading ? null : onSubmit,
              loading: isLoading,
              fullWidth: true,
              size: AppButtonSize.lg,
            ),
          ],
        ),
      ),
    );
  }
}
