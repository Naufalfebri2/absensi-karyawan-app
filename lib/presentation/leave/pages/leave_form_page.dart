import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:table_calendar/table_calendar.dart';

import '../bloc/leave_cubit.dart';
import '../bloc/leave_state.dart';

class LeaveFormPage extends StatefulWidget {
  const LeaveFormPage({super.key});

  @override
  State<LeaveFormPage> createState() => _LeaveFormPageState();
}

class _LeaveFormPageState extends State<LeaveFormPage> {
  final TextEditingController _reasonController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _focusedDay = DateTime.now();
  String? _selectedLeaveType;

  File? _attachmentFile;
  bool _isSubmitting = false;

  static const int maxFileSizeInBytes = 5 * 1024 * 1024;

  final List<String> _leaveTypes = ['Cuti', 'Izin', 'Sakit', 'Dinas'];

  final Map<DateTime, String> _nationalHolidays = {
    DateTime(2025, 1, 1): 'Tahun Baru',
    DateTime(2025, 8, 17): 'Hari Kemerdekaan',
    DateTime(2025, 12, 25): 'Hari Raya Natal',
  };

  // ===============================
  // HELPER
  // ===============================
  bool _isSunday(DateTime d) => d.weekday == DateTime.sunday;

  bool _isNationalHoliday(DateTime d) {
    return _nationalHolidays.keys.any((h) => isSameDay(h, d));
  }

  String? _holidayNote(DateTime d) {
    for (final e in _nationalHolidays.entries) {
      if (isSameDay(e.key, d)) return e.value;
    }
    return null;
  }

  bool _isHoliday(DateTime d) => _isSunday(d) || _isNationalHoliday(d);

  int _calculateWorkingDays(DateTime start, DateTime end) {
    int total = 0;
    DateTime current = start;
    while (!current.isAfter(end)) {
      if (!_isHoliday(current)) total++;
      current = current.add(const Duration(days: 1));
    }
    return total;
  }

  int get totalDays {
    if (_startDate == null || _endDate == null) return 0;
    return _calculateWorkingDays(_startDate!, _endDate!);
  }

  bool get _isImage =>
      _attachmentFile != null &&
      [
        'jpg',
        'jpeg',
        'png',
      ].contains(_attachmentFile!.path.split('.').last.toLowerCase());

  bool get _isPdf =>
      _attachmentFile != null &&
      _attachmentFile!.path.toLowerCase().endsWith('.pdf');

  // ===============================
  // DATE FIELD
  // ===============================
  Widget _dateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: const Icon(Icons.calendar_month),
          ),
          controller: TextEditingController(
            text: value == null
                ? ''
                : '${value.day}/${value.month}/${value.year}',
          ),
        ),
      ),
    );
  }

  // ===============================
  // CALENDAR BOTTOM SHEET
  // ===============================
  void _openCalendar({required bool isStart}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: _buildCalendar(isStart),
        ),
      ),
    );
  }

  Widget _buildCalendar(bool isStart) {
    return TableCalendar(
      firstDay: DateTime(2010),
      lastDay: DateTime(2035),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) =>
          isSameDay(day, _startDate) || isSameDay(day, _endDate),
      onDaySelected: (day, focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
          if (isStart) {
            _startDate = day;
            _endDate = null;
          } else {
            _endDate = day;
          }
        });
        Navigator.pop(context);
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, _) {
          final isSunday = _isSunday(day);
          final isHoliday = _isNationalHoliday(day);

          if (isSunday || isHoliday) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isHoliday ? Colors.red.shade100 : null,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isHoliday)
                    Text(
                      _holidayNote(day)!,
                      style: const TextStyle(fontSize: 8, color: Colors.red),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            );
          }
          return null;
        },
      ),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
    );
  }

  // ===============================
  // ATTACHMENT PICKER
  // ===============================
  void _showAttachmentPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Pilih Gambar'),
              onTap: () {
                Navigator.pop(context);
                _pickAttachment(['jpg', 'jpeg', 'png']);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Pilih PDF'),
              onTap: () {
                Navigator.pop(context);
                _pickAttachment(['pdf']);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAttachment(List<String> ext) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ext,
    );

    if (!mounted || result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    final size = await file.length();

    if (size > maxFileSizeInBytes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ukuran file maksimal 5 MB')),
      );
      return;
    }

    setState(() => _attachmentFile = file);
  }

  // ===============================
  // SUBMIT
  // ===============================
  void _submit() {
    if (_selectedLeaveType == null ||
        _startDate == null ||
        _endDate == null ||
        _reasonController.text.isEmpty ||
        _attachmentFile == null ||
        totalDays == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pastikan semua data valid')),
      );
      return;
    }

    context.read<LeaveCubit>().submitLeave(
      leaveType: _selectedLeaveType!,
      startDate: _startDate!,
      endDate: _endDate!,
      reason: _reasonController.text,
      totalDays: totalDays,
      attachment: _attachmentFile!,
    );
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajukan Cuti / Izin')),
      body: BlocListener<LeaveCubit, LeaveState>(
        listener: (context, state) {
          setState(() => _isSubmitting = state is LeaveLoading);

          if (state is LeaveSuccess) Navigator.pop(context);
          if (state is LeaveError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                hint: const Text('Jenis Cuti'),
                items: _leaveTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedLeaveType = v),
              ),
              const SizedBox(height: 16),

              _dateField(
                label: 'Tanggal Mulai',
                value: _startDate,
                onTap: () => _openCalendar(isStart: true),
              ),
              const SizedBox(height: 16),
              _dateField(
                label: 'Tanggal Akhir',
                value: _endDate,
                onTap: () => _openCalendar(isStart: false),
              ),

              const SizedBox(height: 12),
              Text(
                'Total Hari Kerja: $totalDays',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),
              TextField(
                controller: _reasonController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Alasan'),
              ),

              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _showAttachmentPicker,
                icon: const Icon(Icons.attach_file),
                label: Text(
                  _attachmentFile == null
                      ? 'Pilih Lampiran'
                      : _attachmentFile!.path.split('/').last,
                ),
              ),

              const SizedBox(height: 12),
              if (_isImage)
                Image.file(_attachmentFile!, height: 150, fit: BoxFit.cover),
              if (_isPdf)
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(_attachmentFile!.path.split('/').last),
                  trailing: TextButton(
                    onPressed: () => OpenFile.open(_attachmentFile!.path),
                    child: const Text('Lihat'),
                  ),
                ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _attachmentFile == null || _isSubmitting
                      ? null
                      : _submit,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                      : const Text('Ajukan Cuti'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
