import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/local/LanguageTranslated.dart';
import 'package:flutter_pos/widget/ResultOverlay.dart';
import 'package:flutter_pos/widget/SearchOverlay.dart';
import 'package:flutter_pos/model/product_model.dart';
import 'package:flutter_pos/screens/product/Filter.dart';
import 'package:flutter_pos/screens/product/Sort.dart';
import 'package:flutter_pos/screens/MyCars/myCars.dart';
import 'package:flutter_pos/utils/Provider/provider.dart';
import 'package:flutter_pos/utils/navigator.dart';
import 'package:flutter_pos/utils/screen_size.dart';
import 'package:flutter_pos/service/api.dart';
import 'package:flutter_pos/widget/List/gridview.dart';
import 'package:flutter_pos/widget/List/listview.dart';
import 'package:flutter_pos/widget/app_bar_custom.dart';
import 'package:flutter_pos/widget/no_found_product.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Products_Page extends StatefulWidget {
   int id;
   String name;
   String Url;
   Products_Page({ this.id, this.name, this.Url});
  @override
  _Products_PageState createState() => _Products_PageState();
}

class _Products_PageState extends State<Products_Page> {
  List<Product> product;
  bool list = false;
  @override
  void initState() {

    API(context)
        .get(widget.Url)
        .then((value) {
      if (value != null) {
        if (value['status_code'] == 200) {
        setState(() {
          product= Product_model.fromJson(value).data;
        });
        } else {
          //Navigator.pop(context);
          showDialog(
              context: context,
              builder: (_) => ResultOverlay("${value['message']??''} ${value['errors']??''}"));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Scaffold(
      body: Column(
        children: [
          AppBarCustom(isback: true,title:widget.name ,),
          product == null
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
                Text('${product.length} ${getTransrlate(context, 'product')} '),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => Filterdialog()).then((partSelect){
                      print(partSelect);
                      API(context).post('site/checkbox/filter', partSelect).then((value) {
                        if (value != null) {
                          if (value['status_code'] == 200) {
                            setState(() {
                              product= Product_model.fromJson(value).data;

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
                      Text(' ${getTransrlate(context, 'filter')}'),
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
                          .get('${widget.Url}&sort_type=${val}')
                          .then((value) {
                        if (value != null) {
                          if (value['status_code'] == 200) {
                            setState(() {
                              product= Product_model.fromJson(value).data;

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
                      Text(' ${getTransrlate(context, 'Sort')}'),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  product == null
                      ? Container()
                      :product.isEmpty
                      ? NotFoundProduct()
                      : list
                          ? grid_product(
                              product:product,
                            )
                          : List_product(
                              product:product,
                            ),
                  SizedBox(height: 25,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
