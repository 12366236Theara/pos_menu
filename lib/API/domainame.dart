// ignore_for_file: constant_identifier_names
// https://
class Domain {
  // ---- for subdomain ---- //
  // static String domainName = "https://pos.tonairedigital.net";
  // static String domainSocket = "https://possoc.tonairedigital.net";
  // static String domain = domainName;
  // static String domainImageSmall = "$domainName/api/v2/imageresize?url=";
  // static String baseUrl = domainName;
  // // Webhook
  // static String subscriptionWebhookUrl = "$domainName/api/v1/subscriptions/renewSubhook";
  // static String registerWebhookUrl = "$domainName/api/v1/store/registerHook";

  // -- for Testing dev-- //
  // static String domainName = "203.189.135.191";
  // static String port = "10010";
  // static String portSocket = "10012";
  // static String jsReport = "10011";

  // -- for Testing dev-- //
  // static String domainName = "192.168.1.210";
  // static String port = "10010";
  // static String portSocket = "10012";
  // static String jsReport = "10011";

  // -- for local testing -- //
  static String domainName = "192.168.1.137";
  static String port = "3000";
  static String portSocket = "3002";
  static String jsReport = "3001";
  // static String imageDomain = "http://51.79.251.248:3000";

  static String domain = "http://$domainName:$port";
  static String domainSocket = "http://$domainName:$portSocket";
  static String domainImageSmall = "http://$domainName:$port/api/v2/imageresize?url=";
  static String baseUrl = "http://$domainName:$port";
  static String invoiceBaseURl = 'http://$domainName:$jsReport';

  static String subscriptionWebhookUrl = "http://$domainName:$port/api/v1/subscriptions/renewSubhook";
  static String registerWebhookUrl = "http://$domainName:$port/api/v1/store/registerHook";

  static const String REGISTER_URL = "";
  static const String USER_PROFILE = "";
  static const String TOKEN = "";
  static const String USER_PASSWORD = "";
  static const String USER_NUMBER = "";

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
  static const String REGISTER_STORE_FROMADMIN = "/api/v1/store/register/from_admin";

  static const String GET_SUBSCRIPTION_DETAIL = "/api/v1/subscriptions/history";
  static const String GET_ALL_SUBHISTORY = "/api/v1/subscriptions/allHistory";
  static const String GET_RENEW_SUBSCRIPITON_PLAN = '/api/v1/subscriptions/renew';
  static const String RENEW_SUBSCRIPTION_PLAN = '/api/v1/subscriptions/renew';
  static const String GET_ALL_LOGGED_IN_DEVICES = '/api/v1/subscriptions/device';
  static const String ENABLE_DEVICE = '/api/v1/subscriptions/device/enable';
  static const String CHECK_DEVICE_STAT = '/api/v1/subscriptions/device/status';
  static const String TRANSACTION_PREFIX = '/api/v1/subscriptions/prefix';

  // Item
  static const String CREATE_PRODUCT = "/api/v1/item";
  static const String CREATE_PRODUCT_V2 = "/api/v1/item/v2";
  static const String GET_ALL_PRODUCTS = "/api/v1/item";
  static const String GET_ALL_ITEM_IN_DETAIL = "/api/v1/item/detail";
  static const String GET_ALL_ITEM_WITHPAGINATION = "/api/v1/item/pagination";
  static const String GET_ALL_ITEM_WITHPAGINATION_V2 = "/api/v1/item/public_menu";
  static const String GET_EACH_ITEM_DETAIL = "/api/v1/item/item_detail";
  static const String GET_EACH_ITEM_DETAIL_V2 = "/api/v1/item/item_detail/v2";
  static const String UPDATE_PRODUCT = '/api/v1/item/update';
  static const String UPDATE_PRODUCT_V2 = '/api/v1/item/update/v2';
  static const String CHECK_ITEM_CODE = '/api/v1/item/checkExistItem';
  static const String CHECK_ITEM_BARCODE = '/api/v1/item/checkExistItemBarcode';
  static const String DISABLE_ITEM = '/api/v1/item/disable';
  static const String ENABLE_ITEM = '/api/v1/item/enable';
  static const String GET_ONLY_ITEM = '/api/v1/item/item-only';

  static const String GET_NEXT_ITEM_CODE = '/api/v1/item/next_item_code';

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
  static const String GET_ALL_CUSTOMER_WITH_PAGINATION = '/api/v1/supplier/customer/paginate';
  static const String CREATE_CUSTOMERS = '/api/v1/supplier/customer';
  static const String GET_WAREHOUSE_BY_SUPPCODE = '/api/v1/supplier/warehouse';
  static const String GET_SUPPLIER_ITEM = '/api/v1/supplier/item';
  static const String GET_SUPPLIER_ITEM_V2 = '/api/v1/supplier/itemV2';
  static const String ENABLE_SUPPLIER = '/api/v1/supplier/enable';
  static const String ENABLE_CUSTOMER = '/api/v1/supplier/enableCustomer';
  static const String DOWNLOAD_REPORT_CUSTOMER = '/api/v1/supplier/customer/report';

  static const String UPDATE_SUPPLIER = '/api/v1/supplier';
  static const String UPDATE_CUSTOMER = '/api/v1/supplier/customer';
  static const String DISABLE_SUPPLIER = '/api/v1/supplier/disable';
  static const String GET_CUSTOMER_BY_ID = '/api/v1/supplier/customer/detail';
  static const String GET_SUPPLIER_BY_ID = '/api/v1/supplier/id';

  // Category
  static const String GET_ALL_BRAND = "/api/v1/category";
  static const String GET_ALL_CATEGORIES = "/api/v1/category/category_detail_menu";
  static const String CREATE_BRAND = "/api/v1/category";
  static const String CREATE_CATEGORY = "/api/v1/category/category_detail";
  static const String UPDATE_CATEGORY = '/api/v1/category/category_detail';
  static const String GET_CATEGORY_ITEM = '/api/v1/category/item';
  static const String GET_CATEGORY_BY_BRAND = '/api/v1/category/category_detail/brand';
  static const String ENABLE_CATEGORY = '/api/v1/category/category_detail/enable';

  // Warehouse
  static const String GET_ALL_WAREHOUSE = '/api/v1/warehouse';
  static const String CREATE_WAREHOUSE = '/api/v1/warehouse';
  static const String DELETE_WAREHOUSE = '/api/v1/warehouse';
  static const String UPDATE_WAREHOUSE = '/api/v1/warehouse';
  static const String TRANSFER_TO_WAREHOUSE = '/api/v1/warehouse/localtransfer';
  static const String ENABLE_WAREHOUSE = '/api/v1/warehouse/enable';

  // Purchase Order
  static const String GET_ALL_PO = '/api/v1/purchase_order';
  static const String GET_ALL_PO_PAGINATE = '/api/v1/purchase_order/paginate';
  static const String CREATE_PO = '/api/v1/purchase_order';
  static const String GET_ALL_PO_PRESET = '/api/v1/purchase_order_preset';
  static const String CREATE_PO_PRESET = '/api/v1/purchase_order_preset';
  static const String DELETE_PO_PRESET = '/api/v1/purchase_order/preset';
  static const String DISABLE_PO = '/api/v1/purchase_order/disable';
  static const String ADJUST_STOCK = '/api/v1/purchase_order/adjustStock';

  // Receive PO
  static const String RECEIVE_PO = '/api/v1/purchase_order/receive_po';

  // Inventory
  static const String GET_ALL_INVENTORY = '/api/v1/inventory';

  // Sales Order
  static const String CREATE_SALES_ORDER = '/api/v1/sale';
  static const String CREATE_SALES_ORDER_V2 = '/api/v1/sale/v2';
  static const String GET_SALE_REPORT = '/api/v1/sale/report';
  static const String GET_SALE_HISTORY = '/api/v1/sale/history';
  static const String SEARCH_SALE = '/api/v1/sale/search';
  static const String GET_SALE_DETAIL = '/api/v1/sale/detail';
  static const String GET_SALE_DETAIL_V2 = '/api/v1/sale/detail/v2';
  static const String POST_CREDIT_NOTE = '/api/v1/sale/creditnote';
  static const String CALCULATE_PROFIT = '/api/v1/sale/calculate_profit';
  static const String GET_EXCHANGE_RATE = '/api/v1/sale/exchange_rate';
  static const String CHECK_ITEM_STOCK = '/api/v1/item/check_stock';
  static const String GET_SALE_INVOICE_A4 = '/api/v1/sale/invoice';
  static const String GET_CLOSE_SHIFT_REPORT = '/api/v1/sale/close_shift_report';
  static const String GET_CLOSE_SHIFT_REPORT_DETAIL = '/api/v1/sale/close_shift_detail_report';

  // Report
  static const String REPORT = '/api/v1/report';
  static const String GENERATE_REPORT = '/api/v1/report/generate_report';
  static const String GENERATE_SALE_INVOICE_REPORT = '/api/v1/report/sale_invoice';
  static const String GET_SALE_INVOICE_REPORT_DATA = '/api/v1/report/sale_invoice_data';
  static const String GET_PO_REPORT = '/api/v1/report/po_report';

  static const String TOP_SALE_ITEM = '/api/v1/report/top_sale_item';
  static const String STOCK_REPORT = '/api/v1/report/stock_report';
  static const String SUMMARY_REPORT = '/api/v1/report/summary_report';
  static const String SUMMARY_REPORT_DATA = '/api/v1/report/summary_report_data';

  // Permission
  static const String GET_ALL_GROUP_PERMISSION = '/api/v1/permission/group';
  static const String CREATE_GROUP_PERMISSION = '/api/v1/permission/group/create';

  static const String GET_GROUP_PERMISSION_BY_USER = '/api/v1/permission/group/user';
  static const String GET_PERMISSION_BY_USER = '/api/v1/permission/user';
  static const String UPDATE_USER_PERMISSION = '/api/v1/permission/user';
  static const String UPDATE_GROUP_PERMISSION = '/api/v1/permission/group';
  static const String DELETE_GROUP_PERMISSION = '/api/v1/permission/group';

  static const String LIST_PERMISSION_BY_GROUP = '/api/v1/permission/group/listPermission';
  static const String LIST_USER_BY_GROUP = '/api/v1/permission/group/users';

  // Shop
  static const String GET_SHOP_INFO = '/api/v1/store/info';
  static const String GET_SHOP_INFO_V2 = '/api/v1/store/infoV2Menu';
  static const String UPDATE_SHOP_EXCHANGE_RATE = '/api/v1/store/info/exchange';
  static const String UPDATE_SHOP_INFO = '/api/v1/store/info';
  static const String UPDATE_SHOP_INFO_V2 = '/api/v1/store/infoV2';

  // Expense
  static const String GET_ALL_EXPENSE = "/api/v1/expense";
  static const String CREATE_EXPENSE = "/api/v1/expense/create";
  static const String UPDATE_EXPENSE = '/api/v1/expense/update';
  static const String DELETE_EXPENSE = '/api/v1/expense/delete';

  // Image Resize
  static const String IMAGE_RESIZE = '/api/v1/image_resize';

  // Dashboard Image
  static const String DASHBOARD_IMAGE = '/api/v1/dashboardimage';

  // Bank
  static const String GETALLBANK = '/api/v1/bank/getAllBank';
  static const String CREATEBANK = '/api/v1/bank/create';
  static const String UPDATEBANK = '/api/v1/bank/update';
  static const String DISABLEBANK = '/api/v1/bank/disable';
  static const String ENABLEBANK = '/api/v1/bank/enable';

  // Member Ship
  static const String GETALL_MEMBERSHIP = '/api/v1/bank/getAllBank';
  static const String CREATE_MEMBERSHIP = '/api/v1/bank/create';
  static const String UPDATE_MEMBERSHIP = '/api/v1/bank/update';
  static const String DELETE_MEMBERSHIP = '/api/v1/bank/disable';
  static const String ENABLE_MEMBERSHIP = '/api/v1/bank/enable';

  // currency
  static const String CREATE_CURRENCY = '/api/v1/currency';
  static const String UPDATE_CURRENCY = '/api/v1/currency/update';
}
