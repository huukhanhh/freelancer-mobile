import 'package:workly/features/home/domain/marketplace_repository.dart';
import 'package:workly/features/session/domain/user_session.dart';

/// Synthetic display fixtures from the marketplace composition, no real people.
class MockMarketplaceRepository implements MarketplaceRepository {
  const MockMarketplaceRepository();
  @override
  List<MarketplaceListing> recommendations(UserRole role) =>
      role == UserRole.client
      ? const [
          MarketplaceListing(
            id: 'talent-demo-1',
            title: 'Minh Anh',
            subtitle: 'UI/UX Designer',
            price: '350k/giờ',
            score: '★ 4.9',
            imageSlot: 'imgPersonRealPhotograph1',
          ),
          MarketplaceListing(
            id: 'talent-demo-2',
            title: 'Quốc Huy',
            subtitle: 'Flutter Developer',
            price: '400k/giờ',
            score: '★ 4.8',
            imageSlot: 'imgPersonRealPhotograph2',
          ),
          MarketplaceListing(
            id: 'talent-demo-3',
            title: 'Hà Linh',
            subtitle: 'Marketing Expert',
            price: '280k/giờ',
            score: '★ 5.0',
            imageSlot: 'imgPersonRealPhotograph1',
          ),
        ]
      : const [
          MarketplaceListing(
            id: 'job-demo-4',
            title: 'GreenPay · Vị trí UI/UX',
            subtitle: 'Quốc Huy Demo · Client độc lập',
            price: '12.000.000₫',
            score: '★ 92%',
            imageSlot: 'imgAdvertisementHeroPhotograph2',
          ),
          MarketplaceListing(
            id: 'job-demo-5',
            title: 'React Dashboard',
            subtitle: 'Mộc Studio · Remote',
            price: '8.000.000₫',
            score: '★ 87%',
            imageSlot: 'imgAdvertisementHeroPhotograph',
          ),
          MarketplaceListing(
            id: 'job-demo-6',
            title: 'Landing Page thương mại',
            subtitle: 'Lumi Agency · 3 ngày',
            price: '4.500.000₫',
            score: '★ 85%',
            imageSlot: 'imgRealPhoto',
          ),
        ];
}
