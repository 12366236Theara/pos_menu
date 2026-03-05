import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_menu/API/ApiExtension.dart';
import 'package:pos_menu/Extension/appColorsExtension.dart';
import 'package:pos_menu/Infrastructor/providerListener.dart';
import 'package:pos_menu/controller/ShopLocationProvider.dart';
import 'package:pos_menu/controller/category_provider.dart';
import 'package:pos_menu/controller/item_provider.dart';
import 'package:pos_menu/view/bloked/AdminSetLocationPage%20.dart';
import 'package:pos_menu/view/home_page/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  usePathUrlStrategy();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('km')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      routes: [
        GoRoute(path: '/admin/location', builder: (context, state) => const AdminSetLocationPage()),
        GoRoute(
          path: '/:dbCode',
          builder: (context, state) {
            final dbCode = state.pathParameters['dbCode']!;
            final tableCode = state.uri.queryParameters['table'];
            return HomePage(dbCode: dbCode, tableCode: tableCode);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderListener(), lazy: false), // lazy:false so _load() runs immediately
        ChangeNotifierProvider(create: (_) => ItemProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => CategoryProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => ApiExtension(), lazy: true),
        ChangeNotifierProvider(create: (_) => ShopLocationProvider(), lazy: true),
      ],

      // ✅ Consumer reads themeMode from ProviderListener — single source of truth
      child: Consumer<ProviderListener>(
        builder: (context, providerListener, _) {
          return ScreenUtilInit(
            child: MaterialApp.router(
              title: '',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,

              themeMode: providerListener.themeMode,

              // ── Light Theme ──────────────────────────────────────────────
              theme: ThemeData(
                brightness: Brightness.light,
                fontFamily: 'NotoSans',
                scaffoldBackgroundColor: const Color(0xFFF8F8FA),
                colorScheme: const ColorScheme.light(primary: Color(0xFFE8316A), surface: Color(0xFFF2F2F7), onSurface: Color(0xFF1A1D2E)),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF1A1D2E),
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                ),
                cardTheme: CardThemeData(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),

                dividerColor: const Color(0xFFF0F0F2),
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: const Color(0xFFF2F2F7),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: BorderSide.none),
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                ),
                extensions: const [AppColorsExtension.light],
              ),

              // ── Dark Theme ───────────────────────────────────────────────
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                fontFamily: 'NotoSans',
                scaffoldBackgroundColor: Color.fromARGB(255, 37, 40, 47),
                colorScheme: const ColorScheme.dark(primary: Color(0xFFE8316A), surface: Color(0xFF252837), onSurface: Color(0xFFF0F0F5)),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color.fromARGB(255, 49, 51, 60),
                  foregroundColor: Color(0xFFF0F0F5),
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                ),
                cardTheme: CardThemeData(
                  color: Color.fromARGB(255, 34, 36, 48),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                dividerColor: const Color(0xFF2E3147),
                inputDecorationTheme: const InputDecorationTheme(
                  fillColor: Color.fromARGB(255, 58, 59, 64),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(13)), borderSide: BorderSide.none),
                  hintStyle: TextStyle(color: Color(0xFF6B6F82), fontSize: 14),
                ),
                extensions: const [AppColorsExtension.dark],
              ),

              routerConfig: _router,
            ),
          );
        },
      ),
    );
  }
}
