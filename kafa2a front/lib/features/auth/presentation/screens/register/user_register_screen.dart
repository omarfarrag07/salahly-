import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/config/routes_manager.dart';
import 'package:kafa2a/core/utils/validators.dart';
import 'package:kafa2a/core/widgets/default_submit_button.dart';
import 'package:kafa2a/core/widgets/default_text_form_field.dart';
import 'package:kafa2a/core/widgets/ui_utils.dart';
import 'package:kafa2a/features/auth/data/models/register_user_request.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_states.dart';
import 'package:kafa2a/features/auth/presentation/screens/login/widgets/email_form_field.dart';
import 'package:kafa2a/features/auth/presentation/screens/login/widgets/password_form_field.dart';
import 'package:kafa2a/features/auth/presentation/screens/widgets/label_text_form_widget.dart';
import 'package:kafa2a/features/auth/presentation/screens/widgets/title_widget.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class UserRegisterScreen extends StatelessWidget {
  UserRegisterScreen({super.key});

  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

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
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleWidget(
                            title: AppLocalizations.of(context).register),
                        SizedBox(height: 10.h),
                        LabelTextFormWidget(
                          label: AppLocalizations.of(context).name,
                          fontSize: 14.sp,
                        ),
                        DefaultTextFormField(
                          controller: nameController,
                          hintText: AppLocalizations.of(context).enterYourName,
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
                              Validators.validatePassword(password, context),
                          fontSize: 14.sp,
                        ),
                        SizedBox(height: 10.h),
                        LabelTextFormWidget(
                          label: AppLocalizations.of(context).confirmPassword,
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
                          hintText:
                              AppLocalizations.of(context).enterYourPhoneNumber,
                          validator: (phoneNumber) => Validators.validateNull(
                              phoneNumber,
                              AppLocalizations.of(context).phoneNumberRequired),
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
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  RoutesManager.homeUser,
                                  (route) => false,
                                );
                              }
                            },
                            child: DefaultSubmitButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().registerUser(
                                        RegisterUserRequest(
                                          email: emailController.text,
                                          name: nameController.text,
                                          password: passwordController.text,
                                          confirmPassword:
                                              confirmPasswordController.text,
                                          phone: phoneNumberController.text,
                                        ),
                                      );
                                }
                              },
                              label: AppLocalizations.of(context).register,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).alreadyHaveAnAccount,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLocalizations.of(context).login,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
