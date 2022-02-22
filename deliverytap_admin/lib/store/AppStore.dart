import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  bool isAdmin = false;

  @observable
  bool isDarkMode = false;

  @observable
  bool isLoading = false;

  @observable
  String userProfileImage = '';

  @observable
  String userFullName = '';

  @observable
  String userEmail = '';

  @observable
  String userId = '';


  @action
  void setUserProfile(String image) {
    userProfileImage = image;
  }

  @action
  void setUserId(String val) {
    userId = val;
  }

  @action
  void setUserEmail(String email) {
    userEmail = email;
  }

  @action
  void setFullName(String name) {
    userFullName = name;
  }

  @action
  Future<void> setLoggedIn(bool val) async {
    isLoggedIn = val;
    await setValue(IS_LOGGED_IN, val);
  }

  @action
  void setLoading(bool val, {String? toastMsg}) {
    isLoading = val;

    if (toastMsg != null) {
      log(toastMsg);
      toast(toastMsg);
    }
  }

  @action
  void setAdmin(bool val) {
    isAdmin = val;
  }

}
