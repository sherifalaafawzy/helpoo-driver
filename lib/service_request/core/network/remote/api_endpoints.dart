import 'package:helpoo/main.dart';

const String baseUrl = 'https://$mainBaseUrl.helpooapp.net/api/';
const String apiVersion = 'v2/';
const String loginEndPoint = 'users/login';
const String profileEndPoint = 'users/me';
const String policiesEndPoint = 'cars/policies/1';
const String manufacturersEndPoint = 'manufacturers';
const String carsModelsEndPoint = 'carModels';
const String createPolicyEndPoint = 'cars/create';
const String accidentReportsPoint = 'accidentReports/insurance';
const String accidentReportsByStatus = 'accidentReports/getByStatus';
const String accidentReportsDetailsPoint = 'accidentReports/show';
const String imagesBaseUrl = 'https://$mainBaseUrl.helpooapp.net';
const String insuranceCompaniesEndPoint = 'insuranceCompanies';
const String createNewInspectorEndPoint = 'inspect/createInspector';
const String createNewInspectionsCompanyEndPoint = 'inspectionsCompany/create';
const String inspectorsEndPoint = 'inspect/getByInsurance';
const String inspectionsEndPoint = 'inspections/getAll';
const String createInspectionEndPoint = 'inspections/create';
const String updateInspectionEndPoint = 'inspections/one';
const String getMyInspectionsCompanyAsInsuranceCompanyEndPoint = 'inspectionsCompany/getByIns';
const String uploadPdfEndPoint = 'inspections/uploadPdf/';
const String uploadImagesEndPoint = 'inspections/uploadInsuranceImages';
const String decodedPointsUrl = 'settings/encodeString';
const String getAllServiceRequest = 'serviceRequest/getAll';
const String getServiceRequestTypes = 'serviceRequest/types';
const String getDriversUrl = 'drivers/getall';
const String rateRequestEndPoint = 'serviceRequest/commentAndRate/create';
const String assignDriverEndPoint = 'drivers/assignDriver';
const String unAssignDriverEndPoint = 'drivers/unassignDriver';
const String getConfigEndPoint = 'settings/allConfig';
const String checkPromoPackageOrNormalEndPoint = 'packagePromo/checkIfExists';

///************************** Service Request **************************///

const String getDriverUrl = 'drivers/getDriver';
const String createNewServiceRequestUrl = 'serviceRequest/create';

const String calculateFeesUrl = 'serviceRequest/calculateFees';

const String cancelServiceRequestUrl = 'serviceRequest/cancel';
const String getOneServiceRequestUrl = 'serviceRequest/getOne';
const String getIframeUrl = 'paymob/getIframe';
const String updateOneServiceRequestUrl = 'serviceRequest/update';
const String addVoucherUrl = 'promoCode/useVoucher';

const String checkServiceRequestUrl = 'serviceRequest/check';

///************************** Inspection Company **************************///
const String getMyInspectorsAsAnInspectionCompanyEndPoint = 'inspect/getByInspectionCompany';
const String getMyInspectionsAsAnInspectionCompanyEndPoint = 'inspections/forInspection';
const String createInspectorForInspectionCompanyEndPoint = 'inspect/addInspector';

///************************** Inspector **************************///

const String getMyInspectionsAsAnInspectorEndPoint = 'inspections/forInspector';

const mapUrl = 'https://maps.googleapis.com/maps/api/';

// const apiKey = 'AIzaSyAnS2tif6wljUW4Lfkd5qw1PZQjAi3xeGo';
const apiKey = 'AIzaSyBac4Acjq25AhmnhFAeAbWnyNpeRSXb5Mc';
// const apiKey = 'AIzaSyBH1gGrzF9RxnjNlo9KwzGuv4UAA1twDug';
const getPlacesUrl = 'place/autocomplete/json';
const getPlacesDetailsUrl = 'place/details/json';
const getPlacesDetailsByCoordinatesUrl = 'geocode/json';
const createPdfReportCombineEndPoint = 'carAccidentReport/createPdfReport';
