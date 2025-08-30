import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../data/remote/dio/dio_client.dart';
import '../data/remote/dio/logging_interceptors.dart';
import 'data/repo/auth_repo.dart';
import 'data/repo/user_repo.dart';
import 'data/utils/api_end_points.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // core
  // sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => DioClient(ApiEndPoints.baseUrl, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => UserRepo(dioClient: sl()));
  // sl.registerLazySingleton(() => CommonRepo(dioClient: sl(), sharedPreferences: sl()));


  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  // sl.registerLazySingleton(() => Connectivity());
}
