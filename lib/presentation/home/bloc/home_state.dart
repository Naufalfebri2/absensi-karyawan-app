import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final String? fullName;
  final String? role;
  final String? photoUrl;

  const HomeState({
    this.isLoading = false,
    this.fullName,
    this.role,
    this.photoUrl,
  });

  HomeState copyWith({
    bool? isLoading,
    String? fullName,
    String? role,
    String? photoUrl,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [isLoading, fullName, role, photoUrl];
}
