import '../models/user_profile.dart';

abstract interface class ProfileService {
  Future<UserProfile> fetchProfile();
}

class ProfileException implements Exception {
  const ProfileException(this.message);

  final String message;

  @override
  String toString() => 'ProfileException: $message';
}
