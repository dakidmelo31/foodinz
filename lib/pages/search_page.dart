import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: kToolbarHeight,
          child: ListTile(
            leading: IconButton(
                icon: Icon(Icons.arrow_left_rounded), onPressed: () {}),
            title: Text("Search your craving..."),
            trailing: IconButton(icon: Icon(Icons.mic), onPressed: () {}),
          ),
        )
      ],
    ));
  }
}
