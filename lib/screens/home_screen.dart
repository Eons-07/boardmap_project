import 'package:flutter/material.dart';
import '../widgets/app_text_field.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _categories = ['All', 'Rooms', 'Apartments', 'Dorms'];
  static const _tabs = [(Icons.explore_outlined, Icons.explore, 'Explore'), (Icons.bookmark_border, Icons.bookmark, 'Saved'), (Icons.map_outlined, Icons.map, 'Map'), (Icons.person_outline, Icons.person, 'Profile')];
  // Placeholder data: replace with results from your services layer.
  static const _places = <Map<String, String>>[
    {'name': 'Sunrise Boarding House', 'area': 'Near the main gate', 'price': '1,800', 'type': 'Rooms'},
    {'name': 'Mabini Residences', 'area': 'Poblacion, 5 min walk', 'price': '3,500', 'type': 'Apartments'},
    {'name': 'Scholars Dormitory', 'area': 'Campus road', 'price': '1,200', 'type': 'Dorms'},
    {'name': 'Green Lane Rooms', 'area': 'Riverside, 10 min ride', 'price': '2,100', 'type': 'Rooms'},
    {'name': 'Harbor View Flats', 'area': 'City center', 'price': '4,200', 'type': 'Apartments'},
  ];
  final _search = TextEditingController();
  int _category = 0, _tab = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String get _name {
    final n = widget.email.split('@').first;
    return n.isEmpty ? 'there' : n[0].toUpperCase() + n.substring(1);
  }

  List<Map<String, String>> get _filtered {
    final q = _search.text.trim().toLowerCase();
    return _places.where((p) => (_category == 0 || p['type'] == _categories[_category]) && (q.isEmpty || p['name']!.toLowerCase().contains(q) || p['area']!.toLowerCase().contains(q))).toList();
  }

  void _logout() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: scheme.primary, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28))),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 12, 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text('Hello, $_name', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5))),
                  IconButton(tooltip: 'Log out', onPressed: _logout, icon: const Icon(Icons.logout, color: Colors.white)),
                ]),
                Text('Where do you want to stay?', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 15)),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: AppTextField(controller: _search, hint: 'Search by name or area', icon: Icons.search, onChanged: (_) => setState(() {})),
                ),
              ]),
            ),
          ),
        ),
        Expanded(
          child: _tab != 0
              ? Center(child: Text('${_tabs[_tab].$3} is coming soon', style: TextStyle(color: scheme.onSurfaceVariant)))
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    height: 64,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => ChoiceChip(label: Text(_categories[i]), selected: _category == i, onSelected: (_) => setState(() => _category = i), showCheckmark: false),
                    ),
                  ),
                  Expanded(
                    child: _filtered.isEmpty
                        ? Center(child: Text('No places match your search.\nTry another name or area.', textAlign: TextAlign.center, style: TextStyle(color: scheme.onSurfaceVariant)))
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            itemCount: _filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (_, i) => _PlaceTile(place: _filtered[i]),
                          ),
                  ),
                ]),
        ),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [for (final t in _tabs) NavigationDestination(icon: Icon(t.$1), selectedIcon: Icon(t.$2), label: t.$3)],
      ),
    );
  }
}

class _PlaceTile extends StatelessWidget {
  final Map<String, String> place;
  const _PlaceTile({required this.place});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: scheme.outlineVariant)),
      child: Row(children: [
        Container(height: 56, width: 56, decoration: BoxDecoration(color: scheme.secondaryContainer, borderRadius: BorderRadius.circular(12)), child: Icon(Icons.home_work_outlined, color: scheme.primary)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(place['name']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(place['area']!, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13)),
            const SizedBox(height: 6),
            Text('₱${place['price']} / month', style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700)),
          ]),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
      ]),
    );
  }
}