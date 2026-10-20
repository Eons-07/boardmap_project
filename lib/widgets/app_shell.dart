import 'package:flutter/material.dart';
import 'app_logo.dart';

/// Page frame shared by the signed-in screens: top bar, sidebar (wide screens) or drawer (narrow screens).
class AppShell extends StatelessWidget {
  static const items = [
    (Icons.home_outlined, Icons.home, 'Home'),
    (Icons.search, Icons.search, 'Search'),
    (Icons.map_outlined, Icons.map, 'Map'),
    (Icons.favorite_border, Icons.favorite, 'My Favorites'),
    (Icons.mail_outline, Icons.mail, 'My Inquiries'),
    (Icons.person_outline, Icons.person, 'My Profile'),
  ];
  final int selected;
  final String userName;
  final ValueChanged<int> onSelect;
  final VoidCallback? onLogout;
  final Widget body;
  const AppShell({super.key, required this.selected, required this.userName, required this.onSelect, required this.body, this.onLogout});

  Widget _nav(BuildContext context, ValueChanged<int> onTap) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(shrinkWrap: true, children: [
      for (var i = 0; i < items.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            dense: true,
            selected: i == selected,
            selectedTileColor: scheme.secondaryContainer,
            selectedColor: scheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: Icon(i == selected ? items[i].$2 : items[i].$1),
            title: Text(items[i].$3, style: const TextStyle(fontWeight: FontWeight.w600)),
            onTap: () => onTap(i),
          ),
        ),
    ]);
  }

  Widget _user(ColorScheme scheme, bool wide) {
    final chip = Row(mainAxisSize: MainAxisSize.min, children: [
      CircleAvatar(radius: 16, backgroundColor: scheme.secondaryContainer, foregroundColor: scheme.primary, child: Text(userName.isEmpty ? '?' : userName[0].toUpperCase())),
      if (wide) ...[
        const SizedBox(width: 8),
        Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(userName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          Text('Seeker', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
        ]),
      ],
      if (onLogout != null) const Icon(Icons.keyboard_arrow_down),
    ]);
    return onLogout == null ? chip : PopupMenuButton<String>(tooltip: 'Account', onSelected: (_) => onLogout!(), itemBuilder: (_) => const [PopupMenuItem(value: 'logout', child: Text('Log out'))], child: chip);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, box) {
      final wide = box.maxWidth >= 900; // sidebar on wide screens, drawer on narrow ones
      return Scaffold(
        drawer: wide ? null : Drawer(child: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.all(20), child: AppLogo(color: scheme.primary)),
          Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: _nav(context, (i) { Navigator.of(context).pop(); onSelect(i); }))),
        ]))),
        appBar: AppBar(
          backgroundColor: scheme.surface,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          shape: Border(bottom: BorderSide(color: scheme.outlineVariant)),
          automaticallyImplyLeading: false,
          leading: wide ? null : Builder(builder: (ctx) => IconButton(tooltip: 'Menu', icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(ctx).openDrawer())),
          titleSpacing: wide ? 24 : 0,
          title: AppLogo(color: scheme.primary, size: 22),
          actions: [
            IconButton(tooltip: 'Notifications', onPressed: () {}, icon: const Badge(smallSize: 9, child: Icon(Icons.notifications_none))),
            const SizedBox(width: 8),
            _user(scheme, wide),
            const SizedBox(width: 16),
          ],
        ),
        body: wide
            ? Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                SizedBox(width: 240, child: Material(color: scheme.surface, shape: Border(right: BorderSide(color: scheme.outlineVariant)), child: Padding(padding: const EdgeInsets.all(12), child: _nav(context, onSelect)))),
                Expanded(child: body),
              ])
            : body,
      );
    });
  }
}