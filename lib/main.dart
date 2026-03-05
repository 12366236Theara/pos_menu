import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_menu/API/ApiExtension.dart';
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
        // Admin route
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
        ChangeNotifierProvider(create: (_) => ItemProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => CategoryProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => ApiExtension(), lazy: true),
        ChangeNotifierProvider(create: (_) => ProviderListener(), lazy: true),
        ChangeNotifierProvider(create: (_) => ShopLocationProvider(), lazy: true),
      ],
      child: ScreenUtilInit(
        child: MaterialApp.router(
          title: '',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates, // ← Add this
          supportedLocales: context.supportedLocales, // ← Add this
          locale: context.locale,
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink), useMaterial3: true),
          routerConfig: _router,
        ),
      ),
    );
  }
}
