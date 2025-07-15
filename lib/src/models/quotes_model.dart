class QuotesModel {
  final int? id;
  final String? quote;
  final String? author;

  QuotesModel({this.id, required this.quote, required this.author});

  factory QuotesModel.fromJson(Map<String, dynamic> data) => QuotesModel(
    id: data['id'],
    quote: data['quote'] ?? 'NA',
    author: data['author'] ?? 'NA',
  );

  Map<String, dynamic> toJson() => {'id': id, 'quote': quote, 'author': author};

  @override
  String toString() => "{'id': $id, 'quote': $quote, 'author': $author}";
}
