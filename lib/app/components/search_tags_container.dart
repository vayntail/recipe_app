import 'package:flutter/material.dart';

/// Parent Container with SearchContainer and TagsContainer
class SearchTagsContainer extends StatelessWidget {
  const SearchTagsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        height: 110,
        child: const Column(children: [
          /// Searchbar
          SearchContainer(),
          SizedBox(
            height: 10,
          ),
          TagsContainer(),
        ]));
  }
}

/// SearchContainer
class SearchContainer extends StatelessWidget {
  const SearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const TextField(
        decoration: InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

/// Tags Container
class TagsContainer extends StatelessWidget {
  const TagsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Tag(tagName: "tag1"),
        Tag(tagName: "tag2"),
        Tag(tagName: "tag3"),
      ],
    );
  }
}

/// Tag
class Tag extends StatelessWidget {
  const Tag({super.key, required this.tagName});

  final String tagName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: TextButton(onPressed: () => {}, child: Text(tagName)),
    );
  }
}
