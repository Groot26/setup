class ApiValue {
  static const getAllAnimals = "app/animals/all";

  static const storeDetailURL = "api/influencer/store-details";
  static const homeCategoryListURL = "api/influencer/categories";
  static const getOtpURL = "api/influencer/send-otp";
  static const validateOtpURL = "api/influencer/verify-otp";
  static const checkUserURL = "api/influencer/is-registered";
  static const registerUserURL = "api/influencer/register";
  static const validatePartnerCodeURL =
      "/api/partner/influencer-verify-partner-code";
  static const userDetailsURL = "api/influencer/user-details";
  static const editStoreURL = "api/influencer/update-store-profile";
  static const categoryCollectionsURL = "api/influencer/category-collections";

  //test
  //static const productByCategory = "/test/influencer/category-products";
  static const productByCategory = "api/influencer/category-products";

  static const brandList = "api/influencer/brands";
  static const brandCollectionsURL = "api/influencer/brand-collections";
  static const brandProduct = "api/brand/infinite-scroll-brand-product";
  static const storeCollectionsURL = "api/influencer/store-collections";
  static const createCollectionURL = "api/influencer/add-store-collection";
  static const addProductsToCollectionURL =
      "api/influencer/add-products-to-collection";
  static const trendingProduct = "api/influencer/trending-products";
  static const fetchCollectionURL = 'api/influencer/store-collections';

  // Infinite Scroll
  static const infiniteScrollProduct = "api/influencer/get-product-list";

  // static const createCollection = "/api/influencer/createcollection";
  static const advertsList = "api/influencer/adverts";
  static const searchProduct = "api/influencer/search-products";
  // static const allStoreProductURL = "";
  static const allStoreProductPinURL = "api/influencer/togglePinned";
  static const toggleArchivedURL = "api/influencer/toggleArchived";
  static const addproductURL = "";
  static const showArchivedURL = "api/influencer/get-archived-products";
  // static const fetchCollectionURL = '/store-collections';
  // static const createCollectionURL = "/add-store-collection";

  static const pinnedCollectionURL = 'api/influencer/pin-collection';
  static const unpinnedCollectionURL = 'api/influencer/remove-from-pinned';
  static const fetchInfluancerInsightDetailURL =
      'api/influencer/influencer-insights-and-month-percent';
  static const advertProductsURL = 'api/influencer/advert-products';

  // profile URL

  static const editProfileURL = "api/influencer/update-influencer-profile";

  // Partner URL
  static const partnerDashboardURL = "api/partner/influncers-stats-of-partner";
  static const partnerInfluencerListURL = "api/partner/influncers-of-partner";
  static const allProductURL = "api/influencer/get-all-store-products";
  static const addProductToStoreURL = "api/influencer/add-to-store";

  //Add to Store
  static const addOrRemoveCollectionProductURL =
      "api/influencer/add-or-remove-product-from-collection";
  static const addCollectionToStoreURL =
      "api/influencer/copy-collection-to-store";
  static const productInfluencerInsights = "api/influencer/influencer-insights";
  static const sharePerProductCodeURL = "p/create-short-url";
  static const sharePerProductCodeURLV2 = "p/create-short-url-v2";

  //Dashboard
  static const orderHistoryURL =
      "api/influencer/get-all-products-by-influencer-id-from-insights";

  static const editeCollectionURL = "api/influencer/edit-collection";

  //sample Request
  static const uploadImageForRequestSample =
      "api/influencer/uploadImageForRequestSample";
  static const uploadInfluencerAddress =
      "api/influencer/upload-influencer-address";
  static const checkRequestSampleStatus = "api/influencer/check-samples";

  static const updateStatusToReturnRequest = "api/brand/update-status";

  //add new product to store from amazon
  static const addNewProductFromAmazon =
      'api/influencer/addProductFromAmazonLink';
  //InfAddress
  static const getInfAddress = 'api/influencer/get-influencer-address';

  //WithDrawal
  static const addUpiID = 'api/influencer/add-upi';
  static const getUpiIDs = 'api/influencer/get-upi';
  static const withdrawAmount = 'api/influencer/transaction';
  static const verifyUpiId = 'api/influencer/verify-upi';

  static const getFAQ = 'api/influencer/faq-list';

  //Transaction History
  static const transacrtionHistory = "/api/influencer/transaction-history";

  //brand banner
  static const getBrandBanner = 'api/influencer/get-brand-banner';

  //catogries chain
  static const getCategoryChain = 'api/influencer/categories/chain';
//partner stats
  static const fetchPartnerStats = 'api/partner/stats';
}
