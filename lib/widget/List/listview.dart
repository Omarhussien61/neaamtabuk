import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../model/product_model.dart';
import '../../utils/Provider/provider.dart';
import '../product/product_List.dart';

class List_product extends StatefulWidget {
  const List_product({Key key, this.product}) : super(key: key);
  final List<Products> product;

  @override
  _List_productState createState() => _List_productState();
}

class _List_productState extends State<List_product> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.product.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ProductList(
            themeColor: themeColor,
            product: widget.product[index],
          ),
        );
      },
    );
  }
}
