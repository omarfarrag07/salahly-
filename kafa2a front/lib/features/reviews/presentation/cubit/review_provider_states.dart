abstract class ReviewProviderStates {}

class ReviewProviderInitialState extends ReviewProviderStates {}

class ReviewProviderLoadingState extends ReviewProviderStates {}

class ReviewProviderErrorState extends ReviewProviderStates {
  String error;

  ReviewProviderErrorState(this.error);
}

class ReviewProviderSuccessState extends ReviewProviderStates {}
