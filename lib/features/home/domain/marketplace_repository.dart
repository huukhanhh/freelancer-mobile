import 'package:workly/features/session/domain/user_session.dart';

class MarketplaceListing {
  const MarketplaceListing({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.score,
    required this.imageSlot,
  });
  final String id, title, subtitle, price, score, imageSlot;
}

abstract interface class MarketplaceRepository {
  List<MarketplaceListing> recommendations(UserRole role);
}
