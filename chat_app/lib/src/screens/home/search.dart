import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).cardTheme.color,
        appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
            // The search area here
            title: Center(
              child: TextField(
                autofocus: true,
                onSubmitted: (_textEditingController) {},
                controller: _textEditingController,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  // ignore: prefer_const_constructors
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )),
        body: const SizedBox(),
      ),
    );
  }
}
