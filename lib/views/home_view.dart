import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  final String title;

  const HomeView({Key? key, required this.title}) : super(key: key);

  static const _menuLabelStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const _newsTitleStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static const _newsSubtitleStyle = TextStyle(
    fontSize: 13,
    color: Colors.black54,
  );

  final List<String> bannerImages = const [
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=800&q=80',
  ];

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _homeViewModel;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _items = [
    {
      'title': 'Sunset Over the Mountains',
      'subtitle': 'A beautiful sunset scene over the mountain range.',
      'imageUrl':
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'City Skyline',
      'subtitle': 'The city skyline at night with glowing lights.',
      'imageUrl':
          'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Forest Pathway',
      'subtitle': 'A peaceful pathway through the forest.',
      'imageUrl':
          'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Beach Vibes',
      'subtitle': 'Relaxing beach with clear blue water and sky.',
      'imageUrl':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Desert Dunes',
      'subtitle': 'Rolling dunes under a bright blue sky.',
      'imageUrl':
          'https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=800&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _homeViewModel = HomeViewModel();
    _loadUserData().then((_) {
      if (_homeViewModel.user != null) {
        _homeViewModel.fetchAndSaveCoordinates();
      }
    });
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final userBox = Hive.box('userBox');
    final userJson = userBox.get('user');
    if (userJson != null) {
      final userMap = json.decode(userJson);
      setState(() {
        _homeViewModel.user = UserModel.fromJson(userMap);
      });
    }
  }

  Widget _buildImageSlider() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.bannerImages.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.bannerImages[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, size: 50)),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.bannerImages.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_homeViewModel.user != null)
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildImageSlider(),
                  Text('Menu', style: HomeView._menuLabelStyle),
                  SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MenuItem(
                          icon: Icons.inbox_rounded,
                          label: 'Masuk',
                          labelStyle: HomeView._menuLabelStyle,
                          onTap: () async {
                            // try {
                            //   final response = await _homeViewModel.postAttendance(1);
                            //   if (response['jammasuk'] == null || response['jammasuk'].toString().isEmpty) {
                            //     // Navigate to absen_view page
                            if (context.mounted) {
                              Navigator.pushNamed(
                                context,
                                '/absen_view',
                                arguments: 1,   // integer dikirim ke halaman berikutnya
                              );
                            }
                            //   } else {
                            //     // Show dialog "anda sudah absen masuk"
                            //     if (context.mounted) {
                            //       showModalBottomSheet(
                            //         context: context,
                            //         builder: (context) => Container(
                            //           padding: const EdgeInsets.all(16),
                            //           child: Text(
                            //             'Anda sudah absen masuk',
                            //             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            //             textAlign: TextAlign.center,
                            //           ),
                            //         ),
                            //       );
                            //     }
                            //   }
                            // } catch (e) {
                            //   // Handle errors, show some feedback
                            //   if (context.mounted) {
                            //     showModalBottomSheet(
                            //       context: context,
                            //       builder: (context) => Container(
                            //         padding: const EdgeInsets.all(16),
                            //         child: Text(
                            //           'Anda Belum Absen Masuk',
                            //           style: const TextStyle(fontSize: 16, color: Colors.red),
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       ),
                            //     );
                            //   }
                            // }
                          },
                        ),
                        _MenuItem(
                          icon: Icons.person,
                          label: 'Pulang',
                          labelStyle: HomeView._menuLabelStyle,
                          onTap: () async {
                            try {
                              final response = await _homeViewModel.postAttendance(2);
                              if (response['jampulang'] == null || response['jampulang'].toString().isEmpty) {
                                // Navigate to pulang_view page
                                if (context.mounted) {
                                  Navigator.pushNamed(context, '/pulang_view');
                                }
                              } else {
                                // Show dialog "anda sudah absen pulang"
                                if (context.mounted) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        'Anda sudah absen pulang',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              // Handle errors, show some feedback
                              if (context.mounted) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      'Anda Hari Ini Belum Absen Pulang',
                                      style: const TextStyle(fontSize: 16, color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        _MenuItem(
                          icon: Icons.settings,
                          label: 'Donasi',
                          labelStyle: HomeView._menuLabelStyle,
                          onTap: () {},
                        ),
                      ],
                    ),

                    ..._items.map((item) => NewsItem(
                      title: item['title'] ?? '',
                      subtitle: item['subtitle'] ?? '',
                      imageUrl: item['imageUrl'] ?? '',
                      titleStyle: HomeView._newsTitleStyle,
                      subtitleStyle: HomeView._newsSubtitleStyle,
                      onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return Center(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 600,
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['title'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      Text(item['subtitle'] ?? ''),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                      },
                    )).toList(),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextStyle labelStyle;
  final VoidCallback? onTap;

  const _MenuItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.labelStyle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.blue),
            const SizedBox(height: 4),
            Text(
              label,
              style: labelStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final VoidCallback? onTap;

  const NewsItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.titleStyle,
    required this.subtitleStyle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(8)),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 65,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 65),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    width: 100,
                    height: 65,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: titleStyle),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: subtitleStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
