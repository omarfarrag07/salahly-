import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/config/routes_manager.dart';
import 'package:kafa2a/core/widgets/ui_utils.dart';
import 'package:kafa2a/features/payment/data/models/payment_request.dart';
import 'package:kafa2a/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:kafa2a/features/payment/presentation/cubit/payment_states.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_requests/all_requests.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'cash'; // 'credit' or 'cash'
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cashAmountController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    nameController.dispose();
    cashAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AllRequests request =
        ModalRoute.of(context)!.settings.arguments as AllRequests;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Method Selection
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorsManager.blue,
              ),
            ),
            const SizedBox(height: 16),

            // Cash/Credit Toggle (now with cash on left, credit on right)
            Row(
              children: [
                Expanded(
                  child: PaymentMethodButton(
                    icon: Icons.money,
                    label: 'Cash',
                    isSelected: selectedPaymentMethod == 'cash',
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = 'cash';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PaymentMethodButton(
                    icon: Icons.credit_card,
                    label: 'Credit Card',
                    isSelected: selectedPaymentMethod == 'credit',
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = 'credit';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Payment Form (only shown for credit card)
            if (selectedPaymentMethod == 'credit') ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManager.blue.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: cardNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Card Number',
                        prefixIcon:
                            Icon(Icons.credit_card, color: ColorsManager.blue),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorsManager.blue),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: expiryController,
                            decoration: const InputDecoration(
                              labelText: 'Expiry Date',
                              prefixIcon: Icon(Icons.calendar_today,
                                  color: ColorsManager.blue),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsManager.blue),
                              ),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: cvvController,
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                              prefixIcon:
                                  Icon(Icons.lock, color: ColorsManager.blue),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsManager.blue),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Cardholder Name',
                        prefixIcon:
                            Icon(Icons.person, color: ColorsManager.blue),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorsManager.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Cash payment container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManager.blue.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.money,
                        size: 50, color: ColorsManager.blue),
                    const SizedBox(height: 16),
                    const Text(
                      'Pay with Cash',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Cash amount input field
                    TextField(
                      controller: cashAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Amount',
                        prefixIcon:
                            Icon(Icons.attach_money, color: ColorsManager.blue),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorsManager.blue),
                        ),
                        hintText: '0.00',
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please pay this amount in cash to the provider',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Pay Now Button
            SizedBox(
              width: double.infinity,
              child: BlocListener<PaymentCubit, PaymentStates>(
                listener: (context, state) {
                  if (state is PaymentLoadingState) {
                    UIUtils.showLoading(context);
                  } else if (state is PaymentErrorState) {
                    UIUtils.hideLoading(context);
                    UIUtils.showMessage(state.error);
                  } else if (state is PaymentSuccessState) {
                    UIUtils.hideLoading(context);
                    Navigator.pushNamed(context, RoutesManager.reviewProvider,
                        arguments: request);
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
                  onPressed: () {
                    // Handle payment submission
                    if (selectedPaymentMethod == 'credit') {
                      // Validate credit card details
                      if (cardNumberController.text.isEmpty ||
                          expiryController.text.isEmpty ||
                          cvvController.text.isEmpty ||
                          nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all card details'),
                          ),
                        );
                        return;
                      }
                    } else {
                      // Validate cash amount
                      if (cashAmountController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter the cash amount'),
                          ),
                        );
                        return;
                      } else {
                        context.read<PaymentCubit>().payProvider(PaymentRequest(
                            amount: int.parse(cashAmountController.text),
                            gateway: "cash",
                            serviceRequestId: request.id,
                            userId: request.userId));
                      }
                    }

                    // Process payment
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          selectedPaymentMethod == 'credit'
                              ? 'Processing credit card payment...'
                              : 'Cash payment of ${cashAmountController.text} confirmed',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'CONFIRM PAYMENT',
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

class PaymentMethodButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ColorsManager.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected ? ColorsManager.blue : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? ColorsManager.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
