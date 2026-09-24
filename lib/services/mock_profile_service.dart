import '../data/demo_profiles.dart';
import '../models/user_profile.dart';
import 'profile_service.dart';

enum ProfileScenario { complete, incomplete, longText, error }

class MockProfileService implements ProfileService {
  const MockProfileService({
    this.scenario = ProfileScenario.complete,
    this.latency = const Duration(milliseconds: 600),
  });

  final ProfileScenario scenario;
  final Duration latency;

  @override
  Future<UserProfile> fetchProfile() async {
    await Future<void>.delayed(latency);

    return switch (scenario) {
      ProfileScenario.complete => demoProfile,
      ProfileScenario.incomplete => incompleteDemoProfile,
      ProfileScenario.longText => longTextDemoProfile,
      ProfileScenario.error => throw const ProfileException(
        'No fue posible obtener el perfil.',
      ),
    };
  }
}
