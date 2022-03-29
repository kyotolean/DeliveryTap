class TimeDataKey {
  static String createdAt = 'createdAt';
  static String updatedAt = 'updatedAt';
}

class UserKeys {
  static String uid = 'uid';
  static String name = 'name';
  static String email = 'email';
  static String password = 'password';
  static String loginType = 'loginType';
  static String isAdmin = 'isAdmin';
  static String role = 'role';
  static String photoUrl = 'photoUrl';
  static String type = 'type';
  static String isDeleted = 'isDeleted';
  static String oneSignalPlayerId = 'oneSignalPlayerId';
  static String isTester = 'isTester';
  static String availabilityStatus = 'availabilityStatus';
}

class AddressKey {
  static String results = 'results';
  static String status = 'status';
}

class Collect {
  static String stores = 'stores';
  static String users = 'users';
  static String orders = 'orders';
  static String items = 'items';
  static String categories = 'categories';
  static String reviews = 'reviews';
  static String deliveryBoyReviews = 'deliveryBoyReviews';
}

class StoreKey {
  static String id = 'id';
  static String storeName = 'storeName';
  static String storeEmail = 'storeEmail';
  static String storeDesc = 'storeDesc';
  static String photoUrl = 'photoUrl';
  static String openTime = 'openTime';
  static String closeTime = 'closeTime';
  static String storeAddress = 'storeAddress';
  static String storeState = 'storeState';
  static String storeCity = 'storeCity';
  static String storeLatLng = 'storeLatLng';
  static String storeContact = 'storeContact';
  static String isDealOfTheDay = 'isDealOfTheDay';
  static String couponCode = 'couponCode';
  static String couponDesc = 'couponDesc';
  static String caseSearch = 'caseSearch';
  static String catList = 'catList';
  static String ownerId = 'ownerId';
  static String isDeleted = 'isDeleted';
  static String deliveryCharge = 'deliveryCharge';
}

class CategoryKey {
  static String id = 'id';
  static String categoryName = 'categoryName';
  static String image = 'image';
  static String color = 'color';
  static String isDeleted = 'isDeleted';
}

class AddressResultKey {
  static String address_components = 'address_components';
  static String formatted_address = 'formatted_address';
  static String geometry = 'geometry';
  static String place_id = 'place_id';
}

class AddressComponentKey {
  static String long_name = 'long_name';
  static String short_name = 'short_name';
  static String types = 'types';
}

class GeometryKey {
  static String location = 'location';
}

class LocationKey {
  static String lat = 'lat';
  static String lng = 'lng';
}

class OrderKey {
  static String id = 'id';
  static String orderId = 'orderId';
  static String listOfOrder = 'listOfOrder';
  static String storeId = 'storeId';
  static String storeName = 'storeName';
  static String storeCity = 'storeCity';
  static String totalPrice = 'totalAmount';
  static String totalItem = 'totalItem';
  static String userAddress = 'userAddress';
  static String userID = 'userId';
  static String orderStatus = 'orderStatus';
  static String deliveryBoyId = 'deliveryBoyId';
  static String paymentMethod = 'paymentMethod';
  static String city = 'city';
  static String paymentStatus = 'paymentStatus';
  static String totalAmount = 'totalAmount';
}

class OrderItemKey {
  static String id = 'id';
  static String catId = 'catId';
  static String catName = 'catName';
  static String itemName = 'itemName';
  static String itemPrice = 'itemPrice';
  static String qty = 'qty';
}

class DeliverTableKey {
  static String name = 'Name';
  static String email = 'Email';
  static String deliveryStatus = 'Delivery Status';
}

class OrderTableKey {
  static String orderId = 'OrderID';
  static String dateTime = 'Date & Time';
  static String amount = 'Amount';
  static String orderStatus = 'Order status';
  static String storeName = 'Store name';
  static String paymentStatus = 'Payment status';
  static String paymentMethod = 'Payment method';
}

class ItemKey {
  static String id = 'id';
  static String itemName = 'itemName';
  static String itemPrice = 'itemPrice';
  static String inStock = 'inStock';
  static String categoryId = 'categoryId';
  static String storeId = 'storeId';
  static String storeName = 'storeName';
  static String categoryName = 'categoryName';
  static String image = 'image';
  static String description = 'description';
  static String isDeleted = 'isDeleted';
}

class ItemsTableKey {
  static String image = 'Image';
  static String name = 'Name';
  static String description = 'Description';
  static String category = 'Category';
  static String price = 'Price';
  static String action = 'Action';
}