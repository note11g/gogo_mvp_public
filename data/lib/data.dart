import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:gogo_mvp_data/datasource/app/app_info_remote_data_source.dart';
import 'package:gogo_mvp_data/datasource/app/app_local_data_source.dart';
import 'package:gogo_mvp_data/datasource/auth/auth_local_data_source.dart';
import 'package:gogo_mvp_data/datasource/auth/auth_remote_data_source.dart';
import 'package:gogo_mvp_data/datasource/chat/chat_remote_data_source.dart';
import 'package:gogo_mvp_data/datasource/gogo/gogo_cache_data_source.dart';
import 'package:gogo_mvp_data/datasource/gogo/gogo_remote_data_source.dart';
import 'package:gogo_mvp_data/datasource/image/image_remote_data_source.dart';
import 'package:gogo_mvp_data/datasource/member/member_remote_data_source.dart';
import 'package:gogo_mvp_data/datasource/notification/notification_remote_data_source.dart';
import 'package:gogo_mvp_data/datasource/report/report_remote_data_source.dart';
import 'package:gogo_mvp_data/datastore/gogo_cache_store.dart';
import 'package:gogo_mvp_data/repository/app_info_repository_impl.dart';
import 'package:gogo_mvp_data/repository/auth_repository_impl.dart';
import 'package:gogo_mvp_data/repository/chat_repository_impl.dart';
import 'package:gogo_mvp_data/repository/gogo_repository_impl.dart';
import 'package:gogo_mvp_data/repository/image_repository_impl.dart';
import 'package:gogo_mvp_data/repository/notification_repository_impl.dart';
import 'package:gogo_mvp_data/repository/report_repository_impl.dart';
import 'package:gogo_mvp_domain/repository/app_info_repository.dart';
import 'package:gogo_mvp_domain/repository/auth_repository.dart';
import 'package:gogo_mvp_domain/repository/chat_repository.dart';
import 'package:gogo_mvp_domain/repository/gogo_repository.dart';
import 'package:gogo_mvp_domain/repository/image_repository.dart';
import 'package:gogo_mvp_domain/repository/notification_repository.dart';
import 'package:gogo_mvp_domain/repository/report_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataLayerDiInitializer {
  static Future<void> init(GetIt getIt) async {
    await _initDataStore(getIt);
    _initDataSource(getIt);
    _initRepository(getIt);
  }

  static Future<void> _initDataStore(GetIt getIt) async {
    final dio = Dio()..interceptors.add(LogInterceptor(responseBody: true));
    final firestore = FirebaseFirestore.instance;
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseStorage = FirebaseStorage.instance;
    final firebaseDatabase = FirebaseDatabase.instance;
    final goCacheStore = GoCacheStore();
    final sharedPreferences = await SharedPreferences.getInstance();
    const flutterSecureStorage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true));

    getIt
      ..registerSingleton(dio)
      ..registerSingleton(firestore)
      ..registerSingleton(firebaseAuth)
      ..registerSingleton(firebaseStorage)
      ..registerSingleton(firebaseDatabase)
      ..registerSingleton(sharedPreferences)
      ..registerSingleton(goCacheStore)
      ..registerSingleton(flutterSecureStorage);
  }

  static void _initDataSource(GetIt getIt) {
    final authRemoteDataSource =
        AuthRemoteDataSource(getIt.get(), getIt.get(), getIt.get());
    final authLocalDataSource = AuthLocalDataSource(getIt.get(), getIt.get());
    final imageRemoteDataSource =
        ImageRemoteDataSource(getIt.get(), getIt.get());
    final appInfoRemoteDataSource = AppInfoRemoteDataSource(getIt.get());
    final gogoRemoteDataSource = GogoRemoteDataSource(getIt.get());
    final gogoCacheDataSource = GogoCacheDataSource(getIt.get());
    final memberRemoteDataSource = MemberRemoteDataSource(getIt.get());
    final appLocalDataSource = AppLocalDataSource(getIt.get());
    final notificationRemoteDataSource =
        NotificationRemoteDataSource(getIt.get());
    getIt
      ..registerSingleton(authRemoteDataSource)
      ..registerSingleton(authLocalDataSource)
      ..registerSingleton(imageRemoteDataSource)
      ..registerSingleton(appInfoRemoteDataSource)
      ..registerSingleton(gogoCacheDataSource)
      ..registerSingleton(gogoRemoteDataSource)
      ..registerSingleton(memberRemoteDataSource)
      ..registerSingleton(appLocalDataSource)
      ..registerSingleton(notificationRemoteDataSource)
      ..registerLazySingleton(() => ReportRemoteDataSource(getIt.get()))
      ..registerLazySingleton(() => ChatRemoteDataSource(getIt.get()));
  }

  static void _initRepository(GetIt getIt) {
    final authRepository = AuthRepositoryImpl(getIt.get(), getIt.get());
    final imageRepository = ImageRepositoryImpl(getIt.get(), getIt.get());
    final appInfoRepository = AppInfoRepositoryImpl(getIt.get());
    final gogoRepository = GogoRepositoryImpl(
        getIt.get(), getIt.get(), getIt.get(), getIt.get(), getIt.get());
    getIt
      ..registerSingleton<AuthRepository>(authRepository)
      ..registerSingleton<ImageRepository>(imageRepository)
      ..registerSingleton<AppInfoRepository>(appInfoRepository)
      ..registerSingleton<GogoRepository>(gogoRepository)
      ..registerLazySingleton<ReportRepository>(() => ReportRepositoryImpl(getIt.get()))
      ..registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
          getIt.get(), getIt.get(), getIt.get(), getIt.get()))
      ..registerLazySingleton<NotificationRepository>(() =>
          NotificationRepositoryImpl(getIt.get(), getIt.get(), getIt.get()));
  }
}
