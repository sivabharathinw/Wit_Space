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
import '../data/model/event_model.dart';
import 'event_ref_extensions.dart';



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

        final newEvent = EventModel((b) => b
          ..id = ''
          ..title = _titleController.text
          ..description = _descController.text
          ..location = _locationController.text
          ..date = _selectedDate!
          ..time = _selectedTime!
          ..imageUrl = _imageUrlController.text
          ..createdBy = 'mockUser123'
          ..createdAt = DateTime.now()
        );


        await ref.eventNotifier.createEvent(newEvent);

        final state = ref.eventState;

        if (!mounted) return;
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        } else {
          context.goNamed('eventList');
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create event: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.eventState;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: AppText.headingLg('Create Event'),
        backgroundColor: colors.bgPage,
        elevation: 0,
      ),
      body: CreateEventForm(
        formKey: _formKey,
        titleController: _titleController,
        descController: _descController,
        locationController: _locationController,
        imageUrlController: _imageUrlController,
        selectedDate: _selectedDate,
        selectedTime: _selectedTime,
        onDateChanged: (date) => setState(() => _selectedDate = date),
        onTimeChanged: (time) => setState(() => _selectedTime = time),
        onSubmit: _submit,
        isLoading: state.isLoading,
      ),
    );
  }
}

class CreateEventForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController locationController;
  final TextEditingController imageUrlController;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final Function(DateTime) onDateChanged;
  final Function(TimeOfDay) onTimeChanged;
  final VoidCallback onSubmit;
  final bool isLoading;

  const CreateEventForm({
    super.key,
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
                          child: (imageUrl.startsWith('http')) 
                            ? Image.network(
                            imageUrl,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 220,
                              width: double.infinity,
                              color: colors.border.withOpacity(0.1),
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
                          )
                        : Container(
                            height: 220,
                            width: double.infinity,
                            color: colors.border.withOpacity(0.1),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppIcon(AppIconName.grid, size: 48, color: colors.textMuted),
                                  const SizedBox(height: AppSpacing.s2),
                                  AppText.bodySm('Enter a valid image URL', color: colors.textMuted),
                                ],
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
                            initialDate: DateTime.now(),
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
                                selectedDate == null
                                    ? 'Select Date'
                                    : selectedDate!.toIso8601String().split('T')[0],
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
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) onTimeChanged(time);
                        },
                        border: true,
                        padding: const EdgeInsets.all(AppSpacing.s3),
                        child: Row(
                          children: [
                            AppIcon(AppIconName.clock, color: colors.primary),
                            const SizedBox(width: AppSpacing.s2),
                            AppText.bodySm(
                                selectedTime == null
                                    ? 'Select time'
                                    : selectedTime!.format(context),
                                color: colors.primary),
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
              onPressed: onSubmit,
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
