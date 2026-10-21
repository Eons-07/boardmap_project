
import 'package:flutter/material.dart';
import '../models/user_account.dart';
import '../widgets/app_shell.dart';
import '../widgets/photo_background.dart';
import 'login_screen.dart';
import 'search_bh_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserAccount user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  static const _places = <Map<String, String>>[
    {
      'name': 'Sunrise Boarding House',
      'area': 'Barangay San Isidro',
      'price': '3,000',
      'rating': '4.8',
      'reviews': '24',
    },
    {
      'name': 'Campus Dormitory',
      'area': 'Barangay 1 (Poblacion)',
      'price': '2,500',
      'rating': '4.6',
      'reviews': '18',
    },
    {
      'name': 'Greenview Boarding House',
      'area': 'Barangay Santa Cruz',
      'price': '2,500',
      'rating': '4.7',
      'reviews': '31',
    },
    {
      'name': 'Riverside Dorm',
      'area': 'Barangay Langagan',
      'price': '2,800',
      'rating': '4.7',
      'reviews': '21',
    },
  ];

  String get _firstName {
    final name = user.fullName.trim();
    return name.isEmpty ? 'Guest' : name.split(' ').first;
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    return hour < 12
        ? 'Good morning'
        : (hour < 18 ? 'Good afternoon' : 'Good evening');
  }

  void _openSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SearchBhScreen(user: user),
      ),
    );
  }

  void _comingSoon(BuildContext context, String page) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$page is coming soon')),
    );
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  void _onNav(BuildContext context, int i) {
    if (i == 1) {
      _openSearch(context);
    } else if (i != 0) {
      _comingSoon(context, AppShell.items[i].$3);
    }
  }

  Widget _hero(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return PhotoBackground(
      radius: 16,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$_greeting, $_firstName!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find your next home in Cabadbaran City. Explore places, compare prices, and get personalized recommendations.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.92),
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _openSearch(context),
                      child: SizedBox(
                        height: 52,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: scheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Search by location, barangay, or boarding house name...',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => _openSearch(context),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(100, 52),
                    backgroundColor: scheme.tertiary,
                    foregroundColor: scheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final cols = box.maxWidth >= 700 ? 3 : 1;
        final width = (box.maxWidth - 16 * (cols - 1)) / cols;

        final cards = <(IconData, String, String, VoidCallback)>[
          (
            Icons.map_outlined,
            'Explore Map',
            'View all boarding houses on the map',
            () => _comingSoon(context, 'Map'),
          ),
          (
            Icons.auto_awesome,
            'Get Recommendations',
            'Find places that match your preferences',
            () => _openSearch(context),
          ),
          (
            Icons.favorite_border,
            'Save Favorites',
            'Keep track of your favorite listings',
            () => _comingSoon(context, 'My Favorites'),
          ),
        ];

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final card in cards)
              SizedBox(
                width: width,
                child: _ActionCard(
                  icon: card.$1,
                  title: card.$2,
                  subtitle: card.$3,
                  onTap: card.$4,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _recommended(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final cols = box.maxWidth >= 900
            ? 4
            : (box.maxWidth >= 560 ? 2 : 1);
        final width = (box.maxWidth - 16 * (cols - 1)) / cols;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final place in _places)
              SizedBox(
                width: width,
                child: _PlaceCard(place: place),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selected: 0,
      userName: user.fullName,
      userRole: user.role,
      onSelect: (i) => _onNav(context, i),
      onLogout: () => _logout(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _hero(context),
                const SizedBox(height: 20),
                _actions(context),
                const SizedBox(height: 28),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Recommended for You',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _openSearch(context),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _recommended(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: scheme.secondaryContainer,
                child: Icon(icon, color: scheme.secondary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final Map<String, String> place;

  const _PlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: scheme.secondaryContainer,
                child: Icon(
                  Icons.home_work_outlined,
                  size: 40,
                  color: scheme.primary,
                ),
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, size: 18),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['name']!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  place['area']!,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₱${place['price']} / month',
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: scheme.tertiary),
                    const SizedBox(width: 4),
                    Text(
                      '${place['rating']} (${place['reviews']} reviews)',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
