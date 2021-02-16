import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:smooth_app/pages/product_page.dart';
import 'package:smooth_ui_library/widgets/smooth_product_image.dart';

class ProductListPreviewHelper extends StatelessWidget {
  const ProductListPreviewHelper({
    @required this.list,
    @required this.iconSize,
  });

  final List<Product> list;
  final double iconSize;

  static const double _PREVIEW_SPACING = 8.0;

  @override
  Widget build(BuildContext context) {
    // Return an empty widget if the list is null
    if (list == null) {
      return SizedBox.shrink();
    }

    final List<Widget> previews = <Widget>[];
    for (final Product product in list) {
      previews.add(GestureDetector(
        onTap: () async => await Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => ProductPage(
              product: product,
            ),
          ),
        ),
        child: SmoothProductImage(
          product: product,
          width: iconSize,
          height: iconSize,
        ),
      ));
    }
    return Container(
      child: Wrap(
        direction: Axis.horizontal,
        children: previews,
        spacing: _PREVIEW_SPACING,
        runSpacing: _PREVIEW_SPACING,
      ),
      padding: const EdgeInsets.only(bottom: _PREVIEW_SPACING),
    );
  }
}
