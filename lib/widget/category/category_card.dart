import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/ResultOverlay.dart';
import 'package:flutter_pos/model/category_model.dart';
import 'package:flutter_pos/model/product_model.dart';
import 'package:flutter_pos/screens/productCarPage.dart';
import 'package:flutter_pos/utils/Provider/provider.dart';
import 'package:flutter_pos/utils/screen_size.dart';
import 'package:flutter_pos/utils/service/API.dart';

import '../../utils/navigator.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    Key key,
    @required this.themeColor,
    this.product,
  }) : super(key: key);

  final Provider_control themeColor;
  final Category product;

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.getWidth(context) / 2,
      margin: EdgeInsets.only(left: 16, top: 8, right: 12, bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          API(context)
              .get('site/categories/${widget.product.id}')
              .then((value) {
            if (value != null) {
              if (value['status_code'] == 200) {
                Nav.route(
                    context,
                    ProductCarPage(
                      name: widget.product.name,
                      product: Product_model.fromJson(value).data,
                    ));
              } else {
                showDialog(
                    context: context,
                    builder: (_) => ResultOverlay(value['message']));
              }
            }
          });
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 5.0,
                        spreadRadius: 1,
                        offset: Offset(0.0, 2)),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: (widget.product.photo == null)
                      ? 'http://arabimagefoundation.com/images/defaultImage.png'
                      : widget.product.photo.image,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            AutoSizeText(
              widget.product.name,
              maxLines: 1,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF5D6A78),
                fontWeight: FontWeight.w300,
              ),
              minFontSize: 11,
            )
          ],
        ),
      ),
    );
  }

  bool onLikeTapped() {
    // API(context)
    //     .post('wishlist', {"product_id": widget.product.id}).then((value) => {
    //           if (value['status'] != 'error')
    //             {
    //               setState(() {
    //                 widget.product.w = false;
    //               }),
    //               Scaffold.of(context).showSnackBar(SnackBar(
    //                   backgroundColor: mainColor,
    //                   content: Text(value['message'])))
    //             }
    //           else
    //             {
    //               setState(() {
    //                 widget.product.is_wishlisted = true;
    //               }),
    //               Scaffold.of(context).showSnackBar(SnackBar(
    //                   backgroundColor: mainColor,
    //                   content: Text(value['message'])))
    //             }
    //         });
  }
}