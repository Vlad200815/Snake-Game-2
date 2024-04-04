import 'package:equatable/equatable.dart';

class Result extends Equatable {
  final String name;
  final int result;
  final String userId;

  const Result({
    required this.name,
    required this.result,
    required this.userId,
  });

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'result': result,
      'userId': userId,
    };
  }

  static Result formDocument(Map<String, dynamic> doc) {
    return Result(
      name: doc['name'],
      userId: doc['userId'],
      result: doc['result'],
    );
  }

  @override
  List<Object?> get props => [name, result, userId];
}
