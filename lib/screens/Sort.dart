import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Sortdialog extends StatefulWidget {
  const Sortdialog({Key key}) : super(key: key);

  @override
  _SortdialogState createState() => _SortdialogState();
}

class _SortdialogState extends State<Sortdialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 4),
            height: 72,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Color(0xffCCCCCC),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                top: 8,
                left: 24,
                right: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ترتيب',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff7B7B7B)),
                  ),
                  IconButton(
                      icon:
                          Icon(Icons.close, size: 35, color: Color(0xff7B7B7B)),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: RadioListTile<String>(
              title: const Text('السعر الأقل الى الأعلى'),
              value: "a",
              groupValue: "b",
              onChanged: (String value) {
                setState(() {
                  //  _character = value;
                });
              },
            ),
          ),
          Container(
            color: Colors.white,
            child: RadioListTile<String>(
              title: const Text('السعر الأعلى الى الأقل'),
              value: "a",
              groupValue: "b",
              onChanged: (String value) {
                setState(() {
                  //  _character = value;
                });
              },
            ),
          ),
          Container(
            color: Colors.white,
            child: RadioListTile<String>(
              title: const Text('الأكثر مشاهدة'),
              value: "a",
              groupValue: "b",
              onChanged: (String value) {
                setState(() {
                  //  _character = value;
                });
              },
            ),
          ),
          Container(
            color: Colors.white,
            child: RadioListTile<String>(
              title: const Text('الأعلى مبيعا'),
              value: "a",
              groupValue: "b",
              onChanged: (String value) {
                setState(() {
                  //  _character = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
