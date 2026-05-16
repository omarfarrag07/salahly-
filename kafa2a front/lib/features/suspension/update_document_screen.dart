import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/core/di/service_locator.dart';
import 'package:kafa2a/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_states.dart';
import 'package:kafa2a/features/auth/presentation/screens/widgets/label_text_form_widget.dart';
import 'package:kafa2a/core/widgets/default_elevated_button.dart';
import 'package:kafa2a/core/constants.dart';

class UpdateDocumentScreen extends StatefulWidget {
  const UpdateDocumentScreen({super.key});

  @override
  State<UpdateDocumentScreen> createState() => _UpdateDocumentScreenState();
}

class _UpdateDocumentScreenState extends State<UpdateDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController serviceIdController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();

  bool isLoading = false;

  Future<void> submitDocuments() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final dio = getIt<Dio>();
      final authLocal = getIt<AuthLocalDataSource>();
      final token = authLocal.getToken();
      final authCubit = context.read<AuthCubit>();
      final formData = FormData.fromMap({
        'address': addressController.text,
        'service_id': serviceIdController.text,
        'national_id': nationalIdController.text,
        if (authCubit.cameraImage != null)
          'selfie': await MultipartFile.fromFile(authCubit.cameraImage!.path,
              filename: 'selfie.png'),
        if (authCubit.image != null)
          'police_certificate': await MultipartFile.fromFile(
              authCubit.image!.path,
              filename: 'police_certificate.jpg'),
      });
      final response = await dio.post(
        ApiConstants.baseUrl + 'provider/profile',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      setState(() => isLoading = false);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context).updateDocument + ' Success!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${response.statusMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.document_scanner_rounded,
                            size: 30.sp,
                            color: ColorsManager.blue,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).updateDocument,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorsManager.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Please upload the required documents to reactivate your account",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                // Text fields
                _buildTextField(
                    addressController,
                    AppLocalizations.of(context).address,
                    Icons.location_on_rounded),
                SizedBox(height: 12.h),
                _buildTextField(serviceIdController, 'Service ID',
                    Icons.miscellaneous_services),
                SizedBox(height: 12.h),
                _buildTextField(nationalIdController,
                    AppLocalizations.of(context).nationalId, Icons.credit_card),
                SizedBox(height: 16.h),
                // Document Upload Section
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Police Clearance Certificate
                        LabelTextFormWidget(
                          label: AppLocalizations.of(context)
                              .policeClearanceCertificate,
                          fontSize: 14.sp,
                        ),
                        DefaultElevatedButton(
                          onPressed: () {
                            context.read<AuthCubit>().pickImageFromGallery();
                          },
                          label: AppLocalizations.of(context).pickImage,
                        ),
                        SizedBox(height: 10.h),
                        BlocBuilder<AuthCubit, AuthStates>(
                          buildWhen: (previous, current) =>
                              current is AuthImagePickedState,
                          builder: (context, state) {
                            final image = context.read<AuthCubit>().image;
                            return image != null
                                ? Image.file(image)
                                : Text(AppLocalizations.of(context)
                                    .noImageSelected);
                          },
                        ),
                        SizedBox(height: 16.h),
                        // Selfie Upload
                        LabelTextFormWidget(
                          label: AppLocalizations.of(context).uploadSelfie,
                          fontSize: 14.sp,
                        ),
                        DefaultElevatedButton(
                          onPressed: () {
                            context.read<AuthCubit>().pickImageFromCamera();
                          },
                          label: AppLocalizations.of(context).takeSelfie,
                        ),
                        SizedBox(height: 10.h),
                        BlocBuilder<AuthCubit, AuthStates>(
                          buildWhen: (previous, current) =>
                              current is AuthSelfiePickedState,
                          builder: (context, state) {
                            final image = context.read<AuthCubit>().cameraImage;
                            return image != null
                                ? Image.file(image)
                                : Text(AppLocalizations.of(context)
                                    .noImageSelected);
                          },
                        ),
                        SizedBox(height: 32.h),
                        // Submit Button
                        Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorsManager.blue,
                                ColorsManager.blue.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                            boxShadow: [
                              BoxShadow(
                                color: ColorsManager.blue.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15.r),
                              onTap: isLoading ? null : submitDocuments,
                              child: Center(
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        "Submit Documents",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
