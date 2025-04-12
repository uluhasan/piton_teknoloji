import 'package:flutter/material.dart';
import '../models/podcast.dart';
import '../services/podcast_service.dart';
import 'now_playing_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PodcastService _podcastService = PodcastService();
  final TextEditingController _searchController = TextEditingController();
  List<Podcast> _trendingPodcasts = [];
  List<Podcast> _filteredPodcasts = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;
  List<Podcast> searchResults = [];
  int _selectedIndex = 0;

  final List<String> _categories = ['All', 'Life', 'Comedy', 'Tech'];

  final List<Widget> _screens = [
    const LibraryScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadTrendingPodcasts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTrendingPodcasts() async {
    setState(() => _isLoading = true);
    try {
      final podcasts = await _podcastService.getTrendingPodcasts();
      setState(() {
        _trendingPodcasts = podcasts;
        _filteredPodcasts = podcasts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _onSearchChanged() {
    _filterPodcasts(_searchController.text);
  }

  void _filterPodcasts(String query) {
    setState(() {
      if (query.isEmpty && _selectedCategory == 'All') {
        _filteredPodcasts = _trendingPodcasts;
      } else {
        _filteredPodcasts = _trendingPodcasts.where((podcast) {
          final matchesSearch = query.isEmpty ||
              podcast.title.toLowerCase().contains(query.toLowerCase()) ||
              podcast.author.toLowerCase().contains(query.toLowerCase());

          final matchesCategory = _selectedCategory == 'All' ||
              podcast.category.toLowerCase() == _selectedCategory.toLowerCase();

          return matchesSearch && matchesCategory;
        }).toList();
      }
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _filterPodcasts(_searchController.text);
    });
  }

  Future<void> searchPodcasts(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final results = await _podcastService.searchPodcasts(query);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      body: SafeArea(
        child: _selectedIndex == 0
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Podkes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[800],
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Search Bar
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Categories
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = category == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[400],
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (_) => _onCategorySelected(category),
                              backgroundColor: Colors.grey[900],
                              selectedColor: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Trending Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Trending',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_filteredPodcasts.length !=
                            _trendingPodcasts.length)
                          Text(
                            '${_filteredPodcasts.length} results',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Trending Podcasts Grid
                    if (_isLoading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_filteredPodcasts.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            'No podcasts found',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _filteredPodcasts.length,
                          itemBuilder: (context, index) {
                            final podcast = _filteredPodcasts[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NowPlayingScreen(podcast: podcast),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.purple,
                                        image: DecorationImage(
                                          image: AssetImage(podcast.imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    podcast.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    podcast.author,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              )
            : _screens[_selectedIndex - 1],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1C1B1F),
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
