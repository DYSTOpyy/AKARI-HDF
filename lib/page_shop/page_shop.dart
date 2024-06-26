import 'package:akari_project/general/background.dart';
import 'package:akari_project/general/custom_app_bar.dart';
import 'package:akari_project/nav_bar/nav_bar.dart';
import 'package:akari_project/page_shop/shop_item.dart';
import 'package:akari_project/page_shop/shop_tile.dart';
import 'package:akari_project/general/themes.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PageShop extends StatefulWidget {
  const PageShop({super.key});

  @override
  State<PageShop> createState() => _PageShopState();
}

class _PageShopState extends State<PageShop> {
  final controller = PageController();
  final List<bool> _selections = [true, false];

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void updateButtons(int index) {
    setState(() {
      for (int buttonIndex = 0;
          buttonIndex < _selections.length;
          buttonIndex++) {
        if (buttonIndex == index) {
          _selections[buttonIndex] = true;
        } else {
          _selections[buttonIndex] = false;
        }
      }
    });
  }

  void changePage(int index) {
    updateButtons(index);
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((bool didPop) async {
        if (didPop) {
          return;
        }
        AudioPlayer back = AudioPlayer();
        await back.setSourceAsset("music/back_sound.mp3");
        await back.resume();
        Navigator.pop(context);
      }),
      child: Scaffold(
        extendBody: true,
        appBar: CustomAppBar(),
        bottomNavigationBar: NavBar(
          selected: NavButton.right,
        ),
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box('userBox').listenable(),
          builder: (context, box, _) {
            var theme = box.get("background");

            return BackgroundCustom(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: MyTheme.getTheme(theme).shop,
                        border: Border.all(
                            color: MyTheme.getTheme(theme).shop, width: 15),
                      ),
                      child: ToggleButtons(
                        isSelected: _selections,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        borderColor: MyTheme.getTheme(theme).shop,
                        fillColor: Colors.white,
                        onPressed: changePage,
                        selectedColor: MyTheme.getTheme(theme).shop,
                        children: const [
                          SizedBox(
                              width: 150,
                              child: Text(
                                "Background",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              )),
                          SizedBox(
                              width: 150,
                              child: Text(
                                "Ampoules",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ))
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: controller,
                        onPageChanged: updateButtons,
                        children: [
                          BackgroundShop(),
                          AmpouleShop(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BackgroundShop extends StatelessWidget {
  const BackgroundShop({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box('shopItemBox').listenable(),
        builder: (context, box, widget) {
          var items = box!.values
              .where((item) => item.type == ShopItemType.background)
              .toList();

          return GridView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.only(
                top: 15, left: 15, right: 15, bottom: 120),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 300,
                crossAxisCount: 2, // number of items in each row
                mainAxisSpacing: 15, // spacing between rows
                crossAxisSpacing: 15),
            itemBuilder: (context, index) {
              return ShopTile(
                item: items[index],
              );
            },
          );
        });
  }
}

class AmpouleShop extends StatelessWidget {
  const AmpouleShop({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box('shopItemBox').listenable(),
        builder: (context, box, widget) {
          var items = box!.values
              .where((item) => item.type == ShopItemType.bulb)
              .toList();

          return GridView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.only(
                top: 15, left: 15, right: 15, bottom: 120),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 300,
                crossAxisCount: 2, // number of items in each row
                mainAxisSpacing: 15, // spacing between rows
                crossAxisSpacing: 15),
            itemBuilder: (context, index) {
              return ShopTile(
                item: items[index],
              );
            },
          );
        });
  }
}
