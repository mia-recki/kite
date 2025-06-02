import '../../../utils/result.dart';
import '../../exceptions.dart';
import '../cluster.dart';
import '../content.dart';

class ClusterCodable {
  static Result<List<Content>> decode(Map<String, Object?> json) => switch (json['clusters']) {
    final List<dynamic> clusters => Success(
      clusters.map((clusterJson) => _decodeSingle(clusterJson as Map<String, Object?>)).nonNulls.toList(),
    ),
    _ => Failure(InvalidClusterListException(invalidJson: json)),
  };

  static Content? _decodeSingle(Map<String, Object?> json) {
    if (json case {
      'perspectives': final List<dynamic> perspectives,
      'articles': final List<dynamic> articles,
      'domains': final List<dynamic> domains,
    }) {
      return Cluster(
        quote: _decodeQuote(json),
        perspectives: _decodePerspectives(perspectives).toList(),
        articles: _decodeArticles(articles).toList(),
        sections: [..._decodeTextSections(json), ..._decodePointsSections(json)],
        domains: _decodeDomains(domains).toList(),
      );
    }
    return null;
  }

  static Iterable<Domain> _decodeDomains(List<dynamic> domains) sync* {
    for (final domain in domains) {
      if (domain case {'name': final String name, 'favicon': final String favicon}) {
        yield (name: name, favicon: favicon);
      }
    }
  }

  static Iterable<TextSection> _decodeTextSections(Map<String, Object?> json) sync* {
    final textEntries = json.entries.where((entry) => entry.value is String);
    for (final MapEntry(:key, :value) in textEntries) {
      if ((value as String).isNotEmpty) {
        yield TextSection(key, value);
      }
    }
  }

  static Iterable<PointsSection> _decodePointsSections(Map<String, Object?> json) sync* {
    final pointsEntries = json.entries.where((entry) => entry.value is List<dynamic>);
    for (final MapEntry(:key, :value) in pointsEntries) {
      if ((value as List<dynamic>).isNotEmpty) {
        yield PointsSection(key, points: value.map((p) => p.toString()).toList());
      }
    }
  }

  static Iterable<Article> _decodeArticles(List<dynamic> articles) sync* {
    for (final article in articles) {
      if (article case {
        'title': final String title,
        'link': final String link,
        'domain': final String domain,
        'date': final String date,
        'image': final String imageUrl,
        'image_caption': final String imageCaption,
      }) {
        yield Article(
          title: title,
          link: link,
          domain: domain,
          date: DateTime.parse(date),
          imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
          imageCaption: imageUrl.isNotEmpty ? imageCaption : null,
        );
      }
    }
  }

  static Iterable<Perspective> _decodePerspectives(List<dynamic> perspectives) sync* {
    for (final perspective in perspectives) {
      if (perspective case {'text': final String text, 'sources': final List<dynamic> sources}) {
        final sourceList = sources
            .map((source) {
              if (source case {'name': final String name, 'url': final String url}) {
                return (name: name, url: url);
              }
            })
            .nonNulls
            .toList();
        yield Perspective(text, sourceList);
      }
    }
  }

  static Quote? _decodeQuote(Map<String, Object?> json) => switch ((
    json.remove('quote'),
    json.remove('quote_author'),
    json.remove('quote_source_url'),
    json.remove('quote_source_domain'),
  )) {
    (String text, String author, String url, String domain)
        when text.isNotEmpty && author.isNotEmpty && url.isNotEmpty && domain.isNotEmpty =>
      Quote(text, author, url, domain),
    _ => null,
  };
}
