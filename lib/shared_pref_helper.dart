// import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._ctor();

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._ctor();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static late SharedPreferences _prefs;

  static void setAccessToken({required String accessToken}) {
    _prefs.setString("accesstoken", accessToken);
  }

  static String getAccessToken() {
    return _prefs.getString("accesstoken") ?? "";
  }

  static void setInfluencerName({required String influencerName}) {
    _prefs.setString("influencername", influencerName);
  }

  static String getInfluencerName() {
    return _prefs.getString("influencername") ?? "";
  }

  static void setInfluencerGender({required String influencerGender}) {
    _prefs.setString("influencergender", influencerGender);
  }

  static String getInfluencerGender() {
    return _prefs.getString("influencergender") ?? "";
  }

  static void setPartnerCode({required String partnerCode}) {
    _prefs.setString("partnerCode", partnerCode);
  }

  static int getInfluencerCount() {
    return _prefs.getInt("influencerCount") ?? 0;
  }

  static void setInfluencerCount({required int influencerCount}) {
    _prefs.setInt("influencerCount", influencerCount);
  }

  static int getTotalEarning() {
    return _prefs.getInt("totalEarning") ?? 0;
  }

  static void setTotalEarning({required int totalEarning}) {
    _prefs.setInt("totalEarning", totalEarning);
  }

  static String getIsPartner() {
    return _prefs.getString("isPartner") ?? "";
  }

  static void setIsPartner({required String isPartner}) {
    _prefs.setString("isPartner", isPartner);
  }

  static String getPartnerCode() {
    return _prefs.getString("partnerCode") ?? "";
  }

  static void setStoreName({required String storeName}) {
    _prefs.setString("storeName", storeName);
  }

  static String getStoreName() {
    return _prefs.getString("storeName") ?? "";
  }

  static void setStoreAlies({required String storeAlies}) {
    _prefs.setString("storeAlies", storeAlies);
  }

  static String getStoreAlies() {
    return _prefs.getString("storeAlies") ?? "";
  }

  static void setInfluencerEmail({required String influencerEmail}) {
    _prefs.setString("influenceremail", influencerEmail);
  }

  static String getInfluencerEmail() {
    return _prefs.getString("influenceremail") ?? "";
  }

  static void setInfluencerDOB({required String influencerDOB}) {
    if (influencerDOB.isEmpty) {
      return;
    }

    DateTime dob;

    try {
      // Try parsing the date in "1-1-2023" format
      dob = DateTime.parse(influencerDOB);
    } catch (e) {
      // If parsing fails, try parsing in "14 Dec 2023" format
      dob = DateFormat('dd MMM yyyy').parse(influencerDOB);
    }

    String formattedDOB = formatDate(dob);
    _prefs.setString("influencerdob", formattedDOB);
  }

  static String getInfluencerDOB() {
    return _prefs.getString("influencerdob") ?? "";
  }

  static void setInfluencerPhone({required String influencerPhone}) {
    _prefs.setString("influencerphone", influencerPhone);
  }

  static String getInfluencerPhone() {
    return _prefs.getString("influencerphone") ?? "";
  }

  static void setInfluencerProfilePic({required String influencerPic}) {
    _prefs.setString("influencerpic", influencerPic);
  }

  static String getInfluencerProfilePic() {
    return _prefs.getString("influencerpic") ?? "";
  }

  static void setStoreProfilePic({required String storePic}) {
    _prefs.setString("storepic", storePic);
  }

  static String getStoreProfilePic() {
    return _prefs.getString("storepic") ?? "";
  }

  static void setStoreBgPic({required String storeBgPic}) {
    _prefs.setString("storebgpic", storeBgPic);
  }

  static String getStoreBgPic() {
    return _prefs.getString("storebgpic") ?? "";
  }

  static void setInfluencerId({required String influencerId}) {
    _prefs.setString("influencerid", influencerId);
  }

  static String getInfluencerId() {
    if (_prefs.getString("influencerid") == null) {
      return '';
    }
    return _prefs.getString("influencerid").toString();
  }

  static void setStoreId({required String storeId}) {
    _prefs.setString("storeid", storeId);
  }

  static String getStoreId() {
    if (_prefs.getString("storeid") == null) {
      return '';
    }
    return _prefs.getString("storeid").toString();
  }

  static void setIsLoggedIn({required bool isLoggedIn}) {
    _prefs.setBool("isloggedin", isLoggedIn);
  }

  static bool getIsLoggedIn() {
    return _prefs.getBool("isloggedin") ?? false;
  }

  static void setStoreTagline({required String storeTagline}) {
    _prefs.setString("storetagline", storeTagline);
  }

  static String getStoreTagline() {
    return _prefs.getString("storetagline") ?? "";
  }

  static void setStoreBio({required String storeBio}) {
    _prefs.setString("storebio", storeBio);
  }

  static String getStoreBio() {
    return _prefs.getString("storebio") ?? "";
  }

  static void setReferCode({required String referCode}) {
    _prefs.setString("referCode", referCode);
  }

  static String getReferCode() {
    return _prefs.getString("referCode") ?? "";
  }

  static void setDeveloperAccountState({required bool isActive}) {
    _prefs.setBool("isActive", isActive);
  }

  static bool getDeveloperAccountState() {
    return _prefs.getBool("isActive") ?? false;
  }

  static void setPastKeyword({required String keyword}) {
    _prefs.setString("keyword", keyword);
  }

  static String getPastKeyword() {
    return _prefs.getString("keyword") ?? "";
  }

  static Future<void> clearShareCache() async {
    await _prefs.clear();
  }

  static void setDashboardPageIndex({required String index}) {
    _prefs.setString("dashboardPageIndex", index);
  }

  static String getDashboardPageIndexStatus() {
    return _prefs.getString("dashboardPageIndex") ?? "0";
  }

  static getHomePagePageNumber() {
    return _prefs.getInt("homePagePageNumber") ?? 1;
  }

  static getHomePagePageSize() {
    return _prefs.getInt("homePagePageSize") ?? 10;
  }

  static void setHOmePagePageNumber(int i) {
    _prefs.setInt("homePagePageNumber", i);
  }

  static void setHOmePagePageSize(int i) {
    _prefs.setInt("homePagePageSize", i);
  }
}

String formatDate(DateTime date) {
  // Format the date to "dd MMM yyyy" format
  return DateFormat('dd MMM yyyy').format(date);
}
