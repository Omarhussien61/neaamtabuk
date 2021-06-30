import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/model/category_tickit.dart';
import 'package:flutter_pos/service/api.dart';
import 'package:flutter_pos/utils/local/LanguageTranslated.dart';
import 'package:flutter_pos/utils/screen_size.dart';
import 'package:flutter_pos/widget/ResultOverlay.dart';
import 'package:flutter_pos/widget/custom_textfield.dart';

class Tickits extends StatefulWidget {
  const Tickits({Key key,this.vendor_id,this.order_id,this.product_id}) : super(key: key);
 final  String order_id, vendor_id,product_id;

  @override
  _TickitsState createState() => _TickitsState();
}

class _TickitsState extends State<Tickits> {
  final _formKey = GlobalKey<FormState>();
  String typeTickit, addressTickit, messageTickit,category_id;
  List<Categorytickit> _data;
@override
  void initState() {
API(context).get('ticket/categorieslist')..then((value) {
  if (value != null) {
    setState(() {
      _data = Category_tickit.fromJson(value).data;
    });
  }
});
super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Container(
                width: ScreenUtil.getWidth(context) / 2,
                child: AutoSizeText(
                  'الطلبات والمشتريات',
                  minFontSize: 10,
                  maxFontSize: 16,
                  maxLines: 1,
                )),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil.getWidth(context) / 10),
            child: Column(
              children: [
                _data == null
                    ? Container()
                    : DropdownSearch<Categorytickit>(

                      label: " نوع الشكوى ",
                      validator: (Categorytickit item) {
                        if (item == null) {
                          return "Required field";
                        } else
                          return null;
                      },
                      items: _data,
                      //  onFind: (String filter) => getData(filter),
                      itemAsString: (Categorytickit u) => u.name,
                      onChanged: (Categorytickit data) =>
                      category_id = data.id.toString(),
                    ),
                SizedBox(height: 16,),
                // MyTextFormField(
                //   intialLabel: 'low',
                //   Keyboard_Type: TextInputType.emailAddress,
                //   labelText: 'أولية الشكوى',
                //   hintText: 'أولية الشكوى',
                //   isPhone: true,
                //   validator: (String value) {
                //     if (value.isEmpty) {
                //       return 'أولية الشكوى (low & high)';
                //     }
                //     _formKey.currentState.save();
                //     return null;
                //   },
                //   onSaved: (String value) {
                //     addressTickit = value;
                //   },
                // ),
                MyTextFormField(
                  intialLabel: '',
                  keyboard_type: TextInputType.emailAddress,
                  labelText: 'عنوان الشكوى',
                  hintText: 'عنوان الشكوى',
                  isPhone: true,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'عنوان الشكوى';
                    }
                    _formKey.currentState.save();
                    return null;
                  },
                  onSaved: (String value) {
                    typeTickit = value;
                  },
                ),
                MyTextFormField(
                  intialLabel: '',
                  keyboard_type: TextInputType.emailAddress,
                  labelText: 'الرسالة',
                  hintText: 'الرسالة',
                  isPhone: true,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'الرسالة';
                    }
                    _formKey.currentState.save();
                    return null;
                  },
                  onSaved: (String value) {
                    messageTickit = value;
                  },
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: GestureDetector(
                        child: Container(
                          width: ScreenUtil.getWidth(context) / 3,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(border: Border.all(
                              color: Colors.orange)),
                          child: Center(
                            child: AutoSizeText(
                              getTransrlate(context, 'save'),
                              overflow: TextOverflow.ellipsis,
                              maxFontSize: 14,
                              maxLines: 1,
                              minFontSize: 10,
                              style:
                              TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            //setState(() => _isLoading = true);
                            API(context).post('new/ticket',
                                {
                                  "title": typeTickit,
                                  "priority": 'low',
                                  "message": messageTickit,
                                  "order_id": widget.order_id,
                                  "vendor_id": widget.vendor_id,
                                  "category_id": category_id,
                                  "product_id": widget.product_id,
                                }).then((value) {
                              if (value != null) {
                                if (value['status_code'] == 201) {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          ResultOverlay(value['message']));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          ResultOverlay("${value['message']}\n${value['errors']}"));
                                }
                              }
                            });
                          }
                        },
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        child: Container(
                          width: ScreenUtil.getWidth(context) / 3,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(border: Border.all(
                              color: Colors.grey)),
                          child: Center(
                            child: AutoSizeText(
                              getTransrlate(context, 'close'),
                              overflow: TextOverflow.ellipsis,
                              maxFontSize: 14,
                              maxLines: 1,
                              minFontSize: 10,
                              style:
                              TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        onTap: () {

                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),);
  }
}