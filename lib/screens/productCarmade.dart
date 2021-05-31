import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/widget/ResultOverlay.dart';
import 'package:flutter_pos/widget/SearchOverlay.dart';
import 'package:flutter_pos/model/product_model.dart';
import 'package:flutter_pos/screens/Filter.dart';
import 'package:flutter_pos/screens/Sort.dart';
import 'package:flutter_pos/screens/MyCars/myCars.dart';
import 'package:flutter_pos/utils/Provider/provider.dart';
import 'package:flutter_pos/utils/navigator.dart';
import 'package:flutter_pos/utils/screen_size.dart';
import 'package:flutter_pos/service/api.dart';
import 'package:flutter_pos/widget/List/gridview.dart';
import 'package:flutter_pos/widget/List/listview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProductCarmade extends StatefulWidget {
   List<Products> product;
   String api;
   int id;
   String name;
   ProductCarmade({this.product, this.id, this.name, this.api});
  @override
  _ProductCarmadeState createState() => _ProductCarmadeState();
}

class _ProductCarmadeState extends State<ProductCarmade> {
  bool list = false;
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              color: themeColor.getColor(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                    ),
                    color: Color(0xffE4E4E4),
                  ),
                  Container(
                    width: ScreenUtil.getWidth(context) / 4,
                    child: AutoSizeText(
                      widget.name == null
                          ? "نتائج البحث"
                          : 'نتائج البحث عن\n${widget.name}',
                      maxLines: 2,
                      maxFontSize: 15,
                      minFontSize: 10,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Nav.route(context, MyCars());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/car2.svg',
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            width: ScreenUtil.getWidth(context) / 4,
                            child: Text(
                              themeColor.getCar_made(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ))
                      ],
                    ),
                    color: Color(0xffE4E4E4),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context, builder: (_) => SearchOverlay());
                    },
                    icon: Icon(
                      Icons.search,
                      size: 30,
                    ),
                    color: Color(0xffE4E4E4),
                  ),
                ],
              ),
            ),
            widget.product == null
                ? Container()
                : Container(
                    color: Colors.black26,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              list ? list = false : list = true;
                            });
                          },
                          icon: Icon(
                            list
                                ? Icons.table_rows_outlined
                                : Icons.apps_outlined,
                            color: Colors.black45,
                            size: 25,
                          ),
                          // color: Color(0xffE4E4E4),
                        ),
                        Text('${widget.product.length} منتج'),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => Filterdialog());
                          },
                          child: Row(
                            children: [
                              Text('تصفية'),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context, builder: (_) => Sortdialog()).then((val){
                              print(val);
                              API(context)
                                  .get('${widget.api}?sort_type=${val}')
                                  .then((value) {
                                if (value != null) {
                                  if (value['status_code'] == 200) {
                                 setState(() {
                                   widget.product= Product_model.fromJson(value).data;

                                 });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (_) => ResultOverlay(value['message']));
                                  }
                                }
                              });
                            });
                          },
                          child: Row(
                            children: [
                              Text('ترتيب'),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 30,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
            widget.product == null
                ? Container()
                : list
                    ? grid_product(
                        product: widget.product,
                      )
                    : List_product(
                        product: widget.product,
                      ),
          ],
        ),
      ),
    );
  }
}