import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/home/user/data/models/request_service_request.dart';
import 'package:kafa2a/features/home/user/data/models/request_service_response.dart';
import 'package:kafa2a/features/home/user/domain/entities/category.dart';
import 'package:kafa2a/features/home/user/domain/use_cases/get_all_categories.dart';
import 'package:kafa2a/features/home/user/domain/use_cases/request_service.dart';
import 'package:kafa2a/features/home/user/presentation/cubit/request_service/request_service_states.dart';

@Injectable()
class RequestServiceCubit extends Cubit<RequestServiceStates> {
  RequestServiceCubit(this._getAllCategories, this._requestService)
      : super(RequestServiceInitialState()) {
    getAllCategories();
  }

  final GetAllCategories _getAllCategories;
  final RequestService _requestService;
  List<Category>? categories;

  Future<void> getAllCategories() async {
    emit(GetCategoriesLoadingState());
    Either<List<Category>, Failure> response = await _getAllCategories();
    response.fold(
      (categoriesSuccess) {
        categories = categoriesSuccess;
        emit(GetCategoriesSuccessState(categoriesSuccess));
      },
      (error) => emit(GetCategoriesErrorState(error.message)),
    );
  }

  Future<void> requestService(RequestServiceRequest requestService) async {
    emit(RequestServiceLoadingState());
    final Either<RequestServiceResponse, Failure> response =
        await _requestService(requestService);
    response.fold(
      (_) {
        emit(RequestServiceSuccessState());
        emit(GetCategoriesSuccessState(categories!));
        categories = null;
      },
      (error) => emit(RequestServiceErrorState(error.message)),
    );
  }
}
