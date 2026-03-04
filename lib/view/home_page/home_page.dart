import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pos_menu/API/ApiExtension.dart';
import 'package:pos_menu/Infrastructor/Singleton.dart';
import 'package:pos_menu/Infrastructor/modernPopupDialog.dart';
import 'package:pos_menu/Infrastructor/providerListener.dart';
import 'package:pos_menu/Infrastructor/styleColor.dart';
import 'package:pos_menu/Singleton/screen_utile.dart';
import 'package:pos_menu/controller/category_provider.dart';
import 'package:pos_menu/controller/menu_provider.dart';
import 'package:pos_menu/controller/sale_provider.dart';
import 'package:pos_menu/model/menu/menu_model.dart';
import 'package:pos_menu/widget/action_button.dart';
import 'package:pos_menu/widget/cart_animation_overlay.dart';
import 'package:pos_menu/widget/category.dart';
import 'package:pos_menu/widget/menu_list.dart';
import 'package:pos_menu/widget/network_ImageView.dart';
import 'package:pos_menu/widget/search.dart';

class HomePage extends StatefulWidget {
  final String dbCode;
  final String? tableCode;
  const HomePage({super.key, required this.dbCode, this.tableCode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _cartIconExpandedKey = GlobalKey();
  final GlobalKey _cartIconCollapsedKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String selectedCategory = 'All';
  String? selectedCategoryCode;

  late Future combineFuture;
  late Future _menuFuture;
  late Future _categoryFuture;
  late Future _storFuture;
  late Future _getMenuFuture;

  bool _isAppBarExpanded = true;

  // Cache for scroll progress to reduce calculations
  final double _lastScrollProgress = 1.0;

  @override
  void initState() {
    Singleton().setDbCode(widget.dbCode);
    combineFuture = initData();
    _controller.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  void _onScroll() {
    final scrollExtent = _scrollController.offset;
    final newExpandedState = scrollExtent < 20;

    if (newExpandedState != _isAppBarExpanded) {
      setState(() {
        _isAppBarExpanded = newExpandedState;
      });
    }
  }

  Future<List<dynamic>> initData() {
    final api = Provider.of<ApiExtension>(context, listen: false);
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);

    _storFuture = api.getShopInfo(widget.dbCode);
    _getMenuFuture = saleProvider.getSaleOrderByTableCode(
      context: context,
      queryParams: {'DB_CODE': widget.dbCode, 'TABLE_CODE': widget.tableCode ?? ''},
    );
    // _userFuture = api.getUserProfile(context);
    _menuFuture = Provider.of<MenuProvider>(context, listen: false).getAllMenus(context);
    _categoryFuture = Provider.of<CategoryProvider>(context, listen: false).getCategory(context);

    return Future.wait([_menuFuture, _categoryFuture, _storFuture, _getMenuFuture]);
  }

  List<MenuModel> _getFilteredMenuItems(List<MenuModel> allMenus) {
    List<MenuModel> filteredMenus = allMenus;

    if (selectedCategory != 'All' && selectedCategoryCode != null) {
      filteredMenus = filteredMenus.where((menu) {
        final menuCategoryId = menu.catCode?.toString();
        return menuCategoryId == selectedCategoryCode;
      }).toList();
    }

    if (_controller.text.isNotEmpty) {
      final searchQuery = _controller.text.toLowerCase();
      filteredMenus = filteredMenus.where((menu) {
        final itemName = (menu.itemDesc ?? '').toLowerCase();
        final itemCode = (menu.itemCode).toLowerCase();
        return itemName.contains(searchQuery) || itemCode.contains(searchQuery);
      }).toList();
    }

    return filteredMenus;
  }

  GlobalKey get _activeCartIconKey {
    return _isAppBarExpanded ? _cartIconExpandedKey : _cartIconCollapsedKey;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: combineFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          }

          return Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(), // Smoother scrolling
              slivers: [
                // OPTIMIZED SLIVER APP BAR
                Consumer<ApiExtension>(
                  builder: (context, shopdataProvider, child) {
                    final stop = shopdataProvider.shopData;
                    return SliverAppBar(
                      expandedHeight: 80,
                      floating: false,
                      pinned: true,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      surfaceTintColor: Colors.transparent,
                      // CRITICAL: Reduce rebuilds by simplifying FlexibleSpace
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.zero,
                        background: _OptimizedAppBarBackground(
                          stop: stop,
                          cartIconExpandedKey: _cartIconExpandedKey,
                          dbCode: widget.dbCode,
                          tableCode: widget.tableCode,
                        ),
                        title: _OptimizedAppBarTitle(
                          stop: stop,
                          cartIconCollapsedKey: _cartIconCollapsedKey,
                          dbCode: widget.dbCode,
                          tableCode: widget.tableCode,
                        ),
                      ),
                    );
                  },
                ),
                Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Search(hint: 'Search Menu', controller: _controller),
                          Category(
                            categories: categoryProvider.categories,
                            selectedCategory: selectedCategory,
                            onSelected: (category, categoryCode) {
                              setState(() {
                                selectedCategory = category;
                                selectedCategoryCode = categoryCode;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Consumer<MenuProvider>(
                  builder: (context, menuProvider, _) {
                    final filteredMenus = _getFilteredMenuItems(menuProvider.menuItems);

                    if (filteredMenus.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              Text(
                                'No items found',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _controller.text.isNotEmpty ? 'Try adjusting your search' : 'No items in this category',
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      sliver: SliverLayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount;
                          double childAspectRatio;
                          final screenType = getScreenType(constraints.crossAxisExtent);

                          switch (screenType) {
                            case ScreenType.desktop:
                              crossAxisCount = 5;
                              childAspectRatio = 0.75;
                              break;
                            case ScreenType.tablet:
                              crossAxisCount = 4;
                              childAspectRatio = 0.75;
                              break;
                            case ScreenType.mobile:
                              crossAxisCount = 2;
                              childAspectRatio = 0.7;
                          }

                          return SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: childAspectRatio,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = filteredMenus[index];
                                // CRITICAL: Wrap in RepaintBoundary for performance
                                return RepaintBoundary(
                                  child: MenuList(item: item, index: index, cartIconKey: _activeCartIconKey),
                                );
                              },
                              childCount: filteredMenus.length,
                              // CRITICAL: Add findChildIndexCallback for better scrolling
                              findChildIndexCallback: (Key key) {
                                final valueKey = key as ValueKey<String>?;
                                if (valueKey != null) {
                                  return filteredMenus.indexWhere((item) => 'menu-item-${item.itemCode}' == valueKey.value);
                                }
                                return null;
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// OPTIMIZED: Separated app bar background to reduce rebuilds
class _OptimizedAppBarBackground extends StatelessWidget {
  final dynamic stop;
  final GlobalKey cartIconExpandedKey;
  final String dbCode;
  final String? tableCode;
  const _OptimizedAppBarBackground({required this.stop, required this.cartIconExpandedKey, required this.dbCode, this.tableCode});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final top = constraints.biggest.height;
        final scrollProgress =
            ((top - kToolbarHeight - MediaQuery.of(context).padding.top) / (70 - kToolbarHeight - MediaQuery.of(context).padding.top)).clamp(
              0.0,
              1.0,
            );
        return Opacity(
          opacity: scrollProgress,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: Hero(
                        tag: 'restaurant_logo',
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: NetworkImageview(imagePath: stop?.logo ?? '', fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Restaurant info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            minFontSize: 13,
                            maxFontSize: 18,
                            stop?.name ?? '',
                            style: TextStyle(fontSize: 18.h, fontWeight: FontWeight.bold, color: Color(0xFF2D3142), letterSpacing: -0.5, height: 1.2),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.green.shade200),
                                ),
                                child: AutoSizeText(
                                  maxFontSize: 16,
                                  minFontSize: 11,
                                  'Open Now',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ActionButton(icon: 'assets/kh-flag.png'), // icon param not used anymore
                        const SizedBox(width: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// OPTIMIZED: Separated app bar title
class _OptimizedAppBarTitle extends StatelessWidget {
  final dynamic stop;
  final GlobalKey cartIconCollapsedKey;
  final String dbCode;
  final String? tableCode;

  const _OptimizedAppBarTitle({required this.stop, required this.cartIconCollapsedKey, required this.dbCode, this.tableCode});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final top = constraints.biggest.height;
        final scrollProgress =
            ((top - kToolbarHeight - MediaQuery.of(context).padding.top) / (70 - kToolbarHeight - MediaQuery.of(context).padding.top)).clamp(
              0.0,
              1.0,
            );

        if (scrollProgress > 0.1) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  stop?.name ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: StyleColor.mainColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
