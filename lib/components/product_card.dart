import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../screens/product_details/product_details_screen.dart';
import '../constants.dart';
import '../objects/Product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: (){
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(productDetails: product)), 
        );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(product.imagePath,)
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
              product.title,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
                  
                ),
                SizedBox(
                  height: 28, // Reduced height
                  width: 28, // Reduced width
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(4), // Reduced padding
                      decoration: BoxDecoration(
                        color: product.isFavourite
                            ? kPrimaryColor.withOpacity(0.15)
                            : kSecondaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Heart Icon_2.svg",
                        colorFilter: const ColorFilter.mode(
                            true
                                ? Color.fromARGB(255, 255, 0, 0)
                                : Color.fromARGB(255, 255, 255, 255),
                            BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ],
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Price (${product.currency}): ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12, // Reduced font size
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  
                ),
                
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Commission: \$${product.commission}",
                    style: const TextStyle(
                      fontSize: 12, // Reduced font size
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  
                ),
                
              ],
            )

          ],
        ),
      ),
    );
  }
}
