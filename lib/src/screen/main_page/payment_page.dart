import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:svg_icon/svg_icon.dart';
import 'package:wayapay/src/models/bottom_nav_model.dart';
import 'package:wayapay/src/models/charge.dart';
import 'package:wayapay/src/provider/transaction_provider.dart';
import 'package:wayapay/src/res/text.dart';
import 'package:wayapay/src/screen/checkout/pay_attitude/pay_attitude.dart';
import 'package:wayapay/src/screen/checkout/ussd/ussd.dart';
import 'package:wayapay/src/screen/main_page/footer.dart';
import 'package:wayapay/src/screen/main_page/top.dart';
import 'package:wayapay/src/widget/appbar.dart';
import 'package:wayapay/src/widget/bottom_nav.dart';

import '../checkout/card/card.dart';

class PaymentPage extends StatefulWidget {
  final Charge charge;
  const PaymentPage({Key? key, required this.charge}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var method = [
    BottomNavModel(name: "Card", icon: Icons.credit_card, body: const CardMethod()),
    BottomNavModel(name: "USSD",  icon: Icons.perm_phone_msg_rounded, body: const UssdCheckout()),
    BottomNavModel(name: "Account",  icon: Icons.account_balance_wallet, body: const PayAttitude()),
    BottomNavModel(name: "Pay Attitude", icon: Icons.phone_enabled_rounded, body:const PayAttitude())
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
     floatingActionButton: FloatingActionButton(
       onPressed: (){
         var model = context.read<TransactionProvider>();
         model.startTransaction();
       },
     ),
        appBar: appBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25,),
              const CheckoutTop(),
              method[currentIndex].body,
             const SizedBox(height: 30,),
              Text("Select preferred payment method",style: AppTextTheme.large,),
              const SizedBox(height: 30,),
              CustomBottomNav(
                  items: method,
                  onTap: (e){
                   setState(() {
                     currentIndex=e;
                   });
                  },
                  currentIndex: currentIndex),
              const SizedBox(height: 30,),
             const CheckoutFooter(),
              const SizedBox(height: 30,),
            ],
          ),
        ),

      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 100),
        (){
          startTransaction();
        }
    );
  }

  void startTransaction() {
    var model = context.read<TransactionProvider>();
    model.startTransaction();
    model.getBanks();
  }
}