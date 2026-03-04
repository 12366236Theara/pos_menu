// ignore_for_file: constant_identifier_names
// https://
class Domain {
  // static String domainName = "192.168.1.103"; // for test on IOS simulator
  // static String domainName = "51.79.251.248";
  // static String domainName = "136.228.128.138";

  // PROD
  // static String domainName = "51.79.251.248";
  // static String port = "12010";
  // static String portSocket = "12012";
  // static String jsReport = "12011";

  //local dev
  static String domainName = "192.168.1.137";
  static String port = "3000";
  static String portSocket = "3002";
  static String jsReport = "3001";

  // static String domainName = "192.168.1.210";
  // static String port = "13010";
  // static String portSocket = "13012";
  // static String jsReport = "13011";

  // DEV URL
  // static String domainName = "192.168.1.177";
  // static String port = "10010";
  // static String portSocket = "10012";
  // static String jsReport = "10011";

  static String domain = "http://$domainName:$port";
  static String domainSocket = "http://$domainName:$portSocket";
  static String domainImageSmall = "http://$domainName:$port/api/v2/imageresize?url=";
  static String baseUrl = "http://$domainName:$port";

  //   PRODUCTION :
  // Subdomain : mbrest.tonairedigital.net
  // IP 51.79.251.248:12010
  // SOCKET : 51.79.251.248:12012

  // DEV : mbrestdev.tonairedigital.net
  // Subdomain : mbrestdev.toaniredigital.net
  // IP :136.228.128.138:12010
  // SOCKET : 136.228.128.138:12012

  // Sub Domain DEV
  // static String domain = "https://mbrestdev.tonairedigital.net";
  // static String domainSocket = "https://mbrestdevsocket.tonairedigital.net";
  // static String baseUrl = domain;

  // Sub Domain Production
  // static String domain = "https://mbrest.tonairedigital.net";
  // static String domainSocket = "https://mbrestsocket.tonairedigital.net";
  // static String baseUrl = domain;

  static const String REGISTER_URL = "";
  static const String USER_PROFILE = "";
  static const String TOKEN = "";
  static const String USER_PASSWORD = "";
  static const String USER_NUMBER = "";

  // Webhook
  // static String subscriptionWebhookUrl = "$domain/api/v1/subscriptions/renewSubhook";
  // static String registerWebhookUrl = "$domain/api/v1/store/registerHook";
  // static String subscriptionWebhookUrl =
  //     "http://136.228.128.138:5090/api/AbaWebHook/ModernBusiness";

  // Authentication Routes
  static const String GET_APP_VERSION = "/api/v1/authentication/appversion";
  static const String LOGIN_URL = "/api/v1/authentication/login";
  static const String CHECK_USERNAME = "/api/v1/authentication/checkusername";
  static const String CHECK_EXIST_USERNAME = "/api/v1/authentication/checkExistUsername";
  static const String USER_PROFILE_URL = "/api/v1/authentication/profile";
  static const String CHECK_EXIST_USERANDSTORE = "/api/v1/authentication/checkExistUserAndStore";

  // USER
  static const String GET_ALL_USER = "/api/v1/users";
  static const String CREATE_USER = "/api/v1/users";

  static const String UPDATE_USER_PROFILE = '/api/v1/authentication/updateProfile';
  static const String CHANGE_PASSWORD = "/api/v1/authentication/changepassword";
  static const String DISABLE_USER = "/api/v1/authentication/disable";
  static const String ENABLE_USER = "/api/v1/authentication/enable";
  static const String GET_USER_BY_ID = '/api/v1/users/id';
  static const String UPDATE_USER_BY_ID = '/api/v1/users/id';

  // DATABASE
  static const String GET_ALL_DATABASES = "/api/v1/database";

  // SUBSCRIPTIONS
  static const String GET_ALL_SUBSCRIPTIONS = "/api/v1/subscriptions";
  static const String REGISTER_STORE = "/api/v1/store/register";
  static const String PRE_REGISTER = "/api/v1/store/pre-register";
  static const String REMOVE_PREREGISTER = '/api/v1/store/remove';

  static const String GET_SUBSCRIPTION_DETAIL = "/api/v1/subscriptions/history";
  static const String GET_ALL_SUBHISTORY = "/api/v1/subscriptions/allHistory";
  static const String GET_RENEW_SUBSCRIPITON_PLAN = '/api/v1/subscriptions/renew';
  static const String RENEW_SUBSCRIPTION_PLAN = '/api/v1/subscriptions/renew';
  static const String GET_ALL_LOGGED_IN_DEVICES = '/api/v1/subscriptions/device';
  static const String ENABLE_DEVICE = '/api/v1/subscriptions/device/enable';
  static const String CHECK_DEVICE_STAT = '/api/v1/subscriptions/device/status';
  static const String TRANSACTION_PREFIX = '/api/v1/subscriptions/prefix';
  static const String REGISTER_STORE_FROMADMIN = "/api/v1/store/register/from_admin";

  // Item
  static const String CREATE_PRODUCT = "/api/v1/item";
  static const String GET_ALL_PRODUCTS = "/api/v1/item";
  static const String GET_ALL_ITEM_IN_DETAIL = "/api/v1/item/detail";
  static const String GET_ALL_ITEM_WITHPAGINATION = "/api/v1/item/pagination";
  static const String GET_EACH_ITEM_DETAIL = "/api/v1/item/item_detail";
  static const String UPDATE_PRODUCT = '/api/v1/item/update';
  static const String CHECK_ITEM_CODE = '/api/v1/item/checkExistItem';
  static const String CHECK_ITEM_BARCODE = '/api/v1/item/checkExistItemBarcode';
  static const String DISABLE_ITEM = '/api/v1/item/disable';
  static const String ENABLE_ITEM = '/api/v1/item/enable';
  static const String GET_ALL_INGREDIENT = '/api/v1/item/all_ingredient';
  static const String GET_ALL_GP_OPTION = '/api/v1/group_option';

  static const String GET_NEXT_ITEM_CODE = '/api/v1/item/next_item_code';

  // Menu
  static const String GET_ALL_MENU = '/api/v1/menu/public_menu';
  static const String GET_DETAIL_MENU = '/api/v1/menu/detail';
  static const String GET_ALL_MENU_STOCK = '/api/v1/menu/stock';
  static const String DELETE_MENU = '/api/v1/menu/delete';
  static const String CREATE_MENU = '/api/v1/menu';
  static const String UPDATE_MENU = '/api/v1/menu';
  static const String CHECKMENUEXIST = "/api/v1/menu/checkmMenuExist";
  static const String ENABLE_MENU = '/api/v1/menu/enable';

  // Delivery Address
  static const String GET_DELIVERY_ADDRESS = '/api/v1/delivery_address';
  static const String CREATE_DELIVERY_ADDRESS = '/api/v1/delivery_address';
  static const String ENABLE_DELIVERY_ADDRESS = '/api/v1/delivery_address/enable';
  static const String UPDATE_DELIVERY_ADDRESS = '/api/v1/delivery_address';
  static const String DELETE_DELIVERY_ADDRESS = '/api/v1/delivery_address';
  static const String GET_CUSTOMER_DELIVERY_ADDRESS = '/api/v1/delivery_address/customer';
  static const String CREATE_CUSTOMER_DELIVERY_ADDRESS = '/api/v1/delivery_address/customer';

  // Supplier
  static const String CREATE_SUPPLIER = "/api/v1/supplier";
  static const String GET_ALL_SUPPLIERS = "/api/v1/supplier";
  static const String GET_ALL_CUSTOMERS = '/api/v1/supplier/customer';
  static const String CREATE_CUSTOMERS = '/api/v1/supplier/customer';
  static const String GET_WAREHOUSE_BY_SUPPCODE = '/api/v1/supplier/warehouse';
  static const String GET_SUPPLIER_ITEM = '/api/v1/supplier/item';
  static const String GET_SUPPLIER_ITEM_V2 = '/api/v1/supplier/itemV2';
  static const String ENABLE_SUPPLIER = '/api/v1/supplier/enable';
  static const String ENABLE_CUSTOMER = '/api/v1/supplier/enableCustomer';

  static const String UPDATE_SUPPLIER = '/api/v1/supplier';
  static const String UPDATE_CUSTOMER = '/api/v1/supplier/customer';
  static const String DISABLE_SUPPLIER = '/api/v1/supplier/disable';
  static const String GET_CUSTOMER_BY_ID = '/api/v1/supplier/customer/detail';
  static const String GET_SUPPLIER_BY_ID = '/api/v1/supplier/id';

  // Category
  static const String GET_ALL_BRAND = "/api/v1/category";
  static const String GET_ALL_CATEGORIES = "/api/v1/category/category";
  static const String CREATE_BRAND = "/api/v1/category";
  static const String CREATE_CATEGORY = "/api/v1/category/category_detail";
  static const String UPDATE_CATEGORY = '/api/v1/category/category_detail';
  static const String GET_CATEGORY_ITEM = '/api/v1/category/item';
  static const String GET_CATEGORY_BY_BRAND = '/api/v1/category/category_detail/brand';
  static const String ENABLE_CATEGORY = '/api/v1/category/category_detail/enable';

  // Inventory
  static const String GET_ALL_INVENTORY = '/api/v1/inventory';
  static const String GET_REPORT_INVENTORY = '/api/v1/inventory/report_inventory';
  static const String GET_REPORT_OUTOFSTOCK = '/api/v1/inventory/outofstock_report';

  // Sales Order
  static const String POST_SALES = '/api/v1/sale';
  static const String CREATE_ORDER = '/api/v1/sale/order_menu_qr';

  static const String SEARCH_SALE = '/api/v1/sale/search';

  static const String GET_EXCHANGE_RATE = '/api/v1/sale/exchange_rate';
  static const String CHECK_ITEM_STOCK = '/api/v1/item/check_stock';
  static const String GET_SALE_ORDER = '/api/v1/sale/table_order_qr';
  static const String UPDATE_SALE_ORDER_QR = '/api/v1/sale/update_menu_qr';
  static const String UPDATA_TALBE_ORDER_ORDER_QR = '/api/v1/sale/update_table_order_qr';

  // Shop
  static const String GET_SHOP_INFO = '/api/v1/store/config';
  static const String UPDATE_SHOP_EXCHANGE_RATE = '/api/v1/store/info/exchange';
  static const String UPDATE_SHOP_INFO = '/api/v1/store/info';
  static const String UPDATE_DEVICE = '/api/v1/store/disabledevice';

  // Table
  static const String GET_ALL_TABLE = "/api/v1/table/get";
  static const String GET_TABLE_DETAIL = "/api/v1/table/detail";

  // IMAGE RESIZE
  static const String IMAGE_RESIZE = "/api/v1/imageresize?url=";

  //ROOM
  static const String GET_ALL_ROOM = "/api/v1/room/get";

  // Menu QRCODE
  static const String MENU_QR_CODE = '/menu_qrcode';
  static const String UPDATE_STYLE_MENU = '/api/v1/store/menuConfig';
  static const String GET_STYLE_MENU = '/api/v1/store/menuConfig';

  static const String CREATE_CURRENCY = '/api/v1/currency';
  static const String UPDATE_CURRENCY = '/api/v1/currency/update';
}
