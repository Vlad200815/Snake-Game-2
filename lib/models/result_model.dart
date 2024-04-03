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

  @override
  List<Object?> get props => [name, result, userId];
}
