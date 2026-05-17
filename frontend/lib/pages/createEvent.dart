import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
 
class CreateEventScreen extends StatefulWidget {
  final UserService userService;
  final dynamic existingEvent;
 
  const CreateEventScreen({
    super.key,
    required this.userService,
    this.existingEvent,
  });
 
  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}
 
class _CreateEventScreenState extends State<CreateEventScreen> {
  static const String _baseUrl = 'http://localhost:8080';
 
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
 
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  String _selectedCategory = 'Social';
  bool _isSubmitting = false;
 
  bool get _isEditing => widget.existingEvent != null;
 
  final List<String> _categories = [
    'Academic', 'Social', 'Sports', 'Music',
    'Tech', 'Arts', 'Health', 'Career', 'Other',
  ];
 
  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final e = widget.existingEvent;
      _nameController.text = e['eventName'] ?? '';
      _descriptionController.text = e['description'] ?? '';
      _locationController.text = e['location'] ?? '';
      _priceController.text = (e['price'] ?? 0).toString();
      _selectedCategory = e['category'] ?? 'Social';
      final start = DateTime.tryParse(e['startTime'] ?? '');
      if (start != null) {
        _startDate = start;
        _startTime = TimeOfDay.fromDateTime(start);
      }
      final end = DateTime.tryParse(e['endTime'] ?? '');
      if (end != null) {
        _endDate = end;
        _endTime = TimeOfDay.fromDateTime(end);
      }
    }
  }
 
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
 
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Edit Event' : 'Create Event',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: cs.outlineVariant),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
          children: [
 
            // ── Event Name ──
            _SectionLabel('Event Name', cs: cs),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDeco(context, 'e.g. End of Semester Social', Icons.title_rounded),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
 
            const SizedBox(height: 24),
 
            // ── Category ──
            _SectionLabel('Category', cs: cs),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final selected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? cs.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? cs.primary : cs.outlineVariant,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? cs.onPrimary : cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
 
            const SizedBox(height: 24),
 
            // Start
            _SectionLabel('Start', cs: cs),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: _DateTile(
                  icon: Icons.calendar_month_rounded,
                  label: _startDate == null
                      ? 'Date'
                      : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                  isEmpty: _startDate == null,
                  cs: cs,
                  onTap: () async {
                    final p = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 730)),
                    );
                    if (p != null) setState(() => _startDate = p);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DateTile(
                  icon: Icons.access_time_rounded,
                  label: _startTime == null ? 'Time' : _startTime!.format(context),
                  isEmpty: _startTime == null,
                  cs: cs,
                  onTap: () async {
                    final p = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 17, minute: 0),
                    );
                    if (p != null) setState(() => _startTime = p);
                  },
                ),
              ),
            ]),
 
            const SizedBox(height: 16),
 
            // ── End ──
            _SectionLabel('End', cs: cs),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: _DateTile(
                  icon: Icons.calendar_month_rounded,
                  label: _endDate == null
                      ? 'Date'
                      : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                  isEmpty: _endDate == null,
                  cs: cs,
                  onTap: () async {
                    final p = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 730)),
                    );
                    if (p != null) setState(() => _endDate = p);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DateTile(
                  icon: Icons.access_time_rounded,
                  label: _endTime == null ? 'Time' : _endTime!.format(context),
                  isEmpty: _endTime == null,
                  cs: cs,
                  onTap: () async {
                    final p = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 19, minute: 0),
                    );
                    if (p != null) setState(() => _endTime = p);
                  },
                ),
              ),
            ]),
 
            const SizedBox(height: 24),
 
            // ── Location ──
            _SectionLabel('Location', cs: cs),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationController,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDeco(context, 'e.g. University Quad', Icons.location_on_rounded),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
 
            const SizedBox(height: 24),
 
            // ── Description ──
            _SectionLabel('Description', cs: cs),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: _inputDeco(context, 'Tell students what this event is about…', null),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
 
            const SizedBox(height: 24),
 
            // ── Price ──
            _SectionLabel('Price (\$)', cs: cs),
            const SizedBox(height: 8),
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDeco(context, '0.00 for free events', Icons.attach_money_rounded),
              validator: (v) {
                if (v == null || v.isEmpty) return null;
                if (double.tryParse(v) == null) return 'Enter a valid number';
                return null;
              },
            ),
 
            const SizedBox(height: 36),
 
            // ── Submit ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: _isSubmitting
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: cs.onPrimary,
                        ),
                      )
                    : Text(_isEditing ? 'Save Changes' : 'Create Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _startTime == null) {
      _snack('Please select a start date and time.');
      return;
    }
    if (_endDate == null || _endTime == null) {
      _snack('Please select an end date and time.');
      return;
    }
 
    final start = DateTime(
      _startDate!.year, _startDate!.month, _startDate!.day,
      _startTime!.hour, _startTime!.minute,
    );
    final end = DateTime(
      _endDate!.year, _endDate!.month, _endDate!.day,
      _endTime!.hour, _endTime!.minute,
    );
 
    if (end.isBefore(start)) {
      _snack('End must be after start.');
      return;
    }
 
    setState(() => _isSubmitting = true);
 
    final body = jsonEncode({
      'eventName': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'location': _locationController.text.trim(),
      'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
      'category': _selectedCategory,
      'startTime': start.toIso8601String(),
      'endTime': end.toIso8601String(),
    });
 
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': widget.userService.authHeader,
    };
 
    try {
      final response = _isEditing
          ? await http.put(
              Uri.parse('$_baseUrl/events/${widget.existingEvent['eventId']}'),
              headers: headers,
              body: body,
            )
          : await http.post(
              Uri.parse('$_baseUrl/events'),
              headers: headers,
              body: body,
            );
 
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          _snack(_isEditing ? 'Event updated!' : 'Event created!');
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) _snack('Failed (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      if (mounted) _snack('Error: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
 
  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
 
  InputDecoration _inputDeco(BuildContext context, String hint, IconData? icon) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: cs.onSurfaceVariant.withOpacity(0.6), fontSize: 14),
      prefixIcon: icon != null ? Icon(icon, color: cs.onSurfaceVariant, size: 20) : null,
      filled: true,
      fillColor: cs.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
 
// ─────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────
 
class _SectionLabel extends StatelessWidget {
  final String text;
  final ColorScheme cs;
 
  const _SectionLabel(this.text, {required this.cs});
 
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: cs.onSurface,
        letterSpacing: 0.2,
      ),
    );
  }
}
 
// ─────────────────────────────────────────────
// Date/time picker tile
// ─────────────────────────────────────────────
 
class _DateTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isEmpty;
  final ColorScheme cs;
  final VoidCallback onTap;
 
  const _DateTile({
    required this.icon,
    required this.label,
    required this.isEmpty,
    required this.cs,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          border: Border.all(
            color: isEmpty ? cs.outlineVariant : cs.primary.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: isEmpty ? cs.onSurfaceVariant : cs.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isEmpty ? cs.onSurfaceVariant : cs.onSurface,
                  fontWeight: isEmpty ? FontWeight.normal : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}