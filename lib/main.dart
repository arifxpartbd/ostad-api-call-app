// import 'package:apicallapp/home_page.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomePage(),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostScreen(),
    );
  }
}

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool _isLoading = false;
  int _currentPage = 1;
  int _perPage = 10;
  List<Post> _posts = [];

  ScrollController _scrollController = ScrollController();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_isFetching &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (!_isLoading && !_isFetching) {
      setState(() {
        _isLoading = true;
        _isFetching = true;
      });

      final url =
          'https://jsonplaceholder.typicode.com/posts?_page=$_currentPage&_limit=$_perPage';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Post> newPosts =
        data.map((post) => Post.fromJson(post)).toList();

        setState(() {
          _posts.addAll(newPosts);
          _currentPage++;
          _isLoading = false;
          _isFetching = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isFetching = false;
        });
        throw Exception('Failed to fetch posts');
      }
    }
  }

  Widget _buildPostItem(Post post) {
    return ListTile(
      title: Text(post.title),
      subtitle: Text(post.body),
      leading: Text(post.id.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: ListView.separated(
        controller: _scrollController,
        itemCount: _posts.length + (_isLoading ? 1 : 0),
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          if (index < _posts.length) {
            return _buildPostItem(_posts[index]);
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
