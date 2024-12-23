import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/api.dart';
import '../../core/api_value.dart';
import '../../shared_pref_helper.dart';
import '../../utils/color_theme.dart';

class ApiRepo {
  final Api api = Api();

  // Login Flow
  Future sendOtp(String number, String signature) async {
    dynamic data = {
      "mobileNumber": number,
      "signature": signature,
    };
    try {
      Response response =
          await api.sendRequest.get(ApiValue.getOtpURL, queryParameters: data);
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        return apiResponse.success;
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something went wrong...!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 16.0);
      print(e.toString());
    }
  }

  Future verifyOtp(String otp, String number) async {
    dynamic data = {
      "mobileNumber": number,
      "otp": otp,
    };
    try {
      Response response = await api.sendRequest
          .get(ApiValue.validateOtpURL, queryParameters: data);
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        return apiResponse.success;
      }
    } catch (e) {
      print(e);
    }
  }

  registerUser(String number, String fullName, String storeName,
      String partnerCode) async {
    dynamic data = {
      'mobileNumber': number,
      'storeName': storeName,
      'fullName': fullName,
      'partnerCode': partnerCode
    };
    try {
      Response response = await api.sendRequest
          .post(ApiValue.registerUserURL, data: jsonEncode(data));
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        if (apiResponse.success == "success") {
          SharedPreferencesHelper.setInfluencerPhone(influencerPhone: number);
          SharedPreferencesHelper.setIsLoggedIn(isLoggedIn: true);
          SharedPreferencesHelper.setAccessToken(
              accessToken: apiResponse.data[0]['accessToken']);
          SharedPreferencesHelper.setInfluencerId(
              influencerId: apiResponse.data[0]['influencer']['_id']);
          SharedPreferencesHelper.setInfluencerName(
              influencerName: apiResponse.data[0]['influencer']['fullName']);
          SharedPreferencesHelper.setIsPartner(
              isPartner:
                  apiResponse.data[0]['influencer']['isPartner'].toString());
          // SharedPreferencesHelper.setPartnerCode(
          //     partnerCode: apiResponse.data[0]['influencer']['partnerCode']);
          SharedPreferencesHelper.setStoreName(
              storeName: apiResponse.data[0]['store']['store_name']);
          SharedPreferencesHelper.setStoreId(
              storeId: apiResponse.data[0]['store']['_id']);
          SharedPreferencesHelper.setStoreBgPic(
              storeBgPic: apiResponse.data[0]['store']['background_graphics']);
          SharedPreferencesHelper.setStoreProfilePic(
              storePic: apiResponse.data[0]['store']['storePictureUrl']);
          SharedPreferencesHelper.setStoreBio(
              storeBio: apiResponse.data[0]['store']['store_bio']);
          SharedPreferencesHelper.setStoreTagline(
              storeTagline: apiResponse.data[0]['store']['tagline']);
          SharedPreferencesHelper.setInfluencerDOB(
              influencerDOB: apiResponse.data[0]['influencer']['dob']);
          SharedPreferencesHelper.setInfluencerEmail(
              influencerEmail: apiResponse.data[0]['influencer']['email']);
        } else {
          Fluttertoast.showToast(
              msg: apiResponse.data[0]['error'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: ColorTheme.primaryColor,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        return apiResponse.success;
      } else {
        Fluttertoast.showToast(
            msg: apiResponse.data[0]['error'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: ColorTheme.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print("Api Failed $e");
    }
  }

  //validaton of partner code
  validatePartnerCode(String partnerCode) async {
    try {
      Response response = await api.sendRequest
          .get('${ApiValue.validatePartnerCodeURL}?code=$partnerCode');
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        return apiResponse.data[0]['partnerFound'];
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something went wrong...!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  // Influencer and Store Details
//done
  storeDetail(String influencerId) async {
    Response response = await api.sendRequest
        .get("${ApiValue.storeDetailURL}?influencerId=$influencerId");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Store..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Store..!";
    }
  }

  // Get All Store Product
  // getAllStoreProduct() async {
  //   final userDetails = await Preferences.fetchUserDetails();
  //   String InfluencerId = userDetails['influencer']['_id'];
  //   Response response =
  //       await api.sendRequest.get("/65043c5d53d04420eb4d0f64/all-products");
  //   ApiResponse apiResponse = ApiResponse.fromResponse(response);
  //   if (response.statusCode == 200) {
  //     if (apiResponse.success != "success") {
  //       throw "Failed to Load Store..!";
  //     } else {
  //       print("////////////////////////////apiResponse.data" +
  //           apiResponse.data.toString());
  //       return apiResponse.data;
  //     }
  //   } else {
  //     throw "Failed to Load Store product..!";
  //   }
  // }

  // getArchivedProduct() async {
  //   final userDetails = await Preferences.fetchUserDetails();
  //   String InfluencerId = userDetails['influencer']['_id'];
  //   Response response =
  //       await api.sendRequest.get("${ApiValue.showArchivedURL}/$InfluencerId");
  //   ApiResponse apiResponse = ApiResponse.fromResponse(response);
  //   if (response.statusCode == 200) {
  //     if (apiResponse.success != "success") {
  //       throw "Failed to Load Store..!";
  //     } else {
  //       print("////////////////////////////apiResponse.data" +
  //           apiResponse.data.toString());
  //       return apiResponse.data;
  //     }
  //   } else {
  //     throw "Failed to Load Store product..!";
  //   }
  // }

  // Main Categories
  homeCategoryList(String parentId) async {
    Response response = await api.sendRequest
        .get("${ApiValue.homeCategoryListURL}?parentId=$parentId");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Category..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Category..!";
    }
  }

  //  UserDetails By Mobile Number
  userDetails(String mobileNumber) async {
    Response response = await api.sendRequest
        .get("${ApiValue.userDetailsURL}?mobileNumber=$mobileNumber");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load User Details..!";
      } else {
        SharedPreferencesHelper.setInfluencerName(
            influencerName: apiResponse.data[0]['fullName']);

        // debug line
        print(apiResponse.data[0].containsKey('gender'));
        print(apiResponse.data[0]['gender']);

        if (apiResponse.data[0].containsKey('gender')) {
          SharedPreferencesHelper.setInfluencerGender(
              influencerGender: apiResponse.data[0]['gender']);
        } else {
          SharedPreferencesHelper.setInfluencerGender(
              influencerGender: "Others");
        }
        //SharedPreferencesHelper.setInfluencerGender(influencerGender: apiResponse.data[0]['gender']);

        SharedPreferencesHelper.setTotalEarning(
            totalEarning: apiResponse.data[0]['totalEarnings']);
        if (apiResponse.data[0]['isPartner']) {
          SharedPreferencesHelper.setPartnerCode(
              partnerCode: apiResponse.data[0]['partnerCode']);
          SharedPreferencesHelper.setInfluencerCount(
              influencerCount: apiResponse.data[0]['influencerCount']);
        }
        SharedPreferencesHelper.setIsPartner(
            isPartner: apiResponse.data[0]['isPartner'].toString());
        SharedPreferencesHelper.setInfluencerDOB(
            influencerDOB: apiResponse.data[0]['dob']);
        SharedPreferencesHelper.setInfluencerEmail(
            influencerEmail: apiResponse.data[0]['email']);
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load User Details..!";
    }
  }

  //   Edit Profile
  Future<dynamic> editUserDetails(
      String name, String email, String dob, String? gender) async {
    try {
      dynamic data = {
        "influencerId": SharedPreferencesHelper
            .getInfluencerId(), //"65043c5d53d04420eb4d0f64
        "fullName": name,
        "email": email,
        "dob": dob,
        "gender": gender ?? "",
      };
      Response response =
          await api.sendRequest.post(ApiValue.editProfileURL, data: data);
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        if (apiResponse.success != "success") {
          throw "Failed to Load User Details..!";
        } else {
          return apiResponse;
        }
      } else {
        throw "Failed to Load User Details..!";
      }
    } catch (e) {
      print(e);
    }
  }

  //  Edit Store
  editStore(
      {String? store_name,
      String? store_bio,
      String? tagline,
      var backPic,
      var pic}

      // String storePictureUrl, String bgGraphics
      ) async {
    Map<String, dynamic> data = {
      'store_name': store_name,
      'tagline': tagline,
      'store_bio': store_bio,

      // 'storePictureUrl': storePictureUrl,
      // 'background_graphics': bgGraphics,
    };
    if (backPic != null) {
      data.addAll({
        'background_image':
            await MultipartFile.fromFile(backPic.path.toString())
      });
    }
    if (pic != null) {
      data.addAll(
          {'profilePicUrl': await MultipartFile.fromFile(pic.path.toString())});
    }
    FormData finalData = FormData.fromMap(data);
    // data.addAll(other)
    Response response = await api.sendRequest.post(
        '${ApiValue.editStoreURL}?influencerId=${SharedPreferencesHelper.getInfluencerId()}',
        data: finalData);
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Profile..!";
      } else {
        return apiResponse;
      }
    } else {
      throw "Failed to Load Profile..!";
    }
  }

  // Get Categories Collection
  categoryCollectionsList(String categoryId) async {
    Response response = await api.sendRequest
        .get("${ApiValue.categoryCollectionsURL}?categoryId=$categoryId");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Category Collection..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Category Collection..!";
    }
  }

  // // Get Product By Category
  // getProductByCategory(String categoryId, int currentPage) async {
  //   Response response = await api.sendRequest.get("${ApiValue.productByCategory}?categoryId=$categoryId");
  //   ApiResponse apiResponse = ApiResponse.fromResponse(response);
  //   if (response.statusCode == 200) {
  //     if (apiResponse.success != "success") {
  //       throw "Failed to Load Brand Collection..!";
  //     } else {
  //       return apiResponse.data;
  //     }
  //   } else {
  //     throw "Failed to Load Brand Collection..!";
  //   }
  // }

  //Test Pagination
  getProductByCategory(
      {required String categoryId,
      required int page,
      required int limit,
      required String sort,
      required String colour,
      required String minPrice,
      required String maxPrice}) async {
    Response response = await api.sendRequest.get(
        "${ApiValue.productByCategory}?categoryId=$categoryId&_page=$page&_limit=$limit&_sort=$sort&_color=$colour&_sellingPriceMin=$minPrice&_sellingPriceMax=$maxPrice");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Brand Collection..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Brand Collection..!";
    }
  }

  //  Get All Brands
  brandsList() async {
    Response response = await api.sendRequest.get(ApiValue.brandList);
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Category..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Category..!";
    }
  }

  // Get All Adverts
  advertsList() async {
    Response response = await api.sendRequest.get(ApiValue.advertsList);
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Adverts..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Adverts..!";
    }
  }

  //fetch all archived product of the influancers
  fetchAllArchivedProduct() async {
    Response response = await api.sendRequest.get(
        "${ApiValue.showArchivedURL}?influencerId=${SharedPreferencesHelper.getInfluencerId().toString()}");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Brand Collection..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Brand Collection..!";
    }
  }

  //Get Change in Pin Unpin
  changePinUnpin(String productId) async {
    // dynamic data = {
    //   "influencerId": SharedPreferencesHelper.getInfluencerId().toString(),
    //   'productId': productId.toString() //"65043c5d53d04420eb4d0f64
    // };
    Response response = await api.sendRequest.post(
        '${ApiValue.allStoreProductPinURL}?influencerId=${SharedPreferencesHelper.getInfluencerId().toString()}&productId=${productId.toString()}');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Store..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Store..!";
    }
  }

  // Get Brands Collections
  brandCollectionsList(String brandId) async {
    Response response = await api.sendRequest
        .get("${ApiValue.brandCollectionsURL}?brandId=$brandId");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Brand Collection..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Brand Collection..!";
    }
  }

  // Get Brands Products
  brandProducts(String brandId, int page, int pageSize) async {
    Response response = await api.sendRequest.get(
        "${ApiValue.brandProduct}?brandId=$brandId&page=$page&pageSize=$pageSize");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Brand Products..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Brand Products..!";
    }
  }

  brandBanners(String brandId) async {
    Response response = await api.sendRequest
        .get("${ApiValue.getBrandBanner}?brandId=$brandId");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Brand Banners..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Brand Banners..!";
    }
  }

  // Get Store Collection
  storeCollectionsList(String storeId) async {
    Response response = await api.sendRequest
        .get("${ApiValue.storeCollectionsURL}?storeId=$storeId");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Store Collection..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Store Collection..!";
    }
  }

  // Influencer Create Collection
  createCollection(String name, String description, String storeid) async {
    Response response = await api.sendRequest.post(ApiValue.createCollectionURL,
        data: jsonEncode(
            {'name': name, 'description': description, 'storeId': storeid}));
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Create Collection..!";
      } else {
        return apiResponse;
      }
    } else {
      throw "Failed to Create Collection..!";
    }
  }

  trendingProducts() async {
    Response response = await api.sendRequest.get(ApiValue.trendingProduct);
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Create Collection..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Create Collection..!";
    }
  }

  infiniteScroll(int page, int pageSize) async {
    // first define the page =1 and pageSize = 10, after that increment it by 1
    // and pass the value in the url

    Response response = await api.sendRequest
        .get("${ApiValue.infiniteScrollProduct}?page=$page&pageSize=$pageSize");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Create Collection..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Create Collection..!";
    }
  }

  unpinCollection(String collectionId) async {
    Response response = await api.sendRequest
        .get('${ApiValue.unpinnedCollectionURL}?collectionId=$collectionId');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Create Collection..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Create Collection..!";
    }
  }

  pinCollection(String collectionId) async {
    Response response = await api.sendRequest
        .get('${ApiValue.pinnedCollectionURL}?collectionId=$collectionId');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Create Collection..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Create Collection..!";
    }
  }

  fetchCollectionsList(String storeId) async {
    Response response = await api.sendRequest
        .get('${ApiValue.fetchCollectionURL}?storeId=$storeId');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Create Collection..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Create Collection..!";
    }
  }

  final _searchController = StreamController<List<dynamic>>();

  Stream<List<dynamic>> get productsStream => _searchController.stream;

  List<dynamic> loadedProducts =
      []; // Add this variable to keep track of loaded products

  Future<void> searchProduct({required String keywords, required page}) async {
    final response = await api.sendRequest
        .get("${ApiValue.searchProduct}?term=$keywords&page=$page&perPage=10");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      final List<dynamic> productData = apiResponse.data[0]['products'];

      if (page == 1) {
        // If it's the first page, set the data
        loadedProducts = productData;
        _searchController.sink.add(loadedProducts);
      } else {
        // If it's not the first page, add to the existing data
        loadedProducts.addAll(productData);
        _searchController.sink.add(loadedProducts);
      }
    } else {
      throw Exception("Failed to Get Data");
    }
  }

  newSearchProduct({required String keywords, required page}) async {
    final response = await api.sendRequest
        .get("${ApiValue.searchProduct}?term=$keywords&page=$page&perPage=10");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      //final List<dynamic> productData = apiResponse.data[0]['products'];
      return apiResponse.data;
    } else {
      throw Exception("Failed to Get Data");
    }
  }

  void dispose() {
    _searchController.close();
  }

  sendLinkTOAddProduct(storeId, link, category) async {
    Response response = await api.sendRequest.post(
        ApiValue.addProductsToCollectionURL,
        data: jsonEncode(
            {'storeId': storeId, 'link': link, 'category': category}));
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Create Collection..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Create Collection..!";
    }
  }

  Future<dynamic> advertProductsList(String advertId) async {
    Response response =
        await api.sendRequest.get('${ApiValue.advertProductsURL}?id=$advertId');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to get Avert Products..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to get Avert Products..!";
    }
  }

  getAllStoreProduct() async {
    // final userDetails = await Preferences.fetchUserDetails();

    Response response = await api.sendRequest.get(
        "${ApiValue.allProductURL}?storeId=${SharedPreferencesHelper.getStoreId().toString()}");
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Load Store..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Store product..!";
    }
  }

  Future<dynamic> fetchUserInsight(String influencerId) async {
    Response response = await api.sendRequest.get(
        '${ApiValue.fetchInfluancerInsightDetailURL}?influencerId=${influencerId}');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Create Collection..!";
      } else {
        // print(
        //     '============>fetchUserInsight()==>befor return==>${apiResponse.data}');
        return apiResponse.data;
      }
    } else {
      throw "Failed to Create Collection..!";
    }
  }

  //fetch influencer product insight
  Future<dynamic> fetchInfluencerProductInsight(String productId) async {
    Response response = await api.sendRequest.get(
        '${ApiValue.productInfluencerInsights}?influencerId=${SharedPreferencesHelper.getInfluencerId()}&productId=${productId}');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Create Collection..!";
      } else {
        // print(
        //     '============>fetchUserInsight()==>befor return==>${apiResponse.data}');
        return apiResponse.data;
      }
    } else {
      throw "Failed to Create Collection..!";
    }
  }

  //fetchperproductcodewithpassinginfluenceridandproductidpostmethod
  Future<dynamic> fetchPerProductCode(String productId, String storeId) async {
    try {
      // dynamic data = {
      //   "url":
      //       "https://store.buhrata.com/api/influencer/redirect-to-product-page/${SharedPreferencesHelper.getInfluencerId()}/${productId}"
      // };

      dynamic data = {"storeId": storeId, "productId": productId};
      Response response = await api.sendRequest
          .post(ApiValue.sharePerProductCodeURLV2, data: data);
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        if (apiResponse.success != "success") {
          throw "Failed to Create Short URL...!";
        } else {
          return apiResponse.data;
        }
      } else {
        throw "Failed to Create Short URL...!";
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> toggleArchivedProduct(String productId) async {
    Response response = await api.sendRequest.post(
        '${ApiValue.toggleArchivedURL}?storeId=${SharedPreferencesHelper.getStoreId()}&productId=${productId}');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Create Collection..!";
      } else {
        // print(
        //     '============>fetchUserInsight()==>befor return==>${apiResponse.data}');
        return apiResponse.data;
      }
    } else {
      throw "Failed to Create Collection..!";
    }
  }

  // Partner
  // fetchPartnerInsight({String partnerId = '650c27df3b6e8d451c643735'}) async {
  //   Response response = await api.sendRequest.get(
  //       '${ApiValue.partnerDashboardURL}?startDate=2023-09-22T10:59:43.342Z&endDate=2023-09-22T10:59:43.342Z&partnerId=${partnerId}');
  //   ApiResponse apiResponse = ApiResponse.fromResponse(response);
  //   if (response.statusCode == 200) {
  //     if (apiResponse.success != "success") {
  //       throw "Failed to Create Collection..!";
  //     } else {
  //       // print(
  //       //     '============>fetchUserInsight()==>befor return==>${apiResponse.data}');
  //       return apiResponse.data;
  //     }
  //   } else {
  //     throw "Failed to Create Collection..!";
  //   }
  // }

  fetchPartnerInfluencerList() async {
    Response response = await api.sendRequest.get(
        '${ApiValue.partnerInfluencerListURL}?partnerId=${SharedPreferencesHelper.getInfluencerId()}');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Create Collection..!";
      } else {
        // print(
        //     '============>fetchUserInsight()==>befor return==>${apiResponse.data}');
        return apiResponse.data;
      }
    } else {
      throw "Failed to Create Collection..!";
    }
  }

  Future<dynamic> addOrRemoveCollectionProduct(
      String collectionId, String productId) async {
    try {
      dynamic data = {
        "collectionId": collectionId,
        "productId": productId,
      };
      Response response = await api.sendRequest
          .post(ApiValue.addOrRemoveCollectionProductURL, data: data);
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        if (apiResponse.success != "success") {
          Fluttertoast.showToast(
            msg: "Failed to Add or Remove Product..!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
          );
          // throw "Failed to Add or Remove Product..!";
        } else {
          Fluttertoast.showToast(
            msg: "${apiResponse.data[0]['message']}..!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
          );
          return apiResponse;
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to Add or Remove Product..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> addCollectionToStore(
      String collectionId, String storeId) async {
    try {
      dynamic data = {
        "collectionId": collectionId,
        "storeId": storeId,
      };
      Response response = await api.sendRequest
          .post(ApiValue.addCollectionToStoreURL, data: data);
      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (response.statusCode == 200) {
        if (apiResponse.success == "success") {
          Fluttertoast.showToast(
            msg: apiResponse.success.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
          );
          return apiResponse.code;
        } else {
          Fluttertoast.showToast(
            msg: "${apiResponse.data[0]['message']}..!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
          );
          return apiResponse.code;
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to Add Collection..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
        // throw "Failed to Add Collection..!";
      }
    } catch (e) {
      print("-------------Exception---------------");
      print(e);
    }
  }

  // fetch order history
  Future<dynamic> fetchOrderHistory() async {
    try {
      // dynamic data = {
      //   "influencerId": SharedPreferencesHelper.getInfluencerId(),
      // };
      Response response = await api.sendRequest.get(
          '${ApiValue.orderHistoryURL}?influencerId=${SharedPreferencesHelper.getInfluencerId()}');
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        if (apiResponse.success != "success") {
          Fluttertoast.showToast(
            msg: "Failed to Add Collection..!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
          );
          // throw "Failed to Add Collection..!";
        } else {
          // Fluttertoast.showToast(msg: "${apiResponse.data[0]['message']}..!");
          return apiResponse.data;
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to Add Collection..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
        // throw "Failed to Add Collection..!";
      }
    } catch (e) {
      print(e);
    }
  }

  //this is the calling and implementation method for the editCollectionURl
  //it get some nessesary parameter and we get the response
  Future<dynamic> editCollection(String collectionId, String name,
      String description, List productIds) async {
    try {
      dynamic data = {
        "name": name,
        "description": description,
        "productIds": productIds
      };
      Response response = await api.sendRequest.post(
          '${ApiValue.editeCollectionURL}?collectionId=${collectionId}',
          data: data);
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        if (apiResponse.success != "success") {
          Fluttertoast.showToast(
            msg: "Failed to Add Collection..!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
          );
          // throw "Failed to Add Collection..!";
        } else {
          // Fluttertoast.showToast(msg: "${apiResponse.data[0]['message']}..!");
          return apiResponse.data;
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to Add Collection..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
        // throw "Failed to Add Collection..!";
      }
    } catch (e) {
      print(e);
    }
  }

  uploadImageForRequestSample(List<File?> images) async {
    // Create a list of MultipartFile
    List<MultipartFile> imageFiles = [];

    for (File? image in images) {
      if (image != null) {
        imageFiles.add(MultipartFile.fromFileSync(image.path));
      }
    }

    Map<String, dynamic> data = {
      'influencerId': SharedPreferencesHelper.getInfluencerId(),
      'images': imageFiles,
    };

    FormData finalData = FormData.fromMap(data);

    Response response = await api.sendRequest
        .post(ApiValue.uploadImageForRequestSample, data: finalData);
    ApiResponse apiResponse = ApiResponse.fromResponse(response);

    if (response.statusCode == 200 && apiResponse.success == "success") {
      return apiResponse;
    } else {
      throw "Failed to Upload Images..!";
    }
  }

  uploadInfluencerAddress({
    required bool isDefaultAddress,
    required String address1,
    required String address2,
    //required String city,
    required String pin,
    //required String state,
    // required String phone,
    // required String name,
    //required String requestSampleId,
    required String productId,
    required String brandId,
    required String insta,
    required String facebook,
    required String youtube,
  }) async {
    Map<String, dynamic> sampleRequest = {
      // "phoneNumber": phone,
      // "fullName": name,
      //"requestSampleId": requestSampleId,
      "influencerId": SharedPreferencesHelper.getInfluencerId(),
      "productId": productId,
      "brandId": brandId,
      "addressLine1": address1,
      //"addressLine2": address2,
      //"city": city,
      //"state": state,
      "pincode": pin,
      "instaLink": insta,
      "fbLink": facebook,
      "youtubeLink": youtube,
    };

    if (isDefaultAddress) {
      sampleRequest["isDefaultAddress"] = isDefaultAddress;
    }
    if (address2 == "") {
      sampleRequest["addressLine2"] = " ";
    } else {
      sampleRequest["addressLine2"] = address2;
    }

    Response response = await api.sendRequest
        .post(ApiValue.uploadInfluencerAddress, data: sampleRequest);
    ApiResponse apiResponse = ApiResponse.fromResponse(response);

    if (response.statusCode == 200 && apiResponse.success == "success") {
      return apiResponse;
    } else {
      throw "Failed to Request Sample..!";
    }
  }

  addProductToStoreFromAmazon(String link, String subCatID) async {
    Map<String, dynamic> data = {
      "amazonLink": link,
      "store_id": SharedPreferencesHelper.getStoreId(),
      "category_id": subCatID
    };

    Response response = await api.sendRequest
        .post(ApiValue.addNewProductFromAmazon, data: data);
    ApiResponse apiResponse = ApiResponse.fromResponse(response);

    if (response.statusCode == 201 && apiResponse.success == "success") {
      return apiResponse.data;
    } else if (response.statusCode == 200 && apiResponse.success == "error") {
      print("Request failed with status code: ${response.statusCode}");
      print("Error message: ${apiResponse.data[0]['message']}");
      Fluttertoast.showToast(
        msg: apiResponse.data[0]['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      return apiResponse.data;
    } else {
      Fluttertoast.showToast(
        msg: "Something Went Wrong! Try Again",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
    }

    // Response response = await api.sendRequest
    //     .post(ApiValue.addNewProductFromAmazon, data: data);
    // ApiResponse apiResponse = ApiResponse.fromResponse(response);
    //
    // if (response.statusCode == 201 && apiResponse.success == "success") {
    //   return apiResponse;
    // } else if(response.statusCode == 400 && apiResponse.success == "error") {
    //     Fluttertoast.showToast(
    //       msg: "SomeThing Went Wrong! Try Again",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.TOP,
    //       timeInSecForIosWeb: 1,
    //     );
    // }else {
    //   throw "Failed to add new Product!";
    // }
  }

  Future<dynamic> getInfluencerAddress() async {
    Response response = await api.sendRequest.get(
        '${ApiValue.getInfAddress}?influencerId=${SharedPreferencesHelper.getInfluencerId()}');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Get Address..!";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Get Address..!";
    }
  }

  FAQ() async {
    Response response = await api.sendRequest.get(ApiValue.getFAQ);
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to FAQ";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load FAQ";
    }
  }

  Future<void> addUpiID(String upiId, registeredName) async {
    try {
      Map<String, dynamic> data = {
        "influencerId": SharedPreferencesHelper.getInfluencerId(),
        "upiId": upiId,
        "type": "upi",
        "registerName": registeredName
      };

      Response response =
          await api.sendRequest.post(ApiValue.addUpiID, data: data);
      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (response.statusCode == 201 && apiResponse.success == "success") {
        // UPI ID added successfully
        Fluttertoast.showToast(
          msg: "UPI ID saved Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
      } else {
        // Handle the case where the server request was successful, but the API response indicates an error
        Fluttertoast.showToast(
          msg: "Failed To add UPI ID",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
      }
    } catch (error) {
      // Handle exceptions, e.g., network errors
      Fluttertoast.showToast(
        msg: "An error occurred: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
    }
  }

  // getUpiIds() async {
  //   Response response = await api.sendRequest
  //       .get('${ApiValue.getUpiIDs}?influencerId=${SharedPreferencesHelper.getInfluencerId()}');
  //   ApiResponse apiResponse = ApiResponse.fromResponse(response);
  //   if (response.statusCode == 200) {
  //     if (apiResponse.success != "success") {
  //       throw "Failed to get UPI IDs";
  //     } else {
  //       return apiResponse.data[0]["razorpays"];
  //     }
  //   } else {
  //     throw "Failed to Load upi IDs";
  //   }
  // }

  getUpiIds() async {
    Response response = await api.sendRequest.get(
        '${ApiValue.getUpiIDs}?influencerId=${SharedPreferencesHelper.getInfluencerId()}');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);

    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to get UPI IDs";
      } else {
        var responseData = apiResponse.data;

        // Check if responseData is not null and contains the key "razorpays"
        if (responseData != null && responseData.containsKey("razorpays")) {
          // Assuming "razorpays" is a list, return the entire list
          List<Map<String, dynamic>> razorPaysList =
              List<Map<String, dynamic>>.from(responseData["razorpays"]);

          return razorPaysList;
        } else {
          // Handle the case where "razorpays" key is missing
          throw "Invalid response format - missing 'razorpays' key";
        }
      }
    } else {
      throw "Failed to Load upi IDs";
    }
  }

  verifyUpiId(String upiId) async {
    Response response = await api.sendRequest.get(
        '${ApiValue.verifyUpiId}?influencerId=${SharedPreferencesHelper.getInfluencerId()}&upiId=$upiId');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);

    if (response.statusCode == 200) {
      if (response.data['data'][0]["isValidUpi"] == true) {
        return apiResponse.data[0]['registeredName'];
      } else {
        Fluttertoast.showToast(
          msg: "Upi Id Not Valid",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
      }
    } else {
      throw "Failed to verify upi ID";
    }
  }

  getCategoryChain() async {
    Response response = await api.sendRequest.get(ApiValue.getCategoryChain);
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Get Category Chain";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Category Chain";
    }
  }

  checkRequestSampleStatus(String productId) async {
    Response response = await api.sendRequest.get(
        '${ApiValue.checkRequestSampleStatus}?influencerId=${SharedPreferencesHelper.getInfluencerId()}&productId=$productId');
    ApiResponse apiResponse = ApiResponse.fromResponse(response);
    if (response.statusCode == 200) {
      if (apiResponse.success != "success") {
        throw "Failed to Get Request Sample Status";
      } else {
        return apiResponse.data;
      }
    } else {
      throw "Failed to Load Request Sample Status";
    }
  }

  withdrawAmmount(String upiId, String name, String amount) async {
    try {
      Map<String, dynamic> data = {
        "influencerId": SharedPreferencesHelper.getInfluencerId(),
        "receiverAccount": upiId,
        "name": name,
        "transferAmount": int.parse(amount.toString().split(' ')[1].toString()),
      };

      Response response =
          await api.sendRequest.post(ApiValue.withdrawAmount, data: data);
      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (response.statusCode == 201 && apiResponse.success == "success") {
        // UPI ID added successfully
        // Fluttertoast.showToast(
        //   msg: "Withdraw request Successfull",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        //   timeInSecForIosWeb: 1,
        // );
        return response.statusCode;
      } else {
        // Handle the case where the server request was successful, but the API response indicates an error
        // Fluttertoast.showToast(
        //   msg: "Failed To Request Withdraw",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        //   timeInSecForIosWeb: 1,
        // );
        return response.statusCode;
      }
    } catch (error) {
      // Handle exceptions, e.g., network errors
      Fluttertoast.showToast(
        msg: "An error occurred: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      print(error);
    }
  }

  fetchPartnerStats() async {
    try {
      Map<String, dynamic> data = {
        "partnerId": SharedPreferencesHelper.getInfluencerId(),
      };

      Response response = await api.sendRequest
          .get(ApiValue.fetchPartnerStats, queryParameters: data);
      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (response.statusCode == 200 && apiResponse.success == "success") {
        return apiResponse.data;
      } else {
        return [];
      }
    } catch (error) {
      // Handle exceptions, e.g., network errors
      Fluttertoast.showToast(
        msg: "An error occurred: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      print(error);
    }
  }

  //Transaction History API
  //validaton of partner code
  getTransactions(String influencerId) async {
    try {
      Response response = await api.sendRequest
          .get('${ApiValue.transacrtionHistory}?influencerId=$influencerId');
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        //print(apiResponse.data);
        return apiResponse.data[0];
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something went wrong...!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  updateStatus(String productId) async {
    try {
      Map<String, dynamic> data = {
        "productId": productId,
        "status": "return request"
      };

      Response response = await api.sendRequest
          .post(ApiValue.updateStatusToReturnRequest, data: data);
      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (response.statusCode == 201 && apiResponse.success == "success") {
        // UPI ID added successfully
        // Fluttertoast.showToast(
        //   msg: "Withdraw request Successfull",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        //   timeInSecForIosWeb: 1,
        // );
        //return response.statusCode;
        print(response.statusCode);
      } else {
        // Handle the case where the server request was successful, but the API response indicates an error
        // Fluttertoast.showToast(
        //   msg: "Failed To Request Withdraw",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        //   timeInSecForIosWeb: 1,
        // );
        //return response.statusCode;
        print(response.statusCode);
      }
    } catch (error) {
      // Handle exceptions, e.g., network errors
      Fluttertoast.showToast(
        msg: "An error occurred: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
      );
      print(error);
    }
  }
}
