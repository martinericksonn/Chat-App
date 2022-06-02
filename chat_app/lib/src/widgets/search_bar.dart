// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  const Searchbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return searchBar(context);
  }

  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: 42,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(50)),
        child: TextButton(
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const SizedBox(
                  width: 5,
                ),
                Icon(Icons.search_rounded),
                SizedBox(
                  width: 5,
                ),
                Text('Search'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
