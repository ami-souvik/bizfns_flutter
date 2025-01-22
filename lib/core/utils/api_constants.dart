//6304000021
//Software$19@

class Urls {
  //AMIT - https://d452-223-185-34-234.ngrok-free.app/api
  //pranta - https://unduly-inspired-wolf.ngrok-free.app/api
  static const String BASE_URL = "https://unduly-inspired-wolf.ngrok-free.app/api";
  static const String MEDIA_URL = "$BASE_URL/users/downloadMediafile/"; //live
  static const String DOWNLOAD_INVOICE_FILE =
      "$BASE_URL/users/downloadInvoiceFile/";
  // static const String SecondaryMEDIA_URL = "http://182.156.196.67:8085/api/users/downloadInvoiceFile/"; //live
  // static const String BASE_URL = "http://192.168.0.73:8085/api"; //sayan
  //http://182.156.196.67:8085/api/users/downloadMediafile/
  static const int jobId = 1;

  static const String SIGNUP = "$BASE_URL/users/companyRegistration";
  static const String LOGIN = "$BASE_URL/users/userlogin";
  static const String OTP_VERIFICATION = "$BASE_URL/users/otpVerification";
  static const String ADD_CUSTOMER = "$BASE_URL/users/addCustomer";
  static const String GET_PRE_STAFF_CREATION_DATA =
      "$BASE_URL/users/preStaffCreationDetails";
  static const String ADD_STAFF = "$BASE_URL/users/addStaff";
  static const String FETCH_CUSTOMERS = "$BASE_URL/users/fetchCustomerList";
  static const String GET_CUSTOMER_DETAILS =
      "$BASE_URL/users/getCustomerDetails";
  static const String DELETE_CUSTOMER = "$BASE_URL/users/deleteCustomer";
  static const String UPDATE_CUSTOMER = "$BASE_URL/users/updateCustomerDetails";
  static const String ACTIVE_INACTIVE_CUSTOMER =
      "$BASE_URL/users/UpdateActiveInactiveStatusForCustomer";

  static const String FETCH_STAFFS = "$BASE_URL/users/fetchStaffList";
  static const String FETCH_PRE_REGISTER_DATA =
      "$BASE_URL/users/fetchPreRegistration";
  static const String REGISTRATION_OTP_SEND =
      "$BASE_URL/users/preregistrationSendOtp";
  static const String VALIDATE_REGISTRATION_OTP =
      "$BASE_URL/users/preregistrationOtpVerification";
  static const String FETCH_SEQURITY_QUESTIONS =
      "$BASE_URL/users/getSecurityQuestion";
  static const String SAVE_SEQURITY_QUESTIONS =
      "$BASE_URL/users/saveSecurityQuestion";
  static const String VERIFY_SEQURITY_QUESTIONS =
      "$BASE_URL/users/verifySecurityQuestion";
  static const String FORGOT_PASSWORD = "$BASE_URL/users/forgotPassword";
  static const String FORGOT_BUSINESS_ID = "$BASE_URL/users/forgotBusinessId";
  static const String CHANGE_PASSWORD = "$BASE_URL/users/changePasswordSendOtp";
  static const String VALIDATE_FORGOT_PASSWORD_OTP =
      "$BASE_URL/users/validateForgotPasswordOtp";
  static const String RESET_PASSWORD = "$BASE_URL/users/resetPassword";
  static const String VALIDATE_CHANGE_PASSWORD_OTP =
      "$BASE_URL/users/validateOtpAndChangePassword";
  static const String CHANGE_BUSINESS_MOBILE_NO =
      "$BASE_URL/users/updateBusinessMobileNo";

  static const String MATERIAL_CATEGORY_LIST =
      "$BASE_URL/users/materialCategoryData";
  static const String MATERIAL_LIST = "$BASE_URL/users/materialList";
  static const String MATERIAL_UNIT_LIST = "$BASE_URL/getMaterialUnit";
  static const String ADD_MATERIAL = "$BASE_URL/users/addMaterial";
  static const String ADD_MATERIAL_CATEGORY =
      "$BASE_URL/users/addMaterialCategory";
  static const String ADD_MATERIAL_SUB_CATEGORY =
      "$BASE_URL/users/addMaterialSubCategory";
  static const String DELETE_CATEGORY_SUBCATEGORY =
      "$BASE_URL/users/deleteCategoryAndSubcategory";
  static const String GET_MATERIAL_DETAILS =
      "$BASE_URL/users/getMaterialDetails";
  static const String EDIT_MATERIAL_DETAILS =
      "$BASE_URL/users/updateMaterialDetails";
  static const String DELETE_MATERIAL = "$BASE_URL/users/deleteMaterial";
  static const String ACTIVE_INACTIVE_MATERIAL =
      "$BASE_URL/users/UpdateActiveInactiveStatusForMaterial";
  static const String SAVE_MATERIAL_UNIT = "$BASE_URL/saveMaterialUnit";

  static const String GET_SERVICE_RATE_UNIT_LIST =
      "$BASE_URL/users/fetchServiceRateUnit";
  static const String ADD_SERVICE = "$BASE_URL/users/addService";
  static const String GET_SERVICE_LIST = "$BASE_URL/users/fetchServiceList";
  static const String GET_SERVICE_DETAILS = "$BASE_URL/users/getServiceDetails";
  static const String UPDATE_SERVICE_DETAILS =
      "$BASE_URL/users/updateServiceDetails";
  static const String DELETE_SERVICE = "$BASE_URL/users/deleteService";

  static const String GET_SCHEDULE_LIST = "$BASE_URL/users/scheduleList";
  static const String ADD_SCHEDULE = "$BASE_URL/users/addNewSchedule";
  static const String EDIT_SCHEDULE = "$BASE_URL/users/editSchedule";
  static const String RE_SCHEDULE = "$BASE_URL/users/reScheduleJob";
  static const String DELETE_SCHEDULE = "$BASE_URL/users/deleteSchedule";
  static const String GET_TAX_TABLE = "$BASE_URL/users/getTaxTable";
  static const String ADD_TAX_TABLE = "$BASE_URL/users/addTaxTable";
  static const String DELETE_TAX_TABLE = "$BASE_URL/users/deleteTaxTable";
  static const String UPDATE_TAX_TABLE = "$BASE_URL/users/updateTaxTable";
  static const String SERVICE_ENIITY = "$BASE_URL/users/serviceEntityField";
  static const String ADD_SERVICE_ENTIYTY = "$BASE_URL/users/addServiceEntity";
  static const String EDIT_SERVICE_ENTITY = "$BASE_URL/users/updateServiceObjectDetails";
  static const String DELETE_SERVICE_ENTITY = "$BASE_URL/users/deleteServiceObject";
  static const String CUSTOMER_SERVICE_ENTITY =
      "$BASE_URL/users/custWiseServiceEntity";
  static const String SERVICE_ENTITY_DETAILS =
      "$BASE_URL/users/getServiceEntityDetails";
  static const String SAVE_JOB_IMAGE = "$BASE_URL/users/saveMediafile";
  static const String UPLOAD_BUSINESS_LOGO =
      "$BASE_URL/profile/uploadBusinessLogo";
  static const String GET_JOB_PRICE = "$BASE_URL/users/getJobPrice";
  static const String GET_JOB_NUMBER_BY_DATE = "$BASE_URL/users/getJobNumberByDate";
  static const String CREATE_INVOICE = "$BASE_URL/users/createInvoice";
  static const String GET_EDIT_INVOICE = "$BASE_URL/users/getEditInvoiceValuesByJobIdAndCustomerId";
  static const String GET_INVOICED_lIST = "$BASE_URL/users/getInvoiceListsByJobId";
  static const String SAVE_INVOICE = "$BASE_URL/users/SaveEditInvoiceValuesByJobIdAndCustomerIds";
  static const String UPDATE_INVOICE = "$BASE_URL/users/updateEditInvoiceValues";
  static const String CREATE_INVOICE_PDF_BY_CUSTOMERS = "$BASE_URL/users/CreateInvoicePdfByCustomers";
  static const String RECCURR_DATE = "$BASE_URL/users/getRecurrdate";
  static const String STAFF_VALIDATION =
      "$BASE_URL/users/staffvalidateRecurrDate";
  static const String GET_STAFF_DETAILS = "$BASE_URL/users/getStaffDetails";
  static const String EDIT_STAFF_DETAILS = "$BASE_URL/users/updateStaffDetails";
  static const String DELETE_STAFF = "$BASE_URL/users/deleteStaff";
  static const String DELETE_MEDIA_FILE = "$BASE_URL/users/deleteMediafile";
  static const String GET_JOB_STATUS = "$BASE_URL/users/getJobStatus";
  static const String SAVE_JOB_STATUS = "$BASE_URL/users/saveJobStatus";
  static const String GET_PROFILE = "$BASE_URL/profile/getProfile";
  static const String SET_PROFILE = "$BASE_URL/profile/saveMasterProfile";
  static const String VERIFY_PASSWORD = "$BASE_URL/profile/verifyPassword";
  static const String GET_OTP_FOR_MOBILE_CHANGE =
      "$BASE_URL/profile/getOtpForMobileChanges";
  static const String SAVE_CHANGES_MOBILE_NO =
      "$BASE_URL/profile/saveChangesMobile";
  static const String GET_CUSTOMER_SERVICE_HISTORY =
      "$BASE_URL/users/getCustomerServiceHistory";
  static const String STAFF_USER_LOGIN = "$BASE_URL/users/staffUserLogin";
  static const String PHN_NO_REG_CHECK = "$BASE_URL/users/phoneNoRegCheck";

  static const String GET_WORKING_HOURS = "$BASE_URL/users/getWorkingHours";
  static const String ADD_WORKING_HOURS = "$BASE_URL/users/addWorkingHours";

  static const String GET_TIME_INTERVAL = "$BASE_URL/users/getTimeInterval";
  static const String SAVE_TIME_INTERVAL = "$BASE_URL/users/saveTimeInterval";

  static const String GET_MAX_JOB_TASK = "$BASE_URL/users/getMaxJobTask";
  static const String SAVE_MAX_JOB_TASK = "$BASE_URL/users/saveMaxJobTask";

  static const String USER_TYPE = "$BASE_URL/users/getUserTypeAndUserInfo";

  static const String GET_PRIVILEGE = "$BASE_URL/users/get_assigned_priviledges";

  static const String SAVE_TIME_SHEET = "$BASE_URL/users/saveTimeSheet";
  static const String TIME_SHEET_BY_BILLNO_STAFF = "$BASE_URL/users/TimeSheetbyBillNoAndStaffId";
  static const String SAVE_PRIVILEGE = "$BASE_URL/users/save_user_priviledges";

  static const String GET_REMINDER = "$BASE_URL/users/getNotificationMaster";
  static const String SET_REMINDER = "$BASE_URL/users/saveNotificationMaster";
}
