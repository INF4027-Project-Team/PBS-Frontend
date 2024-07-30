import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/database%20access/database_service.dart';
import 'package:shop_app/objects/User.dart';
import '../../../screens/favorite/favorite_screen.dart';
import '../../../constants.dart';
import '../../../objects/Product.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;
  
  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.product.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),*/
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              // Toggle the favorite status here, you need to have setState or similar mechanism
              setState(() {
                if (!widget.product.isFavourite)
                {
                    widget.product.isFavourite= true;
                    var session = userSession();
                    String? email = session.userEmail;
                    DatabaseService _databaseService = DatabaseService();
                    _databaseService.addFavouriteToDatabase(email, widget.product);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 48,
              decoration: BoxDecoration(
                color: widget.product.isFavourite
                    ? const Color(0xFFFFE6E6)
                    : const Color(0xFFF5F6F9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: SvgPicture.asset(
                "assets/icons/Heart Icon_2.svg",
                colorFilter: ColorFilter.mode(
                  widget.product.isFavourite
                      ? const Color(0xFFFF4848)
                      : const Color(0xFFDBDEE4),
                  BlendMode.srcIn,
                ),
                height: 16,
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            widget.product.description,
            maxLines: isExpanded ? null : 3,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              children: [
                Text(
                  isExpanded ? "See Less" : "See More Detail",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                ),
                const SizedBox(width: 5),
                Icon(
                  isExpanded ? Icons.arrow_upward : Icons.arrow_forward_ios,
                  size: 12,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
