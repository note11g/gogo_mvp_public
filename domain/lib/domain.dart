import 'package:get_it/get_it.dart';
import 'package:gogo_mvp_domain/usecase/auth/delete_account_usecase.dart';
import 'package:gogo_mvp_domain/usecase/auth/login_with_apple_usecase.dart';
import 'package:gogo_mvp_domain/usecase/gogo/accept_gogo_invite_usecase.dart';
import 'package:gogo_mvp_domain/usecase/gogo/deny_gogo_invite_usecase.dart';
import 'package:gogo_mvp_domain/usecase/gogo/get_gogo_info_usecase.dart';
import 'package:gogo_mvp_domain/usecase/gogo/get_gogo_invite_usecase.dart';
import 'package:gogo_mvp_domain/usecase/gogo/leave_gogo_usecase.dart';
import 'package:gogo_mvp_domain/usecase/gogo/send_gogo_request_usecase.dart';
import 'package:gogo_mvp_domain/usecase/gogo/provide_stream_gogo_invite_usecase.dart';
import 'package:gogo_mvp_domain/usecase/gogo/provide_stream_joined_gogo_usecase.dart';
import 'package:gogo_mvp_domain/usecase/image/download_image_usecase.dart';
import 'package:gogo_mvp_domain/usecase/report/provide_stream_chat_new_message_usecase.dart';
import 'package:gogo_mvp_domain/usecase/report/provide_stream_chat_updated_message_usecase.dart';
import 'package:gogo_mvp_domain/usecase/report/read_chat_message_usecase.dart';
import 'package:gogo_mvp_domain/usecase/report/report_chat_message_usecase.dart';
import 'package:gogo_mvp_domain/usecase/report/send_chat_image_usecase.dart';
import 'package:gogo_mvp_domain/usecase/report/send_chat_message_usecase.dart';
import 'usecase/notification/update_fcm_token_usecase.dart';
import 'usecase/app_info/get_all_tags_use_case.dart';
import 'usecase/app_info/get_app_version_info_usecase.dart';
import 'usecase/user/get_my_info_at_editing_usecase.dart';
import 'usecase/user/get_my_info_usecase.dart';
import 'usecase/auth/login_check_usecase.dart';
import 'usecase/auth/login_with_kakao_usecase.dart';
import 'usecase/user/update_my_info_usecase.dart';
import 'usecase/user/upload_profile_image_usecase.dart';
import 'usecase/auth/sign_out_user_usecase.dart';

class DomainLayerDiInitializer {
  static void init(GetIt getIt) {
    getIt
      ..registerSingleton(CheckLoginUseCase(getIt.get()))
      ..registerSingleton(GetAppVersionInfoUseCase(getIt.get()))
      ..registerSingleton(UpdateFcmTokenUseCase(getIt.get()))
      ..registerSingleton(ProvideStreamGogoInviteUseCase(getIt.get()))
      ..registerSingleton(ProvideStreamJoinedGogoUseCase(getIt.get()))
      ..registerSingleton(GetGogoInfoUseCase(getIt.get()))
      ..registerLazySingleton(() => GetGogoInviteUseCase(getIt.get()))
      ..registerLazySingleton(() => LeaveGogoUseCase(getIt.get(), getIt.get()))
      ..registerLazySingleton(
          () => AcceptGogoInviteUseCase(getIt.get(), getIt.get()))
      ..registerLazySingleton(() => DenyGogoInviteUseCase(getIt.get()))
      ..registerLazySingleton(
          () => SendGogoRequestUseCase(getIt.get(), getIt.get()))
      ..registerLazySingleton(() => GetAllTagsUseCase(getIt.get()))
      ..registerLazySingleton(
          () => ProvideStreamChatNewMessageUseCase(getIt.get()))
      ..registerLazySingleton(
          () => ProvideStreamChatUpdatedMessageUseCase(getIt.get()))
      ..registerLazySingleton(() => SendChatMessageUseCase(getIt.get()))
      ..registerLazySingleton(
          () => SendChatImageUseCase(getIt.get(), getIt.get()))
      ..registerLazySingleton(() => ReadChatMessageUseCase(getIt.get()))
      ..registerLazySingleton(() => ReportChatMessageUseCase(getIt.get()))
      ..registerLazySingleton(() => GetMyInfoUseCase(getIt.get()))
      ..registerLazySingleton(() => LoginWithKakaoUseCase(getIt.get()))
      ..registerLazySingleton(() => LoginWithAppleUseCase(getIt.get()))
      ..registerLazySingleton(() => GetMyInfoAtEditingUseCase(getIt.get()))
      ..registerLazySingleton(() => UpdateMyInfoUseCase(getIt.get()))
      ..registerLazySingleton(() => SignOutUserUseCase(getIt.get()))
      ..registerLazySingleton(() => DeleteAccountUseCase(getIt.get()))
      ..registerLazySingleton(() => DownloadImageUseCase(getIt.get()))
      ..registerLazySingleton(() => UploadProfileImageUseCase(getIt.get()));
  }
}
