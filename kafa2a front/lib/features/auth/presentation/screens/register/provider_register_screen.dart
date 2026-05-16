import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/config/routes_manager.dart';
import 'package:kafa2a/core/screens/pick_location_screen.dart';
import 'package:kafa2a/core/utils/validators.dart';
import 'package:kafa2a/core/widgets/default_elevated_button.dart';
import 'package:kafa2a/core/widgets/default_submit_button.dart';
import 'package:kafa2a/core/widgets/default_text_form_field.dart';
import 'package:kafa2a/core/widgets/loading_indicator.dart';
import 'package:kafa2a/core/widgets/ui_utils.dart';
import 'package:kafa2a/features/auth/data/models/register_provider_request.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_states.dart';
import 'package:kafa2a/features/auth/presentation/screens/login/widgets/email_form_field.dart';
import 'package:kafa2a/features/auth/presentation/screens/login/widgets/password_form_field.dart';
import 'package:kafa2a/features/auth/presentation/screens/widgets/label_text_form_widget.dart';
import 'package:kafa2a/features/auth/presentation/screens/widgets/title_widget.dart';
import 'package:kafa2a/features/home/user/domain/entities/category.dart';
import 'package:kafa2a/features/home/user/presentation/cubit/request_service/request_service_cubit.dart';
import 'package:kafa2a/features/home/user/presentation/cubit/request_service/request_service_states.dart';
import 'package:kafa2a/features/home/user/presentation/screens/widgets/categories_drop_down_widget.dart';
import 'package:kafa2a/features/home/user/presentation/screens/widgets/services_drop_down_widget.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class ProviderRegisterScreen extends StatefulWidget {
  const ProviderRegisterScreen({super.key});

  @override
  State<ProviderRegisterScreen> createState() => _ProviderRegisterScreenState();
}

class _ProviderRegisterScreenState extends State<ProviderRegisterScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  String? userLocationName;
  LatLng? selectedLatLng;
  Category? selectedCategory;
  int? selectedService;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nationalIdController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                shadowColor: ColorsManager.blue
                    .withAlpha((0.25 * 255).toInt()), // Fix deprecation
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: BlocBuilder<RequestServiceCubit, RequestServiceStates>(
                    builder: (context, state) {
                      if (state is GetCategoriesSuccessState) {
                        return Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleWidget(
                                title: AppLocalizations.of(context).register,
                              ),
                              SizedBox(height: 10.h),
                              LabelTextFormWidget(
                                label: AppLocalizations.of(context).name,
                                fontSize: 14.sp,
                              ),
                              DefaultTextFormField(
                                controller: nameController,
                                hintText:
                                    AppLocalizations.of(context).enterYourName,
                                validator: (name) => Validators.validateNull(
                                  name,
                                  AppLocalizations.of(context).nameRequired,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              LabelTextFormWidget(
                                label: AppLocalizations.of(context).email,
                                fontSize: 14.sp,
                              ),
                              EmailFormField(
                                controller: emailController,
                                fontSize: 14.sp,
                              ),
                              SizedBox(height: 10.h),
                              LabelTextFormWidget(
                                label: AppLocalizations.of(context).password,
                                fontSize: 14.sp,
                              ),
                              PasswordFormField(
                                controller: passwordController,
                                validator: (password) =>
                                    Validators.validatePassword(
                                        password, context),
                                fontSize: 14.sp,
                              ),
                              SizedBox(height: 10.h),
                              LabelTextFormWidget(
                                label: AppLocalizations.of(context)
                                    .confirmPassword,
                                fontSize: 14.sp,
                              ),
                              PasswordFormField(
                                controller: confirmPasswordController,
                                validator: (confirmPassword) =>
                                    Validators.validateConfirmationPasswords(
                                        passwordController.text,
                                        confirmPassword,
                                        context),
                                fontSize: 14.sp,
                              ),
                              SizedBox(height: 10.h),
                              LabelTextFormWidget(
                                label: AppLocalizations.of(context).phoneNumber,
                                fontSize: 14.sp,
                              ),
                              DefaultTextFormField(
                                controller: phoneNumberController,
                                hintText: AppLocalizations.of(context)
                                    .enterYourPhoneNumber,
                                validator: (phoneNumber) =>
                                    Validators.validateNull(
                                        phoneNumber,
                                        AppLocalizations.of(context)
                                            .phoneNumberRequired),
                              ),
                              SizedBox(height: 10.h),
                              LabelTextFormWidget(
                                label: AppLocalizations.of(context).nationalId,
                                fontSize: 14.sp,
                              ),
                              DefaultTextFormField(
                                controller: nationalIdController,
                                hintText: AppLocalizations.of(context)
                                    .enterYourNationalId,
                                validator: (nationalId) =>
                                    Validators.validateNull(
                                        nationalId,
                                        AppLocalizations.of(context)
                                            .nationalIdRequired),
                              ),
                              SizedBox(height: 10.h),
                              CategoriesDropDownWidget(
                                label: AppLocalizations.of(context).category,
                                hint:
                                    AppLocalizations.of(context).selectCategory,
                                categories: state.categories,
                                onChanged: (value) {
                                  selectedCategory = value;
                                  setState(() {});
                                },
                              ),
                              ServicesDropDownWidget(
                                label: AppLocalizations.of(context).services,
                                hint:
                                    AppLocalizations.of(context).selectService,
                                services: selectedCategory?.services,
                                onChanged: (value) {
                                  selectedService = value.id;
                                },
                              ),
                              SizedBox(height: 10.h),
                              LabelTextFormWidget(
                                label: AppLocalizations.of(context).address,
                                fontSize: 14.sp,
                              ),
                              DefaultTextFormField(
                                controller: addressController,
                                hintText: AppLocalizations.of(context)
                                    .enterYourAddress,
                                validator: (address) => Validators.validateNull(
                                    address,
                                    AppLocalizations.of(context)
                                        .addressRequired),
                              ),
                              SizedBox(height: 10.h),
                              BlocBuilder<AuthCubit, AuthStates>(
                                buildWhen: (previous, current) =>
                                    current is LocationNameSuccessState,
                                builder: (context, state) {
                                  String locationName =
                                      AppLocalizations.of(context)
                                          .pickYourLocation;
                                  if (state is LocationNameSuccessState) {
                                    locationName = state.locationName;
                                  }
                                  return DefaultElevatedButton(
                                    onPressed: () async {
                                      await context
                                          .read<AuthCubit>()
                                          .getLocation();
                                      if (context.mounted) {
                                        final pickedLatLng =
                                            await Navigator.push<LatLng>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PickLocationScreen(),
                                          ),
                                        );
                                        if (pickedLatLng != null &&
                                            context.mounted) {
                                          selectedLatLng = pickedLatLng;
                                        }
                                      }
                                    },
                                    label: locationName,
                                  );
                                },
                              ),
                              SizedBox(height: 10.h),
                              LabelTextFormWidget(
                                label: AppLocalizations.of(context)
                                    .policeClearanceCertificate,
                                fontSize: 14.sp,
                              ),
                              DefaultElevatedButton(
                                onPressed: () {
                                  context
                                      .read<AuthCubit>()
                                      .pickImageFromGallery();
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
                              SizedBox(height: 10.h),
                              LabelTextFormWidget(
                                label:
                                    AppLocalizations.of(context).uploadSelfie,
                                fontSize: 14.sp,
                              ),
                              DefaultElevatedButton(
                                onPressed: () {
                                  context
                                      .read<AuthCubit>()
                                      .pickImageFromCamera();
                                },
                                label: AppLocalizations.of(context).takeSelfie,
                              ),
                              SizedBox(height: 10.h),
                              BlocBuilder<AuthCubit, AuthStates>(
                                buildWhen: (previous, current) =>
                                    current is AuthSelfiePickedState,
                                builder: (context, state) {
                                  final image =
                                      context.read<AuthCubit>().cameraImage;
                                  return image != null
                                      ? Image.file(image)
                                      : Text(AppLocalizations.of(context)
                                          .noImageSelected);
                                },
                              ),
                              SizedBox(height: 20.h),
                              Center(
                                child: BlocListener<AuthCubit, AuthStates>(
                                  listener: (context, state) {
                                    if (state is AuthLoadingState) {
                                      UIUtils.showLoading(context);
                                    } else if (state is AuthErrorState) {
                                      UIUtils.hideLoading(context);
                                      UIUtils.showMessage(state.error);
                                    } else if (state is AuthSuccessState) {
                                      UIUtils.hideLoading(context);
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        RoutesManager.homeProvider,
                                        (route) => false,
                                      );
                                    }
                                  },
                                  child: DefaultSubmitButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate() &&
                                          context.read<AuthCubit>().image !=
                                              null &&
                                          context
                                                  .read<AuthCubit>()
                                                  .cameraImage !=
                                              null &&
                                          context
                                                  .read<AuthCubit>()
                                                  .currentLocation !=
                                              null &&
                                          selectedService != null) {
                                        context
                                            .read<AuthCubit>()
                                            .registerProvider(
                                              RegisterProviderRequest(
                                                name: nameController.text,
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                                confirmPassword:
                                                    confirmPasswordController
                                                        .text,
                                                phone:
                                                    phoneNumberController.text,
                                                nationalId:
                                                    nationalIdController.text,
                                                address: addressController.text,
                                                serviceId: selectedService!,
                                                policeCertificate: context
                                                    .read<AuthCubit>()
                                                    .image!,
                                                selfie: context
                                                    .read<AuthCubit>()
                                                    .cameraImage!,
                                                lat: selectedLatLng!.latitude,
                                                lng: selectedLatLng!.longitude,
                                              ),
                                            );
                                      }
                                    },
                                    label:
                                        AppLocalizations.of(context).register,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is GetCategoriesLoadingState) {
                        return LoadingIndicator();
                      } else if (state is GetCategoriesErrorState) {
                        return Center(child: Text(state.error));
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).alreadyHaveAnAccount,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLocalizations.of(context).login,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
