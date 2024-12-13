import 'package:flutter/material.dart';
import '../helpers/http_helper.dart';

class MovieSelectionScreen extends StatefulWidget {
  final String sessionId;
  final String deviceId;

  const MovieSelectionScreen({
    required this.sessionId,
    required this.deviceId,
    Key? key,
  }) : super(key: key);

  @override
  _MovieSelectionScreenState createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  List<Map<String, dynamic>> _movies = [];
  int _currentIndex = 0; //Tracks the current movie being displayed
  int _currentPage = 1; // Tracks the current page of movies
  String? _feedback;
  bool _isLoading = false;
  bool _isSwiping = false; // this prevents multiple swipes during animation

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    if (_isLoading) return; // Prevent multiple simultaneous fetches

    setState(() {
      _isLoading = true;
    });

    try {
      final newMovies = await HttpHelper.fetchMovies('popular', _currentPage);
      setState(() {
        _movies.addAll(newMovies);
      });
    } catch (error) {
      debugPrint('Error fetching movies: $error'); // Log any fetch errors
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleSwipe(bool isLiked) async {
    if (_isSwiping) return;

    setState(() {
      _isSwiping = true;
      _feedback = isLiked ? 'thumbs-up' : 'thumbs-down';
    });

    // Show thumbs-up/thumbs-down feedback for 800ms
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _feedback = null;
      _currentIndex++;

      if (_currentIndex >= _movies.length) {
        _currentPage++;
        _fetchMovies();
      }

      _isSwiping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_movies.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Swipe for movies')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentMovie =
        _movies[_currentIndex]; // Get the current movie to display

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe for movies'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! > 0) {
                  // Swiped Right (thumbs-up)
                  _handleSwipe(true);
                } else if (details.primaryVelocity! < 0) {
                  // Swiped Left (thumbs-down)
                  _handleSwipe(false);
                }
              }
            },
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isSwiping ? 0.5 : 1.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display movie poster
                  if (currentMovie['poster_path'] != null)
                    Image.network(
                      'https://image.tmdb.org/t/p/w500${currentMovie['poster_path']}',
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  else
                    Image.asset(
                      'assets/images/a.blankmovieposter.jpg',
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 16),
                  // Display movie title
                  Text(
                    currentMovie['title'] ?? 'No Title',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Display release date
                  Text(
                    'Release Date: ${currentMovie['release_date'] ?? 'N/A'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      currentMovie['overview'] ?? 'No Overview',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Feedback icons (thumbs-up or thumbs-down)
          if (_feedback != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              child: Icon(
                _feedback == 'thumbs-up' ? Icons.thumb_up : Icons.thumb_down,
                size: 100,
                color: _feedback == 'thumbs-up' ? Colors.green : Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
