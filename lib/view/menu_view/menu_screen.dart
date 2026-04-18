import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menu/res/components/app_cached_network_image.dart';
import 'package:menu/res/components/custom_text.dart';
import 'package:menu/res/components/not_found.dart';
import 'package:menu/res/constants/app_colors.dart';
import 'package:menu/services/shared_pref_service.dart';
import 'package:menu/view/menu_view/components/menu_header.dart';
import 'package:provider/provider.dart';
import '../../res/components/app_custom_flip_text.dart';
import '../../res/components/market_crashed_model.dart';
import '../../view_model/menu_product_view_model.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

double getFontSize(int length) {
  if (length <= 16) return 34;
  if (length <= 20) return 32;
  if (length <= 22) return 30;
  if (length <= 24) return 28;
  if (length <= 26) return 27;
  if (length <= 28) return 24;
  return 24;
}

double getImageHeight(int length) {
  if (length <= 16) return 140;
  if (length <= 20) return 120;
  if (length <= 22) return 120;
  if (length <= 24) return 110;
  if (length <= 26) return 110;
  if (length <= 28) return 100;
  return 110;
}

double getChildRatio(int length) {
  if (length <= 16) return 3.6;
  if (length <= 20) return 4.8;
  if (length <= 22) return 4.2;
  if (length <= 24) return 4.7;
  if (length <= 26) return 4.8;
  if (length <= 28) return 5.6;
  return 5.2;
}

class _MenuScreenState extends State<MenuScreen> {
  late num pageId = 1;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    final vm = Provider.of<MenuProductViewModel>(context, listen: false);

    /// 🔥 GET PAGE FROM PREF
    final page = await SharedPrefService.getPref('page');
    pageId = int.tryParse(page.toString()) ?? 1;
    await vm.getBannerApi(context, page: int.tryParse(page.toString()) ?? 1);

    /// 🔥 Set market crash callback before starting socket
    vm.onMarketCrashed = () {
      if (mounted) {
        _marketCrashDialog();
      }
    };

    vm.startSocketListener();
  }

  @override
  void dispose() {
    Provider.of<MenuProductViewModel>(context, listen: false).disposeSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MenuProductViewModel>(context);
    final categories = vm.banner?.data ?? [];

    // 🔥 TOTAL PRODUCTS COUNT
    int totalLength = categories.fold(
      0,
      (sum, cat) => sum + (cat.products?.length ?? 0),
    );

    debugPrint('TOTAL LENGTH => $totalLength');

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: vm.getMenuProductLoading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
          ? NotFound()
          : Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Image.asset(
                      'assets/images/screen_bg.png',
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                /// 🔥 LIST
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: categories.map<Widget>((cat) {
                    return categoryBlock(cat, totalLength);
                  }).toList(),
                ),
              ],
            ),
    );
  }

  /// 🔥 CATEGORY BLOCK
  Widget categoryBlock(dynamic category, int totalLength) {
    final length = category.products.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category.name != "")
          MenuHeader(pageId: pageId, title: category.name),

        const SizedBox(height: 16),

        /// 🔥 GRID (2 PRODUCT SIDE BY SIDE)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: getChildRatio(totalLength),
          ),
          itemBuilder: (context, index) {
            return ColorFiltered(
              colorFilter: category.products[index].stock == '0'
                  ? const ColorFilter.matrix([
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ])
                  : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
              child: menuItem(category.products[index], totalLength),
            );
          },
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  /// 🔥 PRODUCT ITEM
  Widget menuItem(dynamic product, int totalLength) {
    return Container(
      decoration: BoxDecoration(
        color: product.stock == '0'
            ? AppColors.darkGunmetalColor.withAlpha(100)
            : AppColors.darkGunmetalColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          /// 🔥 IMAGE
          Opacity(
            opacity: product.stock == '0' ? 0.37 : 1,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: AppCachedNetworkImage(
                imageUrl:
                    "https://site.biteexchange.com/build/assets/product_image/${product.image}",
                height: getImageHeight(totalLength),
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// 🔥 TEXT
          Expanded(
            child: Stack(
              children: [
                Opacity(
                  opacity: product.stock == '0' ? 0.37 : 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        data: product.name ?? '',
                        fontSize: getFontSize(totalLength),
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// PRICE
                          Builder(
                            builder: (context) {
                              double currentP =
                                  double.tryParse(product.price) ?? 0;
                              double menuP =
                                  double.tryParse(product.menuPrice) ?? 0;
                              double difference = currentP - menuP;
                              Color diffColor = difference > 0
                                  ? AppColors.crimsonRedColor
                                  : (difference < 0
                                        ? AppColors.primaryColor
                                        : AppColors.whiteColor);
                              return AppCustomFlipText(
                                value: num.parse(product.price),
                                prefix: '₹',
                                suffix: '.00',
                                fontSize: getFontSize(totalLength),
                                fontWeight: FontWeight.w700,
                                color: diffColor,
                              );
                            },
                          ),

                          const Spacer(),

                          /// DIFFERENCE
                          Builder(
                            builder: (context) {
                              double currentP =
                                  double.tryParse(product.price) ?? 0;
                              double menuP =
                                  double.tryParse(product.menuPrice) ?? 0;

                              double difference = currentP - menuP;

                              Color diffColor = difference > 0
                                  ? AppColors.crimsonRedColor
                                  : (difference < 0
                                        ? AppColors.primaryColor
                                        : AppColors.coolGrayColor);

                              String sign = difference > 0
                                  ? '+ '
                                  : (difference < 0 ? '- ' : '');

                              return Row(
                                children: [
                                  AppCustomFlipText(
                                    value: difference.abs(),
                                    prefix: '$sign₹',
                                    fontSize: getFontSize(totalLength) - 2,
                                    fontWeight: FontWeight.w700,
                                    color: diffColor,
                                  ),
                                  SizedBox(width: 10),
                                  if (difference != 0)
                                    RotatedBox(
                                      quarterTurns: difference > 0
                                          ? 4
                                          : 2, // up/down control
                                      child: SvgPicture.asset(
                                        'assets/svg_icon/direction_icon.svg',
                                        height: 21,
                                        width: 21,
                                        colorFilter: ColorFilter.mode(
                                          diffColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(width: 16),
                        ],
                      ),
                    ],
                  ),
                ),
                if (product.stock == '0')
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.coolGrayColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        border: BoxBorder.fromLTRB(
                          bottom: BorderSide(color: Colors.white24),
                          left: BorderSide(color: Colors.white24),
                        ),
                      ),
                      child: CustomText(
                        data: 'NA',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 MARKET CRASHED
  void _marketCrashDialog() {
    showDialog(
      context: context,
      barrierColor: AppColors.blackColor.withAlpha(140), // dark background
      builder: (context) {
        return MarketCrashedModel();
      },
    ).then((value) {
      /// 🔥 RESET AFTER CLOSE
      final vm = Provider.of<MenuProductViewModel>(context, listen: false);
      vm.resetCrash();
    });
  }
}
