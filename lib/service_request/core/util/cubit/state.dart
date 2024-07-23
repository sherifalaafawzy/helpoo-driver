// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';

abstract class NewServiceRequestState {}

class Empty extends NewServiceRequestState {}

class BillingAddressChanged extends NewServiceRequestState {}

class EmptyStateToRebuild extends NewServiceRequestState {}

class SearchState extends NewServiceRequestState {}

class Loading extends NewServiceRequestState {}

class Loaded extends NewServiceRequestState {}

class ThemeLoaded extends NewServiceRequestState {}

class LanguageLoaded extends NewServiceRequestState {}

class ChangeLanguage extends NewServiceRequestState {}

class SearchMapPlaceLoading extends NewServiceRequestState {}

class SearchMapPlaceSuccess extends NewServiceRequestState {}

class SearchMapPlaceError extends NewServiceRequestState {
  final String error;

  SearchMapPlaceError({
    required this.error,
  });
}

class ChangeIsFromSearch extends NewServiceRequestState {}

class GetMapPlaceDetailsLoading extends NewServiceRequestState {}

class GetMapPlaceDetailsSuccess extends NewServiceRequestState {}

class GetMapPlaceDetailsError extends NewServiceRequestState {
  final String error;

  GetMapPlaceDetailsError({
    required this.error,
  });
}

class GetMapPlaceCoordinatesDetailsLoading extends NewServiceRequestState {}

class GetMapPlaceCoordinatesDetailsSuccess extends NewServiceRequestState {}

class GetMapPlaceCoordinatesDetailsError extends NewServiceRequestState {
  final String error;

  GetMapPlaceCoordinatesDetailsError({
    required this.error,
  });
}

class ChangeIsOrigin extends NewServiceRequestState {}

// class SetMapControllerLoading extends NewServiceRequestState {}

class SetMapControllerSuccess extends NewServiceRequestState {}

class SetMyLocationSuccess extends NewServiceRequestState {}

class SetMyLocationError extends NewServiceRequestState {}

class ChangeInitialCameraPosition extends NewServiceRequestState {}

class ClearFields extends NewServiceRequestState {}

class ClearOnStart extends NewServiceRequestState {}

class MoveCameraToPositionSuccess extends NewServiceRequestState {}

class AddMarkerSuccess extends NewServiceRequestState {}

class CameraMovementPositionChanged extends NewServiceRequestState {}

class ChangeOriginLatLng extends NewServiceRequestState {}

class ChangeDestinationLatLng extends NewServiceRequestState {}

class GetPathToDrawSuccess extends NewServiceRequestState {}

class GetPathToDrawError extends NewServiceRequestState {}

class GetDriverPathToDrawSuccess extends NewServiceRequestState {}

class GetDriverPathToDrawError extends NewServiceRequestState {}

class ExpandCameraToDisplayAllRouteSuccess extends NewServiceRequestState {}

class GetServiceRequestTypesLoadingState extends NewServiceRequestState {}

class GetServiceRequestTypesSuccessState extends NewServiceRequestState {}

class GetServiceRequestTypesErrorState extends NewServiceRequestState {
  final String error;

  GetServiceRequestTypesErrorState({
    required this.error,
  });
}

class IsGettingPathLoading extends NewServiceRequestState {}

class IsCameraIdle extends NewServiceRequestState {}

class ChangeIsNormalTowingSelected extends NewServiceRequestState {}

class TowingSelectedActionState extends NewServiceRequestState {}

class CountOpenedBottomSheets extends NewServiceRequestState {}

class SelectedCarIdChanged extends NewServiceRequestState {}

class CalculateServiceFeesLoadingState extends NewServiceRequestState {}

class CalculateServiceFeesSuccessState extends NewServiceRequestState {}

class CalculateServiceFeesErrorState extends NewServiceRequestState {
  final String error;

  CalculateServiceFeesErrorState({
    required this.error,
  });
}

class ChangeSelectedFees extends NewServiceRequestState {}

class ChangeSelectedPercentage extends NewServiceRequestState {}

class GetDriverInfoLoadingState extends NewServiceRequestState {}

class GetDriverInfoSuccessState extends NewServiceRequestState {}

class GetDriverInfoErrorState extends NewServiceRequestState {
  final String error;

  GetDriverInfoErrorState({
    required this.error,
  });
}

class CreateNewRequestLoadingState extends NewServiceRequestState {}

class CreateNewRequestSuccessState extends NewServiceRequestState {}

class CreateNewRequestErrorState extends NewServiceRequestState {
  final String error;

  CreateNewRequestErrorState({
    required this.error,
  });
}

class ChangeOriginAddress extends NewServiceRequestState {}

class ChangeDestinationAddress extends NewServiceRequestState {}

class ToggleSlidingUpPanelSuccess extends NewServiceRequestState {}

class SlidingUpPanelHeightChanged extends NewServiceRequestState {}

class ToggleServiceOrderedSuccess extends NewServiceRequestState {}

class CancelServiceRequestLoadingState extends NewServiceRequestState {}

class CancelServiceRequestSuccessState extends NewServiceRequestState {}

class CancelServiceRequestErrorState extends NewServiceRequestState {
  final String error;

  CancelServiceRequestErrorState({
    required this.error,
  });
}

class ShowPaymentBottomSheetState extends NewServiceRequestState {}

class PaymentMethodChangedSuccess extends NewServiceRequestState {}

class GetCurrentServiceRequestStatusState extends NewServiceRequestState {
  final ServiceRequestStatusEnum serviceRequestStatus;
  bool isFirstTime;

  GetCurrentServiceRequestStatusState({
    required this.serviceRequestStatus,
    this.isFirstTime = false,
  });
}

class CheckServiceRequestLoadingState extends NewServiceRequestState {}

class CheckServiceRequestSuccessState extends NewServiceRequestState {
  final bool isRequestActive;

  CheckServiceRequestSuccessState({
    required this.isRequestActive,
  });
}

class CheckServiceRequestErrorState extends NewServiceRequestState {
  final String error;

  CheckServiceRequestErrorState({
    required this.error,
  });
}

class GetCurrentActiveServiceRequestLoadingState extends NewServiceRequestState {}

class GetCurrentActiveServiceRequestSuccessState extends NewServiceRequestState {
  final bool fromIframe;

  GetCurrentActiveServiceRequestSuccessState({
    required this.fromIframe,
  });
}

class GetCurrentActiveServiceRequestErrorState extends NewServiceRequestState {
  final String error;

  GetCurrentActiveServiceRequestErrorState({
    required this.error,
  });
}

class ChangeOriginName extends NewServiceRequestState {}

class ChangeDestinationName extends NewServiceRequestState {}

class GetConfigLoadingState extends NewServiceRequestState {}

class GetConfigSuccessState extends NewServiceRequestState {}

class GetConfigErrorState extends NewServiceRequestState {
  final String error;

  GetConfigErrorState({
    required this.error,
  });
}

class GetIFrameUrlLoadingState extends NewServiceRequestState {}

class GetIFrameUrlSuccessState extends NewServiceRequestState {}

class GetIFrameUrlErrorState extends NewServiceRequestState {
  final String error;

  GetIFrameUrlErrorState({
    required this.error,
  });
}

class IsOnlinePaymentOnlyChangedSuccess extends NewServiceRequestState {}

class WebViewControllerChangedSuccess extends NewServiceRequestState {}

class OnlinePaymentSuccessState extends NewServiceRequestState {}

class ChangeIsPaymentSuccessState extends NewServiceRequestState {}

class ChangeIsPaymentLoadingState extends NewServiceRequestState {}

class UpdateServiceRequestLoadingState extends NewServiceRequestState {}

class UpdateServiceRequestSuccessState extends NewServiceRequestState {}

class UpdateServiceRequestErrorState extends NewServiceRequestState {
  final String error;

  UpdateServiceRequestErrorState({
    required this.error,
  });
}

class IsSlidingUpPanelShow extends NewServiceRequestState {}

class RateRequestLoading extends NewServiceRequestState {}

class RateRequestSuccess extends NewServiceRequestState {}

class RateRequestError extends NewServiceRequestState {
  final String error;

  RateRequestError({
    required this.error,
  });
}

class RateRequestRateChangedSuccess extends NewServiceRequestState {}

class UnAssignDriverLoadingState extends NewServiceRequestState {}

class UnAssignDriverSuccessState extends NewServiceRequestState {}

class UnAssignDriverErrorState extends NewServiceRequestState {
  final String error;

  UnAssignDriverErrorState({
    required this.error,
  });
}

class AssignDriverLoadingState extends NewServiceRequestState {}

class AssignDriverSuccessState extends NewServiceRequestState {}

class AssignDriverErrorState extends NewServiceRequestState {
  final String error;

  AssignDriverErrorState({
    required this.error,
  });
}

class CorporateRequestIdChanged extends NewServiceRequestState {}

class GetPaymentMethodsListSuccess extends NewServiceRequestState {}

class SetCorporateClientId extends NewServiceRequestState {}

class ApplyVoucherCodeLoading extends NewServiceRequestState {}

class ApplyVoucherCodeSuccess extends NewServiceRequestState {}

class ApplyVoucherCodeError extends NewServiceRequestState {
  final String error;

  ApplyVoucherCodeError({
    required this.error,
  });
}

class SetCurrentLoadingIndexState extends NewServiceRequestState {}

class SetIsGetSRLoadingState extends NewServiceRequestState {}

class PrimaryBottomSheetOpenedState extends NewServiceRequestState {}
// class ClearOnStartLoading extends NewServiceRequestState {}
//
// class GetDriverPathLoading extends NewServiceRequestState {}
//
// class OpenLoadingState extends NewServiceRequestState {}
//
// class CloseLoadingState extends NewServiceRequestState {}

class ConvertEnglishNumbersToArabicState extends NewServiceRequestState {}

class SelectedCarChanged extends NewServiceRequestState {}

class CheckPromoIfPackageOrNormalLoading extends NewServiceRequestState {}

class CheckPromoIfPackageOrNormalSuccess extends NewServiceRequestState {}

class CheckPromoIfPackageOrNormalError extends NewServiceRequestState {
  final String error;

  CheckPromoIfPackageOrNormalError({
    required this.error,
  });
}

class PackagePromoCodeChanged extends NewServiceRequestState {}

class IsPayWithPackageDiscount extends NewServiceRequestState {}

class AccidentDetailsLoading extends NewServiceRequestState {}

class AccidentDetailsSuccess extends NewServiceRequestState {}

class AccidentDetailsError extends NewServiceRequestState {
  final String error;

  AccidentDetailsError({
    required this.error,
  });
}

class SendFnolStepPdfLoading extends NewServiceRequestState {}

class SendFnolStepPdfSuccess extends NewServiceRequestState {}

class SendFnolStepPdfError extends NewServiceRequestState {
  final String error;

  SendFnolStepPdfError({
    required this.error,
  });
}
