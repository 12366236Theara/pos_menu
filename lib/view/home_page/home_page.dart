import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_menu/Extension/appColorsExtension.dart';
import 'package:pos_menu/Infrastructor/providerListener.dart';
import 'package:pos_menu/model/category/category_model.dart';
import 'package:pos_menu/model/store/store_model.dart';
import 'package:pos_menu/widget/network_ImageView.dart';
import 'package:provider/provider.dart';
import 'package:pos_menu/API/ApiExtension.dart';
import 'package:pos_menu/Infrastructor/Singleton.dart';
import 'package:pos_menu/Infrastructor/styleColor.dart';
import 'package:pos_menu/Singleton/screen_utile.dart';
import 'package:pos_menu/controller/category_provider.dart';
import 'package:pos_menu/controller/item_provider.dart';
import 'package:pos_menu/model/menu/menu_model.dart';
import 'package:pos_menu/widget/action_button.dart';
import 'package:pos_menu/widget/category.dart';
import 'package:pos_menu/widget/menu_list.dart';
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

  // ── ValueNotifier replaces setState for app-bar expand/collapse ──────────
  // Only the widgets that listen to this notifier rebuild — not the whole page.
  final ValueNotifier<bool> _isExpandedNotifier = ValueNotifier(true);

  String selectedCategory = 'All';
  String? selectedCategoryCode;

  // ── Pagination state ──────────────────────────────────────────────────────
  bool _isLoadingMore = false;
  bool _hasMorePages = true;
  int _currentPage = 1;
  static const int _pageSize = 20;

  // ── Filtered-item cache — avoids re-filtering on every Consumer rebuild ───
  // _lastAllItems tracks the source list reference so the cache is
  // automatically invalidated when the provider replaces its list (e.g.
  // after an API call) — this is what fixes "All not showing after category switch"
  List<MenuModel>? _cachedFiltered;
  List<MenuModel>? _lastAllItems;
  String? _lastSearch;
  String? _lastCat;

  // ── Debounce timer for search ─────────────────────────────────────────────
  Timer? _searchDebounce;

  late Future _combineFuture;

  @override
  void initState() {
    super.initState();
    Singleton().setDbCode(widget.dbCode);
    _combineFuture = _initData();
    _controller.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _isExpandedNotifier.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _invalidateFilterCache();
      _refreshData();
    });
  }

  void _invalidateFilterCache() {
    _cachedFiltered = null;
    _lastAllItems = null;
    _lastSearch = null;
    _lastCat = null;
  }

  void _onScroll() {
    _isExpandedNotifier.value = _scrollController.offset < 20;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      _loadNextPage();
    }
  }

  Future<List<dynamic>> _initData() async {
    final api = Provider.of<ApiExtension>(context, listen: false);
    final storeFuture = api.getShopInfo(widget.dbCode);

    _currentPage = 1;
    _hasMorePages = true;

    final menuFuture = Provider.of<ItemProvider>(
      context,
      listen: false,
    ).getItemWithPagination(context, dbcode: widget.dbCode, page: 1, limit: _pageSize);
    final categoryFuture = Provider.of<CategoryProvider>(context, listen: false).getCategory(context, dbcode: widget.dbCode);

    final results = await Future.wait([menuFuture, categoryFuture, storeFuture]);

    final meta = Provider.of<ItemProvider>(context, listen: false).itemPagination;
    if (meta != null) {
      _hasMorePages = _currentPage < (meta.totalPages ?? 1);
    }
    return results;
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingMore || !_hasMorePages) return;
    setState(() => _isLoadingMore = true);

    final provider = Provider.of<ItemProvider>(context, listen: false);
    final nextPage = _currentPage + 1;

    await provider.getItemWithPagination(
      context,
      dbcode: widget.dbCode,
      page: nextPage,
      limit: _pageSize,
      searchQry: _controller.text.isNotEmpty ? _controller.text : null,
      category: selectedCategoryCode,
    );

    final meta = provider.itemPagination;
    setState(() {
      _currentPage = nextPage;
      _hasMorePages = meta != null ? nextPage < (meta.totalPages ?? 1) : false;
      _isLoadingMore = false;
    });
  }

  Future<void> _refreshData() async {
    final provider = Provider.of<ItemProvider>(context, listen: false);

    setState(() {
      _currentPage = 1;
      _hasMorePages = true;
    });

    provider.clearItems(); 

    await provider.getItemWithPagination(
      context,
      dbcode: widget.dbCode,
      page: 1,
      limit: _pageSize,
      searchQry: _controller.text.isNotEmpty ? _controller.text : null,
      category: selectedCategoryCode,
    );

    final meta = provider.itemPagination;

    setState(() {
      _hasMorePages = meta != null ? 1 < (meta.totalPages ?? 1) : false;
    });
  }

  GlobalKey get _activeCartKey => _isExpandedNotifier.value ? _cartIconExpandedKey : _cartIconCollapsedKey;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _combineFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Theme.of(context).cardTheme.color,
            body: const Center(child: CircularProgressIndicator(color: Color(0xFFE8316A))),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('Failed to load', style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => setState(() => _combineFuture = _initData()),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).cardTheme.color,
          body: RefreshIndicator(
            color: const Color(0xFFE8316A),
            onRefresh: _refreshData,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                Consumer<ApiExtension>(
                  builder: (context, api, _) {
                    final shop = api.shopData;
                    return SliverAppBar(
                      expandedHeight: 80,
                      floating: false,
                      pinned: true,
                      shadowColor: context.appColors.header,
                      backgroundColor: context.appColors.header,
                      elevation: 0,
                      surfaceTintColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.zero,
                        background: _AppBarBackground(
                          stop: shop,
                          cartIconExpandedKey: _cartIconExpandedKey,
                          dbCode: widget.dbCode,
                          tableCode: widget.tableCode,
                        ),
                        title: _AppBarTitle(
                          stop: shop,
                          cartIconCollapsedKey: _cartIconCollapsedKey,
                          dbCode: widget.dbCode,
                          tableCode: widget.tableCode,
                        ),
                      ),
                    );
                  },
                ),

                Consumer<CategoryProvider>(
                  builder: (context, catProvider, _) {
                    return SliverPersistentHeader(
                      pinned: true,
                      delegate: _CategoryHeaderDelegate(
                        controller: _controller,
                        searchText: _controller.text, 
                        categories: catProvider.categories,
                        selectedCategory: selectedCategory,
                        isScrolled: !_isExpandedNotifier.value,
                        onSelected: (cat, code) {
                          setState(() {
                            selectedCategory = cat;
                            selectedCategoryCode = code;
                            _currentPage = 1;
                            _hasMorePages = true;
                          });

                          _invalidateFilterCache();

                          Provider.of<ItemProvider>(context, listen: false).clearItems(); // 🔥 ADD THIS

                          _refreshData();
                        },
                      ),
                    );
                  },
                ),

                Selector<ItemProvider, List<MenuModel>>(
                  selector: (_, p) => p.items,
                  builder: (context, items, _) {
                    final list = items;

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(13, 10, 13, 16),
                      sliver: SliverLayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount;
                          double aspectRatio;
                          switch (getScreenType(constraints.crossAxisExtent)) {
                            case ScreenType.desktop:
                              crossAxisCount = 5;
                              aspectRatio = 0.82;
                              break;
                            case ScreenType.tablet:
                              crossAxisCount = 4;
                              aspectRatio = 0.76;
                              break;
                            case ScreenType.mobile:
                              crossAxisCount = 2;
                              aspectRatio = 0.72; 
                          }

                          return SliverGrid(
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 260,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: aspectRatio,
                            ),
                            delegate: SliverChildBuilderDelegate((context, index) {
                              final item = list[index];

                              return RepaintBoundary(
                                key: ValueKey('menu-item-${item.itemCode}'),
                                child: MenuList(item: item, index: index, cartIconKey: _activeCartKey , itemCurr: item.itemCurreny,),
                              );
                            }, childCount: list.length),
                          );
                        },
                      ),
                    );
                  },
                ),

                SliverToBoxAdapter(
                  child: _PaginationFooter(isLoading: _isLoadingMore, hasMore: _hasMorePages, onLoadMore: _loadNextPage),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<CategoryModel> categories;
  final String selectedCategory;
  final TextEditingController controller;
  final String searchText;
  final Function(String, String?) onSelected;
  final bool isScrolled;

  const _CategoryHeaderDelegate({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
    required this.isScrolled,
    required this.controller,
    required this.searchText,
  });

  static const double _extent = 112.0;

  @override
  double get minExtent => _extent;

  @override
  double get maxExtent => _extent;

  @override
  bool shouldRebuild(_CategoryHeaderDelegate old) =>
      old.selectedCategory != selectedCategory ||
      old.categories.length != categories.length ||
      old.isScrolled != isScrolled ||
      old.searchText != searchText; 

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final scrolled = shrinkOffset > 1.0 || isScrolled;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = isDark ? const Color(0xFF161824) : const Color(0xFFF8F8FB);

    return Material(
      color: headerBg,
      elevation: scrolled ? 3 : 0,
      shadowColor: Colors.black.withOpacity(0.08),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Search(hint: 'txt.ស្វែងរក (ឈ្មោះ, លេខកូដ)'.tr(), controller: controller),
          Expanded(
            child: Category(categories: categories, selectedCategory: selectedCategory, isScrolled: scrolled, onSelected: onSelected),
          ),
        ],
      ),
    );
  }
}


class _PaginationFooter extends StatelessWidget {
  final bool isLoading;
  final bool hasMore;
  final VoidCallback onLoadMore;

  const _PaginationFooter({required this.isLoading, required this.hasMore, required this.onLoadMore});

  @override
  Widget build(BuildContext context) {
    if (!hasMore && !isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 40, height: 1, color: Colors.grey.shade200),
            const SizedBox(width: 12),
            Text(
              'All items loaded',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 12),
            Container(width: 40, height: 1, color: Colors.grey.shade200),
          ],
        ),
      );
    }

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE8316A))),
            SizedBox(width: 10),
            Text("Loading more items...", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
      child: GestureDetector(
        onTap: onLoadMore,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE8316A).withOpacity(0.4)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE8316A))),
              SizedBox(width: 10),
              Icon(Icons.expand_more_rounded, size: 18, color: Color(0xFFE8316A)),
              SizedBox(width: 6),
              Text(
                'Load More',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFE8316A)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _AppBarBackground extends StatelessWidget {
  final StoreModel? stop;
  final GlobalKey cartIconExpandedKey;
  final String dbCode;
  final String? tableCode;

  const _AppBarBackground({required this.stop, required this.cartIconExpandedKey, required this.dbCode, this.tableCode});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final top = constraints.biggest.height;
        final progress = ((top - kToolbarHeight - MediaQuery.of(context).padding.top) / (70 - kToolbarHeight - MediaQuery.of(context).padding.top))
            .clamp(0.0, 1.0);
        return Opacity(
          opacity: progress,
          child: Container(
            decoration: BoxDecoration(
              color: context.appColors.header,
              border: Border(bottom: BorderSide(color: context.appColors.header)),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: Hero(
                        tag: 'restaurant_logo',
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.appColors.card,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: NetworkImageview(imagePath: stop?.logoShop ?? '', fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AutoSizeText(
                        stop?.dbName ?? '',
                        minFontSize: 13,
                        maxFontSize: 18,
                        style: TextStyle(fontSize: 18.h, fontWeight: FontWeight.bold, color: context.appColors.textPrimary, letterSpacing: -0.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ActionButton(icon: 'assets/kh-flag.png'),
                        SizedBox(width: 12),
                      ],
                    ),
                    Consumer<ProviderListener>(
                      builder: (context, themeProvider, _) {
                        return GestureDetector(
                          onTap: themeProvider.toggle,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: themeProvider.isDark ? const Color(0xFF252837) : const Color(0xFFF2F2F7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              themeProvider.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                              size: 20,
                              color: themeProvider.isDark ? const Color(0xFFFFD166) : Colors.grey.shade600,
                            ),
                          ),
                        );
                      },
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

class _AppBarTitle extends StatelessWidget {
  final StoreModel? stop;
  final GlobalKey cartIconCollapsedKey;
  final String dbCode;
  final String? tableCode;

  const _AppBarTitle({required this.stop, required this.cartIconCollapsedKey, required this.dbCode, this.tableCode});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final top = constraints.biggest.height;
        final progress = ((top - kToolbarHeight - MediaQuery.of(context).padding.top) / (70 - kToolbarHeight - MediaQuery.of(context).padding.top))
            .clamp(0.0, 1.0);
        if (progress > 0.1) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stop?.dbName ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: StyleColor.mainColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Consumer<ProviderListener>(
                builder: (context, themeProvider, _) {
                  return GestureDetector(
                    onTap: themeProvider.toggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: themeProvider.isDark ? const Color(0xFF252837) : const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        themeProvider.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        size: 20,
                        color: themeProvider.isDark ? const Color(0xFFFFD166) : Colors.grey.shade600,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
