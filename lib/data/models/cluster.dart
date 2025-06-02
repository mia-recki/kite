import '../../utils/string_utils.dart';
import 'content.dart';

/// A cluster of information about a news event
class Cluster extends Content {
  final List<Perspective> perspectives;
  final List<Article> articles;
  final Quote? quote;
  final List<Section> sections;
  final List<Domain> domains;

  const Cluster({
    required this.articles,
    required this.quote,
    required this.perspectives,
    required this.sections,
    required this.domains,
  });

  String get title => getSection('title')!.text;
  String get category => getSection('category')!.text;
  String? get location => getSection('location')?.text;

  Section? getSection(String name) => sections.where((s) => s.name == name).singleOrNull;

  Map<Domain, List<Article>> get articlesByDomain => Map.fromEntries(
    domains.map(
      (domain) => MapEntry(
        domain,
        articles.where((article) => article.domain == domain.name).toList(),
      ),
    ),
  );
}

typedef Domain = ({String name, String favicon});

sealed class Section {
  final String name;
  final String text;

  const Section(this.name, this.text);

  @override
  bool operator ==(Object other) =>
      other is Section && other.runtimeType == runtimeType && other.name == name && other.text == text;

  @override
  int get hashCode => Object.hash(runtimeType, name, text);

  @override
  String toString() => 'Section(name: $name, text: $text)';
}

class TextSection extends Section {
  const TextSection(super.name, super.text);
}

class PointsSection extends Section {
  final List<String> points;

  PointsSection(String name, {required this.points}) : super(name, points.map((p) => '\u2022 $p').join('\n'));
}

class Perspective {
  late final String title;
  late final String text;
  final List<({String name, String url})> sources;

  Perspective(String content, this.sources) {
    final split = content.colonSplit;
    title = split.$1;
    text = split.$2;
  }
}

class Quote {
  final String text;
  final String author;
  final String sourceUrl;
  final String sourceDomain;

  const Quote(this.text, this.author, this.sourceUrl, this.sourceDomain);
}

class Article {
  final String title;
  final String link;
  final String domain;
  final DateTime date;
  final String? imageUrl;
  final String? imageCaption;

  Article({
    required this.title,
    required this.link,
    required this.domain,
    required this.date,
    required this.imageUrl,
    required this.imageCaption,
  });
}
