import 'package:equatable/equatable.dart';

class OtpState extends Equatable {
  final bool isLoading;
  final bool isVerified;
  final String? errorMessage;

  const OtpState({
    this.isLoading = false,
    this.isVerified = false,
    this.errorMessage,
  });

  OtpState copyWith({bool? isLoading, bool? isVerified, String? errorMessage}) {
    return OtpState(
      isLoading: isLoading ?? this.isLoading,
      isVerified: isVerified ?? this.isVerified,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isVerified, errorMessage];
}
