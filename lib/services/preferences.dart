class Preferences {
  // static Future<void> saveUserDetails(Map<String, dynamic> userData) async {
  //   SharedPreferences instance = await SharedPreferences.getInstance();
  //   await instance.setString('user_data', jsonEncode(userData));
  //   log("Details saved!");
  // }
  //
  // static Future<dynamic> fetchUserDetails() async {
  //   SharedPreferences instance = await SharedPreferences.getInstance();
  //   String? userDataString = instance.getString('user_data');
  //   if (userDataString != null) {
  //     return jsonDecode(userDataString) as Map<String, dynamic>;
  //   } else {
  //     return null;
  //   }
  // }
  //
  // static Future<void> clear() async {
  //   SharedPreferences instance = await SharedPreferences.getInstance();
  //   await instance.remove('user_data');
  // }
}
