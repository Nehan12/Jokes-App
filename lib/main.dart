import 'package:flutter/material.dart';
import 'joke_service.dart';
import 'joke.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const JokesPage(),
    );
  }
}

class JokesPage extends StatefulWidget {
  const JokesPage({Key? key}) : super(key: key);

  @override
  _JokesPageState createState() => _JokesPageState();
}

class _JokesPageState extends State<JokesPage> {
  late JokeService jokeService;
  late Future<List<Joke>> jokesFuture;

  @override
  void initState() {
    super.initState();
    jokeService = JokeService();
    jokesFuture = _loadJokes();
  }

  // Load jokes either from the network or from the cache
  Future<List<Joke>> _loadJokes() async {
    try {
      return await jokeService.fetchJokes(); // Try fetching from the network
    } catch (_) {
      return await jokeService.getCachedJokes(); // Fallback to cached jokes
    }
  }

  // Refresh jokes
  void _refreshJokes() {
    setState(() {
      jokesFuture = _loadJokes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jokes for the Day',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: FutureBuilder<List<Joke>>(
        future: jokesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load jokes'));
          } else if (snapshot.hasData) {
            List<Joke> jokes = snapshot.data!;
            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Joke ${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            jokes[index].joke,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No jokes available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshJokes,
        child: const Icon(Icons.refresh),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
