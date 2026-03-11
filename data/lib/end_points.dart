const baseUrlProd = "https://dev.boundless-innovation.com/api/v1";
const imageDownloadingEndpoint = "https://kusel1heidi.obs.eu-de.otc.t-systems.com/";
const baseUrlStage = "";
const sigInEndPoint = "/users/login";
const exploreEndpoint = "/categories";
const signUpEndPoint = "/users/register";
const forgotPasswordEndPoint = "/users/forgotPassword";
const listingsEndPoint = "/listings";
const recommendationsListingEndPoint = "/listings/recommend";
const searchEndPoint = "$listingsEndPoint/search";
const subCategoriesEndPoint = "/subcategories";
const String getFavoritesEndpoint = "/users/favorites/";
String deleteFavoritesEndpoint(String listingId) =>"/users/favorites/$listingId";
const getFavoritesListingEndpoint = "/users/favorites/listings";
const userDetailsEndPoint = "/users";
const uploadImageEndPoint = "/imageUpload";
const fetchUserOwnDataEndPoint = "/me";
const onboardingUserTypeEndPoint = "/userType";
const onboardingUserInterestsEndPoint = "/interests";
const onboardingUserDemographicsEndPoint = "/demographics";
const onboardingCompleteEndpoint = "/onboardingComplete";
const onboardingDetailEndPoint = "/onboardingDetail";
const feedbackEndpoint = "/feedbacks";
const municipalPartyDetailEndPoint = "/virtualTownhall/getMunicipalityById";
const resetPasswordEndPoint='/users/change-password';
const storeFirebaseUserTokenEndPoint= '/storeFirebaseUserToken';

// WEATHER API
const weatherEndPoint = "/thirdParty/weather";
const weatherApiKey="2ead327db48b49f28e6134655242706";

// FILTER API
const getFilterEndPoint = "/filter/filter-list";

// VIRTUAL TOWN HALL
const virtualTownHallEndPoint = "/virtualTownhall";


const ortDetailEndPoint = "/cities";

// MEIN ORT
const meinOrtEndPoint = "/meinOrt";

const getPlacesInMunicipalitiesPath = "/getPlacesInMunicipalities";

const mobilityPath = "/mobility";

const participatePath = "/participate";

const favouriteCitiesPath = "/favorites";

const deleteAccountEndPoint = "/users";

// DIGIFIT API
const digifitInformationEndPoint = "/digifit";

const digifitFavEndPoint = "/digifit/favoriteEquipments";

const digifitOverviewEndPoint = "/digifit/user-equipment-stats";

const digifitExerciseDetailsEndPoint = "/digifit/exercise-details";

const digifitExerciseDetailsTrackingEndPoint = "/digifit/tracker";

const digifitEquipmentFavEndPoint = "/digifit/toggle-favorite";

const digifitUserTrophiesEndPoint = "/digifit/user-trophies";

const digifitCacheDataEndPoint = "/digifit/offline-fit-stats";

const guestUserLoginEndPoint = "/users/guest/login";

const localDigifitBulkTrackingEndPoint = "/digifit/bulk-trackers";

const userScoreEndPoint = "/users/user-points";

const getLegalPolicyEndPoint = "/moreInfo/legal";

const getPOICoordinatesEndPoint ="/listings/poiCoordinate";

// BRAIN TEASERS API
const brainTeaserGameListEndPoint = "/digifit/games-list";
const brainTeaserGameDetailsEndPoint = "/digifit/game";
const brainTeaserGamesEndPoint = "/digifit/game-steps";
const brainTeaserGameDetailsTrackerEndPoint = "/digifit/games-tracker";

