import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_shell.dart';
import '../widgets/app_text_field.dart';
import '../widgets/status_banner.dart';

class SearchBhScreen extends StatefulWidget {
  final String userName;
  const SearchBhScreen({super.key, this.userName = 'Guest'});
  @override
  State<SearchBhScreen> createState() => _SearchBhScreenState();
}

class _SearchBhScreenState extends State<SearchBhScreen> {
  // Sample options. Replace them with real data from the API later.
  static const _locations = ['Any location', 'Poblacion 1', 'San Isidro', 'Santa Cruz', 'Langagan'];
  static const _roomTypes = ['Any type', 'Single room', 'Shared room', 'Bedspace'];
  static const _distances = ['Any distance', 'Within 1 km', 'Within 2 km', 'Within 5 km'];
  static const _amenities = ['Wi-Fi', 'Water', 'Kitchen', 'Laundry', 'Parking', 'AC'];

  final _formKey = GlobalKey<FormState>();
  final _minPrice = TextEditingController(), _maxPrice = TextEditingController();
  final _selectedAmenities = <String>{};
  String _location = _locations.first, _roomType = _roomTypes.first, _distance = _distances.first;
  UiStatus _status = UiStatus.idle; // what the results area shows right now
  String _summary = '';
  bool _simulateError = false; // demo only: lets you see the error state

  bool get _isLoading => _status == UiStatus.loading;

  @override
  void dispose() {
    _minPrice.dispose();
    _maxPrice.dispose();
    super.dispose();
  }

  // Prices are optional, but if the user types one it must be a valid amount.
  String? _validatePrice(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return null;
    final n = double.tryParse(s);
    return (n == null || n < 0) ? 'Enter a valid amount' : null;
  }

  String? _validateMin(String? v) {
    final error = _validatePrice(v);
    if (error != null) return error;
    final min = double.tryParse(_minPrice.text.trim()), max = double.tryParse(_maxPrice.text.trim());
    return (min != null && max != null && min > max) ? 'Minimum price cannot be higher than maximum' : null;
  }

  String _buildSummary() {
    final parts = <String>[];
    final min = _minPrice.text.trim(), max = _maxPrice.text.trim();
    if (_location != _locations.first) { parts.add(_location); }
    if (min.isNotEmpty && max.isNotEmpty) { parts.add('₱$min to ₱$max'); }
    else if (min.isNotEmpty) { parts.add('from ₱$min'); }
    else if (max.isNotEmpty) { parts.add('up to ₱$max'); }
    if (_roomType != _roomTypes.first) { parts.add(_roomType); }
    if (_selectedAmenities.isNotEmpty) { parts.add(_amenities.where(_selectedAmenities.contains).join(', ')); }
    if (_distance != _distances.first) { parts.add(_distance.toLowerCase()); }
    return parts.isEmpty ? 'no filters (all boarding houses)' : parts.join(' | ');
  }

  // Validate -> block duplicate taps -> show loading -> wait -> show success or error.
  Future<void> _search() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isLoading) return;
    setState(() => _status = UiStatus.loading);
    try {
      await Future<void>.delayed(const Duration(seconds: 3)); // demo only: pretends to call the REST API
      if (_simulateError) throw Exception('Simulated connection error');
      if (!mounted) return;
      setState(() {
        _summary = _buildSummary();
        _status = UiStatus.success;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = UiStatus.error);
    }
  }

  void _reset() {
    _formKey.currentState?.reset(); // clears the text fields and dropdowns
    setState(() {
      _location = _locations.first;
      _roomType = _roomTypes.first;
      _distance = _distances.first;
      _selectedAmenities.clear();
      _status = UiStatus.idle;
    });
  }

  void _onNav(int i) {
    if (i == 0) {
      Navigator.of(context).pop(); // Home is the screen underneath
    } else if (i != 1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppShell.items[i].$3} is coming soon')));
    }
  }

  String get _title => switch (_status) {
        UiStatus.idle => 'Ready to search',
        UiStatus.loading => 'Searching boarding houses...',
        UiStatus.success => 'Search completed',
        UiStatus.error => 'Search failed',
      };

  String get _message => switch (_status) {
        UiStatus.idle => 'Set your filters above, then tap Search to look for boarding houses.',
        UiStatus.loading => 'Checking your filters against boarding houses in Cabadbaran City. This may take a few seconds.',
        UiStatus.success => 'Filters applied: $_summary. Boarding house listings will appear here once the data is connected.',
        UiStatus.error => 'We could not complete your search. Check your internet connection, then try again.',
      };

  Widget _labeled(String label, Widget child) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        child,
      ]);

  Widget _dropdown(String label, List<String> items, ValueChanged<String> onChanged) {
    final scheme = Theme.of(context).colorScheme;
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c, width: w));
    return _labeled(
      label,
      DropdownButtonFormField<String>(
        initialValue: items.first,
        isExpanded: true,
        items: [for (final i in items) DropdownMenuItem(value: i, child: Text(i))],
        onChanged: (v) => setState(() => onChanged(v!)),
        decoration: InputDecoration(filled: true, fillColor: scheme.surface, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), enabledBorder: border(scheme.outlineVariant), focusedBorder: border(scheme.primary, 2)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppShell(
      selected: 1,
      userName: widget.userName,
      onSelect: _onNav,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Search Boarding Houses', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Find the perfect place that fits your needs and budget.', style: TextStyle(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: scheme.outlineVariant)),
                child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    LayoutBuilder(builder: (context, box) {
                      final w = box.maxWidth >= 560 ? (box.maxWidth - 16) / 2 : box.maxWidth; // two columns on wide screens
                      return Wrap(spacing: 16, runSpacing: 16, children: [
                        SizedBox(width: w, child: _dropdown('Location / Barangay', _locations, (v) => _location = v)),
                        SizedBox(
                          width: w,
                          child: _labeled('Price range (₱ per month)', Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(child: AppTextField(controller: _minPrice, hint: 'Min', keyboardType: TextInputType.number, textInputAction: TextInputAction.next, validator: _validateMin)),
                            const SizedBox(width: 12),
                            Expanded(child: AppTextField(controller: _maxPrice, hint: 'Max', keyboardType: TextInputType.number, textInputAction: TextInputAction.done, validator: _validatePrice, onSubmitted: (_) => _search())),
                          ])),
                        ),
                        SizedBox(width: w, child: _dropdown('Room type', _roomTypes, (v) => _roomType = v)),
                        SizedBox(width: w, child: _dropdown('Max distance', _distances, (v) => _distance = v)),
                        SizedBox(
                          width: box.maxWidth,
                          child: _labeled('Amenities', Wrap(spacing: 8, runSpacing: 8, children: [
                            for (final a in _amenities)
                              FilterChip(label: Text(a), selected: _selectedAmenities.contains(a), selectedColor: scheme.secondaryContainer, checkmarkColor: scheme.primary, onSelected: (on) => setState(() => on ? _selectedAmenities.add(a) : _selectedAmenities.remove(a))),
                          ])),
                        ),
                      ]);
                    }),
                    const SizedBox(height: 20),
                    Row(children: [
                      Expanded(child: AppButton(label: 'Reset', isOutlined: true, onPressed: _isLoading ? null : _reset)),
                      const SizedBox(width: 12),
                      Expanded(flex: 2, child: AppButton(label: 'Search', icon: Icons.search, isLoading: _isLoading, onPressed: _search)),
                    ]),
                    const Divider(height: 32),
                    SwitchListTile(contentPadding: EdgeInsets.zero, dense: true, title: const Text('Demo: simulate a connection error'), subtitle: const Text('Turn this on to see the error state. Remove it when the API is connected.'), value: _simulateError, onChanged: (v) => setState(() => _simulateError = v)),
                  ]),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Results', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              StatusBanner(status: _status, title: _title, message: _message, onRetry: _search),
            ]),
          ),
        ),
      ),
    );
  }
}