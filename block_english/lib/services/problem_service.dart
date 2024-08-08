import 'package:block_english/models/ProblemModel/problems_model.dart';
import 'package:block_english/models/model.dart';
import 'package:block_english/utils/constants.dart';
import 'package:block_english/utils/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'problem_service.g.dart';

@Riverpod(keepAlive: true)
ProblemService problemService(ProblemServiceRef ref) {
  return ProblemService(ref);
}

class ProblemService {
  static const String _problem = 'problem';
  static const String _practice = 'practice';
  static const String _info = 'info';
  static const String _set = 'set';

  static late final ProblemServiceRef _ref;

  ProblemService(ProblemServiceRef ref) {
    _ref = ref;
  }

  Future<Either<FailureModel, ProblemPracticeInfoModel>> getProblemPracticeInfo(
      int season) async {
    final dio = _ref.watch(dioProvider);

    try {
      final response = await dio.get(
        '/$_problem/$_practice/$_info',
        queryParameters: {'season': season},
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
          },
        ),
      );
      return Right(ProblemPracticeInfoModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        FailureModel(
          statusCode: e.response?.statusCode ?? 0,
          detail: e.response?.data['detail'] ?? "",
        ),
      );
    }
  }

  Future<Either<FailureModel, ProblemsModel>> getProblemPracticeSet(
      int season, int level, int step) async {
    final dio = _ref.watch(dioProvider);

    try {
      final response = await dio.get(
        '/$_problem/$_practice/$_set',
        queryParameters: {'season': season, 'level': level, 'step': step},
        options: Options(
          headers: {
            'accept': 'application/json',
            TOKENVALIDATE: 'true',
          },
        ),
      );

      return Right(ProblemsModel.fromJson(response.data, StudyMode.practice));
    } on DioException catch (e) {
      return Left(FailureModel(
        statusCode: e.response?.statusCode ?? 0,
        detail: e.response?.data['detail'] ?? "",
      ));
    }
  }
}
