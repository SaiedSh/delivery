import 'package:delivery/model/api/generated/katte.swagger.dart';
import 'package:delivery/model/db/box/box.dart';
import 'package:delivery/model/db/shop_card_entity.dart';
import 'package:delivery/model/globals/globals.dart';
import 'package:delivery/view/components/forms/my_divider.dart';
import 'package:delivery/view/pages/payment/paymentscreen.dart';
import 'package:delivery/view/provider/index_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class MyAddToCard extends StatefulWidget {
  const MyAddToCard({
    super.key,
    required this.dto,
  });
  final ProductDto dto;

  @override
  State<MyAddToCard> createState() => _MyAddToCardState();
}

class _MyAddToCardState extends State<MyAddToCard> {
  int count = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    MyBox.shopCardBox = await Hive.openBox("shopCardBox");
    bool any = MyBox.shopCardBox.values
        .any((element) => element.producytId == widget.dto.id);
    if (any) {
      int ggCount = MyBox.shopCardBox.values
          .firstWhere((element) => element.producytId == widget.dto.id)
          .productCount;
      setState(() {
        count = ggCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 30,
      child: Visibility(
        visible: count > 0,
        replacement: RawMaterialButton(
          onPressed: () async {
            MyBox.shopCardBox = await Hive.openBox("shopCardBox");
            var userCount = count + 1;
            MyBox.shopCardBox.add(
              ShopCardEntity(
                producyName: widget.dto.name.toString(),
                producytId: widget.dto.id.toString(),
                productCount: userCount,
                productImageUrl: widget.dto.imageLink.toString(),
                description: widget.dto.shortDetail.toString(),
                productPrice: widget.dto.price.toString(),
              ),
            );
            setState(() {
              count++;
            });
            context.read<IndexCardState>().addToList("saeed 2x");
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: secondColor),
              borderRadius: BorderRadius.circular(50),
              color: secondColor,
            ),
            width: 90,
            height: 25,
            child: Center(
              child: Row(
                children: [
                  MyDivider(
                      thickness: 0.3,
                      horizontalPadding: 0,
                      dividerColor: primaryColor),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    child: Text(
                      "سفـارش",
                      style: GoogleFonts.notoNaskhArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: primaryColor),
                    ),
                  ),
                  MyDivider(
                      thickness: 0.3,
                      horizontalPadding: 0,
                      dividerColor: primaryColor),
                ],
              ),
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: primaryColor,
          ),
          width: 80,
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  MyBox.shopCardBox = await Hive.openBox("shopCardBox");
                  ShopCardEntity myItem = MyBox.shopCardBox.values.firstWhere(
                      (element) => element.producytId == widget.dto.id);
                  int index = MyBox.shopCardBox.values.toList().indexOf(myItem);
                  int userCount = myItem.productCount + 1;
                  MyBox.shopCardBox.putAt(
                    index,
                    ShopCardEntity(
                      producyName: myItem.producyName,
                      producytId: myItem.producytId,
                      productCount: userCount,
                      productImageUrl: myItem.productImageUrl,
                      description: myItem.description,
                      productPrice: myItem.productPrice,
                    ),
                  );
                  setState(
                    () {
                      //hive
                      count++;
                    },
                  );
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: secondColor,
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(50)),
                  child: Icon(
                    Icons.add,
                    size: 18,
                    color: primaryColor,
                  ),
                ),
              ),
              Text(
                '${count}x',
                style: GoogleFonts.dosis(
                    fontWeight: FontWeight.bold, fontSize: 17),
              ),
              InkWell(
                onTap: () async {
                  if (count > 1) {
                    MyBox.shopCardBox = await Hive.openBox("shopCardBox");
                    ShopCardEntity myItem = MyBox.shopCardBox.values.firstWhere(
                        (element) => element.producytId == widget.dto.id);
                    int index =
                        MyBox.shopCardBox.values.toList().indexOf(myItem);
                    int userCount = myItem.productCount - 1;
                    MyBox.shopCardBox.putAt(
                      index,
                      ShopCardEntity(
                        producyName: myItem.producyName,
                        producytId: myItem.producytId,
                        productCount: userCount,
                        productImageUrl: myItem.productImageUrl,
                        description: myItem.description,
                        productPrice: myItem.productPrice,
                      ),
                    );
                    setState(() {
                      count--;
                    });
                  } else {
                    MyBox.shopCardBox = await Hive.openBox("shopCardBox");
                    ShopCardEntity myItem = MyBox.shopCardBox.values.firstWhere(
                        (element) => element.producytId == widget.dto.id);
                    int index =
                        MyBox.shopCardBox.values.toList().indexOf(myItem);
                    int userCount = myItem.productCount - 1;
                    MyBox.shopCardBox.deleteAt(
                      index,
                    );
                    setState(() {
                      count--;
                    });
                  }
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: secondColor,
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(50)),
                  child: Column(
                    children: [
                      Icon(
                        Icons.minimize,
                        size: 18,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyAddToCardTwo extends StatefulWidget {
  MyAddToCardTwo({
    super.key,
    required this.count,
    required this.productId,
  });
  late int count;
  final String productId;

  @override
  State<MyAddToCardTwo> createState() => _MyAddToCardTwoState();
}

class _MyAddToCardTwoState extends State<MyAddToCardTwo> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 90,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: primaryColor,
        ),
        width: 80,
        height: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async {
                MyBox.shopCardBox = await Hive.openBox("shopCardBox");
                ShopCardEntity myItem = MyBox.shopCardBox.values.firstWhere(
                    (element) => element.producytId == widget.productId);
                int index = MyBox.shopCardBox.values.toList().indexOf(myItem);
                int count = myItem.productCount + 1;
                MyBox.shopCardBox.putAt(
                  index,
                  ShopCardEntity(
                      producyName: myItem.producyName,
                      producytId: myItem.producytId,
                      productCount: count,
                      productImageUrl: myItem.productImageUrl,
                      description: myItem.description,
                      productPrice: myItem.productPrice),
                );
                setState(() {
                  widget.count++;
                });
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    color: secondColor,
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  Icons.add,
                  size: 15,
                  color: primaryColor,
                ),
              ),
            ),
            Text(
              '${widget.count}x',
              style: GoogleFonts.dosis(
                  fontWeight: FontWeight.bold, fontSize: 15.5),
            ),
            InkWell(
              onTap: () async {
                if (widget.count > 1) {
                  MyBox.shopCardBox = await Hive.openBox("shopCardBox");
                  ShopCardEntity myItem = MyBox.shopCardBox.values.firstWhere(
                      (element) => element.producytId == widget.productId);
                  int index = MyBox.shopCardBox.values.toList().indexOf(myItem);
                  int count = myItem.productCount - 1;
                  MyBox.shopCardBox.putAt(
                    index,
                    ShopCardEntity(
                        producyName: myItem.producyName,
                        producytId: myItem.producytId,
                        productCount: count,
                        productImageUrl: myItem.productImageUrl,
                        description: myItem.description,
                        productPrice: myItem.productPrice),
                  );
                  setState(() {
                    widget.count--;
                  });
                } else {
                  MyBox.shopCardBox = await Hive.openBox("shopCardBox");
                  ShopCardEntity myItem = MyBox.shopCardBox.values.firstWhere(
                      (element) => element.producytId == widget.productId);
                  int index = MyBox.shopCardBox.values.toList().indexOf(myItem);
                  MyBox.shopCardBox.deleteAt(index);
                  setState(() {
                    widget.count--;
                  });
                }
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    color: secondColor,
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(50)),
                child: Column(
                  children: [
                    Icon(
                      Icons.minimize,
                      size: 15,
                      color: primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
