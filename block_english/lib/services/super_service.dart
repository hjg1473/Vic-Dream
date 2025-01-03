import 'package:block_english/models/MonitoringModel/group_monitoring_model.dart';
import 'package:block_english/models/MonitoringModel/group_progress_model.dart';
import 'package:block_english/models/MonitoringModel/user_summary_model.dart';
import 'package:block_english/models/model.dart';
import 'package:block_english/utils/constants.dart';
import 'package:block_english/utils/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'super_service.g.dart';

class SuperService {
  static const String _super = "super";
  static const String _parent = "parent";
  static const String _group = "group";
  static const String _info = "info";
  static const String _getpin = "get_pin";
  static const String _groupId = "group_id";
  static const String _groupName = 'group_name';
  static const String _groupDetail = 'group_detail';
  static const String _groupUpdate = 'group_update';
  late final SuperServiceRef _ref;

  SuperService(SuperServiceRef ref) {
    _ref = ref;
  }

  Future<Either<FailureModel, SuperInfoModel>> getSuperInfo() async {
    final dio = _ref.watch(dioProvider);
    try {
      final response = await dio.get(
        '/$_super/$_info',
        options: Options(
          headers: {TOKENVALIDATE: 'true'},
        ),
      );
      return Right(SuperInfoModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'] ?? "",
      ));
    }
  }

  Future<Either<FailureModel, List<StudentsInfoModel>>> getChildList() async {
    final dio = _ref.watch(dioProvider);
    try {
      final response = await dio.get(
        '/$_super/$_parent/get_child',
        options: Options(
          headers: {TOKENVALIDATE: 'true'},
        ),
      );
      return Right((response.data['children'] as List)
          .map((e) => StudentsInfoModel.fromJson(e))
          .toList());
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'] ?? "",
      ));
    }
  }

  Future<Either<FailureModel, List<GroupInfoModel>>> getGroupList() async {
    final dio = _ref.watch(dioProvider);
    try {
      final response = await dio.get(
        '/$_super/$_group',
        options: Options(
          headers: {TOKENVALIDATE: 'true'},
        ),
      );
      return Right((response.data['groups'] as List)
          .map((e) => GroupInfoModel.fromJson(e))
          .toList());
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'] ?? "",
      ));
    }
  }

  Future<Either<FailureModel, CreateGroupResponseModel>> postCreateGroup(
      String name, String detailText) async {
    final dio = _ref.watch(dioProvider);
    try {
      final response = await dio.post(
        '/super/create/group',
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
          },
        ),
        data: {
          'name': name,
          'detail': detailText,
        },
      );
      return Right(CreateGroupResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'] ?? "",
      ));
    }
  }

  Future<Either<FailureModel, List<StudentsInfoModel>>> getStudentInGroup(
      int groupId) async {
    final dio = _ref.watch(dioProvider);
    try {
      final response = await dio.get(
        '/super/student_in_group/$groupId',
        options: Options(
          headers: {'accept': 'application/json', TOKENVALIDATE: 'true'},
        ),
      );
      return Right((response.data['groups'] as List)
          .map((e) => StudentsInfoModel.fromJson(e))
          .toList());
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'] ?? "",
      ));
    }
  }

  Future<Either<FailureModel, PinModel>> getParentPinNumber() async {
    try {
      final dio = _ref.watch(dioProvider);
      final response = await dio.get(
        '/$_super/$_parent/$_getpin',
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
          },
        ),
      );

      return Right(PinModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'],
      ));
    }
  }

  Future<Either<FailureModel, PinModel>> postPinNumber(int groupId) async {
    try {
      final dio = _ref.watch(dioProvider);
      final response = await dio.post(
        '/$_super/$_getpin',
        options: Options(
          headers: {'accept': 'application/json', TOKENVALIDATE: 'true'},
        ),
        data: {
          _groupId: groupId.toString(),
        },
      );

      return Right(PinModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'],
      ));
    }
  }

  Future<Either<FailureModel, Response>> putGroupUpdate(
      int groupId, String groupName, String detail) async {
    try {
      final dio = _ref.watch(dioProvider);
      final response = await dio.put('/$_super/$_groupUpdate',
          options: Options(
            contentType: Headers.jsonContentType,
            headers: {TOKENVALIDATE: 'true'},
          ),
          data: {
            _groupId: groupId,
            _groupName: groupName,
            _groupDetail: detail,
          });

      return Right(response);
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'],
      ));
    }
  }

  Future<Either<FailureModel, Response>> deleteRemoveGroup(
    int groupId,
  ) async {
    try {
      final dio = _ref.watch(dioProvider);
      final response = await dio.delete(
        '/$_super/$_group/remove_group/$groupId',
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
          },
        ),
      );

      return Right(response);
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'],
      ));
    }
  }

  Future<Either<FailureModel, Response>> putRemoveStudentInGroup(
    int studentId,
  ) async {
    try {
      final dio = _ref.watch(dioProvider);
      final response = await dio.put(
        '/$_super/$_group/remove_student/$studentId',
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
          },
        ),
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'],
      ));
    }
  }

  Future<Either<FailureModel, GroupProgressModel>> getGroupInfo(
    int groupId,
  ) async {
    try {
      final dio = _ref.watch(dioProvider);
      final response = await dio.get(
        '/$_super/$_group/$groupId/info',
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
          },
        ),
      );

      return Right(GroupProgressModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'],
      ));
    }
  }

  Future<Either<FailureModel, Response>> putGroupLevelUnlock(
    int groupId,
    String type,
    int season,
    int level,
    int step,
  ) async {
    try {
      final dio = _ref.watch(dioProvider);
      final response = await dio.put(
        '/$_super/$_group/$groupId/problems/unlock',
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
          },
        ),
        queryParameters: {
          'type': type,
          'season': season,
          'level': level,
          'step': step,
        },
      );

      return Right(response);
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'],
      ));
    }
  }

  Future<Either<FailureModel, UserSummaryModel>> postUserMonitoringSummary(
    int userId,
    int season,
  ) async {
    try {
      final dio = _ref.watch(dioProvider);
      final response = await dio.post(
        '/$_super/user_monitoring_summary',
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'user_id': userId,
          'season': season,
        },
      );

      return Right(UserSummaryModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'],
      ));
    }
  }

  Future<Either<FailureModel, List<StudyInfoModel>>>
      postUserMonitoringStudyRate(
    int userId,
    int season,
  ) async {
    try {
      final dio = _ref.watch(dioProvider);
      final response = await dio.post(
        '/$_super/user_monitoring_study/rate',
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'user_id': userId,
          'season': season,
        },
      );
      debugPrint(response.data.toString());
      return Right((response.data['detail'] as List).map((e) {
        return StudyInfoModel.fromJson(e);
      }).toList());
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'],
      ));
    }
  }

  Future<Either<FailureModel, IncorrectModel>> postUserMonitoringIncorrect(
    int userId,
    int season,
  ) async {
    try {
      final dio = _ref.watch(dioProvider);
      final response = await dio.post(
        '/$_super/user_monitoring_incorrect',
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'user_id': userId,
          'season': season,
        },
      );

      return Right(IncorrectModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'],
      ));
    }
  }

  Future<Either<FailureModel, StudyTimeModel>> postUserMonitoringEtc(
    int userId,
    int season,
  ) async {
    try {
      final dio = _ref.watch(dioProvider);
      final response = await dio.post(
        '/$_super/user_monitoring_etc',
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'user_id': userId,
          'season': season,
        },
      );

      return Right(StudyTimeModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'],
      ));
    }
  }

  Future<Either<FailureModel, GroupMonitoringModel>> postGroupMonitoring(
      int groupId) async {
    try {
      final dio = _ref.watch(dioProvider);
      final response = await dio.post(
        '/$_super/group_monitoring',
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'group_id': groupId,
        },
      );

      return Right(GroupMonitoringModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'],
      ));
    }
  }
}

@Riverpod(keepAlive: true)
SuperService superService(SuperServiceRef ref) {
  return SuperService(ref);
}
