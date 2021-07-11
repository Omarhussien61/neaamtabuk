import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/model/cart_model.dart';
import 'package:flutter_pos/service/api.dart';
import 'package:flutter_pos/utils/Provider/ServiceData.dart';
import 'package:flutter_pos/utils/Provider/provider.dart';
import 'package:flutter_pos/utils/local/LanguageTranslated.dart';
import 'package:flutter_pos/utils/screen_size.dart';
import 'package:flutter_pos/widget/ResultOverlay.dart';
import 'package:flutter_pos/widget/custom_textfield.dart';
import 'package:provider/provider.dart';

class ProductCart extends StatefulWidget {
  const ProductCart({
    Key key,
    @required this.themeColor,
    this.carts,
  }) : super(key: key);

  final Provider_control themeColor;
  final OrderDetails carts;

  @override
  _ProductCartState createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  List<String> items = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "other",
  ];

  bool other = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ServiceData = Provider.of<Provider_Data>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ScreenUtil.getWidth(context) / 3.5,
                child: CachedNetworkImage(
                  imageUrl: widget.carts.productImage.isNotEmpty
                      ? widget.carts.productImage[0].image
                      : '',
                  errorWidget: (context, url, error) => Icon(
                    Icons.image,
                    color: Colors.black12,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    deleteItem(ServiceData);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey,
                  )),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          //width: ScreenUtil.getWidth(context) / 1.7,
          padding: EdgeInsets.only(left: 10, top: 2, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AutoSizeText(
                widget.carts.productName,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                minFontSize: 11,
              ),
              SizedBox(
                height: 10,
              ),
              widget.carts.quantity >= 5
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 12),
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // items == null
                          //     ? Container()
                          //     : items.isEmpty
                          //     ? Container()
                          //     : widget.carts.quantity == null
                          //     ? Container()
                          //     : Container(
                          //   margin: const EdgeInsets.symmetric(
                          //       horizontal: 2, vertical: 2),
                          //   padding: const EdgeInsets.all(3.0),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           color: Colors.black12)),
                          //   child: DropdownButton<String>(
                          //     value:widget.carts.quantity==6?"other":  widget.carts.quantity.toString(),
                          //     icon: const Icon(Icons
                          //         .arrow_drop_down_outlined),
                          //     iconSize: 24,
                          //     elevation: 16,
                          //     underline: Container(),
                          //     style: const TextStyle(
                          //         height: 1,
                          //         color: Colors.deepPurple),
                          //     onChanged: (String newValue) {
                          //       setState(() {
                          //         widget.carts.quantity = int.parse(newValue=="other"?'6':newValue);
                          //       });
                          //     },
                          //     items: items.map<
                          //         DropdownMenuItem<String>>(
                          //             (String value) {
                          //           return DropdownMenuItem<String>(
                          //             value: value,
                          //             child: Center(
                          //                 child: Text(
                          //                   "$value",
                          //                   textAlign: TextAlign.center,
                          //                 )),
                          //           );
                          //         }).toList(),
                          //   ),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    other = !other;
                                  });
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                            width: 50,
                                            child:
                                                Text("${widget.carts.quantity}")),
                                        Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: ScreenUtil.getWidth(context) / 2.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: AutoSizeText(
                                        getTransrlate(context, 'price'),
                                        maxLines: 1,
                                        minFontSize: 18,
                                        style: TextStyle(fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: AutoSizeText(
                                        " ${widget.carts.total} ${getTransrlate(context, 'Currency')}",
                                        maxLines: 1,
                                        minFontSize: 18,
                                        style: TextStyle(
                                            color: widget.themeColor.getColor(),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                          !other
                              ? Container(
                                  child: Form(
                                    key: _formKey,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 10,
                                          left: 2,
                                          right: 2,
                                          top: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black12)),
                                      height: 90,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "${getTransrlate(context, 'quantity')} :",
                                          ),

                                          Container(
                                            width: 100,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2, vertical: 12),
                                            padding: const EdgeInsets.all(3.0),
                                            child: MyTextFormField(
                                              istitle: true,
                                              intialLabel: widget.carts.quantity.toString(),
                                              keyboard_type:
                                                  TextInputType.number,
                                              labelText: getTransrlate(
                                                  context, 'quantity'),
                                              hintText: getTransrlate(
                                                  context, 'quantity'),
                                              isPhone: true,
                                              validator: (String value) {
                                                if (value.isEmpty) {
                                                  return "كمية";
                                                }
                                                _formKey.currentState.save();
                                                return null;
                                              },
                                              onSaved: (String value) {
                                                widget.carts.quantity =
                                                    int.parse(value);
                                              },
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                _formKey.currentState.save();
                                                API(context)
                                                    .post('add/to/cart', {
                                                  "product_id":
                                                      widget.carts.productId,
                                                  "quantity":
                                                      widget.carts.quantity,
                                                  "order_id":
                                                      widget.carts.orderId
                                                }).then((value) {
                                                  if (value != null) {
                                                    if (value['status_code'] ==
                                                        200) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              ResultOverlay(value[
                                                                  'message']));

                                                      ServiceData.getCart(
                                                          context);
                                                    } else {
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              ResultOverlay(value[
                                                                  'message']));
                                                    }
                                                  }
                                                });
                                              }
                                            },
                                            child: Container(
                                              height: 50,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 1),
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              color: Colors.lightGreen,
                                              child: Center(
                                                  child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.cart,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    getTransrlate(
                                                        context, 'updateCart'),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: ScreenUtil.getWidth(context) / 2.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: AutoSizeText(
                                  getTransrlate(context, 'quantity'),
                                  maxLines: 1,
                                  minFontSize: 16,
                                  maxFontSize: 25,
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    height: 50,
                                    width: 43,
                                    child: Center(
                                        child: IconButton(
                                      icon: Icon(Icons.add, color: Colors.grey),
                                      onPressed: () {
                                        API(context).post('add/to/cart', {
                                          "product_id": widget.carts.productId,
                                          "quantity": widget.carts.quantity + 1,
                                          "order_id": widget.carts.orderId
                                        }).then((value) {
                                          if (value != null) {
                                            if (value['status_code'] == 200) {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => ResultOverlay(
                                                      value['message']));

                                              ServiceData.getCart(context);
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => ResultOverlay(
                                                      value['errors']));
                                            }
                                          }
                                        });
                                      },
                                    )),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                        child:
                                            Text("${widget.carts.quantity}")),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    width: 43,
                                    height: 50,
                                    child: Center(
                                        child: IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {widget.carts.quantity==1?deleteItem(ServiceData) :
                                        API(context).post('add/to/cart', {
                                          "product_id": widget.carts.productId,
                                          "quantity": widget.carts.quantity - 1,
                                          "order_id": widget.carts.orderId
                                        }).then((value) {
                                          if (value != null) {
                                            if (value['status_code'] == 200) {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => ResultOverlay(
                                                      value['message']));

                                              ServiceData.getCart(context);
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => ResultOverlay(
                                                      value['errors']));
                                            }
                                          }
                                        });
                                      },
                                    )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: ScreenUtil.getWidth(context) / 2.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: AutoSizeText(
                                  getTransrlate(context, 'price'),
                                  maxLines: 1,
                                  minFontSize: 18,
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: AutoSizeText(
                                  " ${widget.carts.total} ${getTransrlate(context, 'Currency')}",
                                  maxLines: 1,
                                  minFontSize: 18,
                                  style: TextStyle(
                                      color: widget.themeColor.getColor(),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Container(
                  height: 1,
                  color: Colors.black12,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void deleteItem(Provider_Data ServiceData) {
    API(context).post('delete/from/cart', {
      "order_id": widget.carts.orderId,
      "product_id": widget.carts.productId
    }).then((value) {
      if (value != null) {
        if (value['status_code'] == 200) {
          showDialog(
              context: context,
              builder: (_) => ResultOverlay(value['message']));
          ServiceData.getCart(context);
        } else {
          showDialog(
              context: context,
              builder: (_) => ResultOverlay(value['errors']));
        }
      }
    });
  }
}
