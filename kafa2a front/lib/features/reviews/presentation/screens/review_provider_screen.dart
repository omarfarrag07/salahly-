import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/core/widgets/ui_utils.dart';
import 'package:kafa2a/features/home/user/presentation/screens/user_main_screen.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_requests/all_requests.dart';
import 'package:kafa2a/features/reviews/data/models/review_provider_request.dart';
import 'package:kafa2a/features/reviews/presentation/cubit/review_provider_cubit.dart';
import 'package:kafa2a/features/reviews/presentation/cubit/review_provider_states.dart';

class ProviderRatingScreen extends StatefulWidget {
  const ProviderRatingScreen({
    super.key,
  });

  @override
  State<ProviderRatingScreen> createState() => _ProviderRatingScreenState();
}

class _ProviderRatingScreenState extends State<ProviderRatingScreen> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AllRequests request =
        ModalRoute.of(context)!.settings.arguments as AllRequests;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Provider'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'How was your experience with this provider?',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Tap stars to rate the provider',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 50,
                    color: ColorsManager.blue,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              _rating == 0
                  ? ''
                  : 'You rated: $_rating star${_rating > 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),

            // Review Text Field
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Tell us about your experience (optional)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ColorsManager.blue),
                ),
                hintText:
                    'Was the provider professional? How was the service quality?',
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Your feedback helps providers improve their service',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 40),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: BlocListener<ReviewProviderCubit, ReviewProviderStates>(
                listener: (context, state) {
                  if (state is ReviewProviderLoadingState) {
                    UIUtils.showLoading(context);
                  } else if (state is ReviewProviderErrorState) {
                    UIUtils.hideLoading(context);
                    UIUtils.showMessage(state.error);
                  } else if (state is ReviewProviderSuccessState) {
                    UIUtils.hideLoading(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserMainScreen(),
                      ),
                      (route) => true,
                    );
                  }
                },
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => context
                      .read<ReviewProviderCubit>()
                      .reviewProvider(ReviewProviderRequest(
                          rating: _rating,
                          review: _reviewController.text,
                          serviceRequestId: request.id)),
                  child: const Text(
                    'SUBMIT RATING',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
