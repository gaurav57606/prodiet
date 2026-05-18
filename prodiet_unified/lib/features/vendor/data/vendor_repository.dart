import 'package:dartz/dartz.dart';
import 'package:prodiet_unified/core/services/supabase_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'package:prodiet_unified/core/error/error_handler.dart';
import 'package:prodiet_unified/core/utils/deep_link_builder.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';

class VendorRepository {
  final SupabaseService _supabase;
  final AnalyticsService _analytics;

  VendorRepository(this._supabase, this._analytics);

  Future<Either<AppError, void>> searchIngredient({
    required String userId,
    required String ingredient,
    required String platform,
  }) async {
    try {
      Uri url;
      switch (platform.toLowerCase()) {
        case 'blinkit':
          url = DeepLinkBuilder.blinkit(ingredient);
          break;
        case 'zepto':
          url = DeepLinkBuilder.zepto(ingredient);
          break;
        case 'bigbasket':
          url = DeepLinkBuilder.bigbasket(ingredient);
          break;
        case 'swiggy_instamart':
          url = DeepLinkBuilder.swiggyInstamart(ingredient);
          break;
        default:
          return Left(ValidationError(
            field: 'platform',
            message: 'Invalid platform: $platform',
          ));
      }

      await _supabase.perform((client) async {
        await client.from('vendor_searches').insert({
          'user_id': userId,
          'query': ingredient,
          'platform': platform,
          'type': 'ingredient',
          'created_at': DateTime.now().toIso8601String(),
        });
      }, context: 'vendor.searchIngredient');

      _analytics.logEvent(
        'vendor_redirect',
        parameters: {
          'user_id': userId,
          'platform': platform,
          'ingredient': ingredient,
          'screen': 'shopping_list',
        },
      );

      // 2. Launch URL
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return const Right(null);
      } else {
        return Left(UnknownError(message: 'Could not launch $platform'));
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: 'VendorRepository.searchIngredient'));
    }
  }

  Future<Either<AppError, void>> orderFood({
    required String userId,
    required String dishQuery,
    required String platform,
  }) async {
    try {
      Uri url;
      switch (platform.toLowerCase()) {
        case 'zomato':
          url = DeepLinkBuilder.zomato(dishQuery);
          break;
        case 'swiggy':
          url = DeepLinkBuilder.swiggyFood(dishQuery);
          break;
        default:
          return Left(ValidationError(
            field: 'platform',
            message: 'Invalid platform: $platform',
          ));
      }

      await _supabase.perform((client) async {
        await client.from('vendor_searches').insert({
          'user_id': userId,
          'query': dishQuery,
          'platform': platform,
          'type': 'food_order',
          'created_at': DateTime.now().toIso8601String(),
        });
      }, context: 'vendor.orderFood');

      _analytics.logEvent(
        'vendor_redirect',
        parameters: {
          'user_id': userId,
          'platform': platform,
          'dish': dishQuery,
          'type': 'food_order',
          'screen': 'food_order_screen',
        },
      );

      // 2. Launch URL
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return const Right(null);
      } else {
        return Left(UnknownError(message: 'Could not launch $platform'));
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e, context: 'VendorRepository.orderFood'));
    }
  }
}
