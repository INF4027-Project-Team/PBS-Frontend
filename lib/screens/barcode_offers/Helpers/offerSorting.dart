import 'package:shop_app/screens/Dashboard/components/special_offers_card.dart';
import 'package:shop_app/objects/Product.dart';

class OfferSorting {


  // Method to get list of special offers
  List<Product> getSpecialOffers(List<Product> offersList) {
    // Identify the best offer
    Product bestOffer = offersList[0];

    // Identify the best price
    Product lowestPricedOffer = offersList[0];
    for (var offer in offersList) {
      if (offer.price < lowestPricedOffer.price) {
        lowestPricedOffer = offer;
      }
    }

    // Identify the best commission
    Product bestCommissionOffer = offersList[0];
    for (var offer in offersList) {
      if (offer.commission > bestCommissionOffer.commission) {
        bestCommissionOffer = offer;
      }
    }

    // Return the list of special offers
    return [bestOffer, lowestPricedOffer, bestCommissionOffer];
  }



  // Method to get dashboard offers
  List<Product> getDashboardOffers(List<Product> offersList) {
    // Identify the best payout offer
    Product bestPayoutOffer = Product.copy(offersList[0]);

    // Identify the best price
    Product lowestPricedOffer = Product.copy(offersList[0]);
    Product bestCommissionOffer = Product.copy(offersList[0]);
    Product latestOffer = Product.copy(offersList[0]);

    for (var offer in offersList) {
      // Identify the offer with the best selling price
      if (offer.price < lowestPricedOffer.price) {
        lowestPricedOffer = Product.copy(offer);
      }

      // Identify the offer with the highest commission
      if (offer.commission > bestCommissionOffer.commission) {
        bestCommissionOffer = Product.copy(offer);
      }

      // Identify the best payout offer
      if ((offer.price * (offer.commission / 100)) >
          (bestPayoutOffer.price * (offer.commission / 100))) {
        bestPayoutOffer = Product.copy(offer);
      }
    }

    // Set specialty types for each offer
    bestPayoutOffer.specialtyType = offerType.payout;
    lowestPricedOffer.specialtyType = offerType.price;
    bestCommissionOffer.specialtyType = offerType.rate;
    latestOffer.specialtyType = offerType.stock;

    // Return the list of dashboard offers
    return [lowestPricedOffer, bestPayoutOffer, bestCommissionOffer, latestOffer];
  }



  // Method to place special offers first
  List<Product> placeSpecialOffersFirst(List<Product> offersList, List<Product> specialOffersList) {
    // Create a set of special offers for quick lookup
    Set<Product> specialOffersSet = Set.from(specialOffersList);

    // Separate offers into special offers and regular offers
    List<Product> specialOffers = [];
    List<Product> regularOffers = [];

    for (var offer in offersList) {
      if (specialOffersSet.contains(offer)) {
        specialOffers.add(offer);
      } else {
        regularOffers.add(offer);
      }
    }

    // Combine the special offers and regular offers
    return specialOffers + regularOffers;
  }
}
