import 'package:flutter/material.dart';
import 'package:nexprime/screens/vendor_screens/vendor_customer_info/widget/vendor_customer_info_text_row.dart';

class VendorCustomerInfoDetails extends StatelessWidget {
  const VendorCustomerInfoDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          VendorCustomerInfoTextRow(
            title: 'Name: ',
            subTitle: 'Alexa Schmidt',
            titleBold: true,
          ),
          VendorCustomerInfoTextRow(title: 'Postcode: ', subTitle: '10117'),
          VendorCustomerInfoTextRow(
            title: 'Full Address: ',
            subTitle: 'Friedrichstraße 100, Berlin',
          ),
          VendorCustomerInfoTextRow(
            title: 'Building name/Room number: ',
            subTitle: 'Apartment 4B',
          ),
          VendorCustomerInfoTextRow(
            title: 'Phone number: ',
            subTitle: '+49 30 12345678',
          ),
        ],
      ),
    );
  }
}