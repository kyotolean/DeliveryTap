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