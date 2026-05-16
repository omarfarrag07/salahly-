import 'package:kafa2a/features/home/user/domain/entities/category.dart';

class RequestServiceStates {}

class RequestServiceInitialState extends RequestServiceStates {}

class GetCategoriesSuccessState extends RequestServiceStates {
  GetCategoriesSuccessState(this.categories);

  final List<Category> categories;
}

class GetCategoriesLoadingState extends RequestServiceStates {}

class GetCategoriesErrorState extends RequestServiceStates {
  GetCategoriesErrorState(this.error);

  final String error;
}

class RequestServiceErrorState extends RequestServiceStates {
  RequestServiceErrorState(this.error);

  final String error;
}

class RequestServiceLoadingState extends RequestServiceStates {}

class RequestServiceSuccessState extends RequestServiceStates {}
