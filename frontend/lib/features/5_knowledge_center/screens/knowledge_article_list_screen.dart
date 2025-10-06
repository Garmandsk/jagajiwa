import 'package:flutter/material.dart';

class KnowledgeArticleListScreen extends StatelessWidget {
  const KnowledgeArticleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Articles'),
      ),
      body: Center(
        child: Text('List of Knowledge Articles will be displayed here.'),
      ),
    );
  }

}