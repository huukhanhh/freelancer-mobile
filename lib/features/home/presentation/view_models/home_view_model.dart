import 'package:workly/features/home/domain/marketplace_repository.dart';
import 'package:workly/features/session/domain/user_session.dart';

class HomeViewModel {
  HomeViewModel({required this.user, required MarketplaceRepository repository})
    : listings = List.unmodifiable(repository.recommendations(user.role));
  final UserSession user;
  final List<MarketplaceListing> listings;
  bool get client => user.role == UserRole.client;
  String get source => client ? '585:4563' : '585:4476';
}
