import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexprime/screens/vendor_screens/vendor_customer_info/widget/vendor_customer_info_text_row.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz;

import '../../../../models/vendor_order_model.dart';

class VendorCustomerInfoDetails extends StatelessWidget {
  final VendorOrderModel orderModel;
  const VendorCustomerInfoDetails({
    super.key,
    required this.orderModel
  });

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    final utcTime = DateTime.parse(orderModel.order!.createdAt.toString()).toUtc();
    final japan = tz.getLocation('Asia/Tokyo');
    final jstTime = tz.TZDateTime.from(utcTime, japan);

    return SliverToBoxAdapter(
      child: Column(
        children: [
          VendorCustomerInfoTextRow(
            title: 'Name: ',
            subTitle: '${orderModel.order?.user?.fullname}',
            titleBold: true,
          ),
          VendorCustomerInfoTextRow(title: 'Postcode: ', subTitle: '${orderModel.order?.deliveryAddress?.postcode}'),
          VendorCustomerInfoTextRow(
            title: 'Full Address: ',
            subTitle: '${orderModel.order?.deliveryAddress?.fullAddress}',
          ),
          VendorCustomerInfoTextRow(
            title: 'Building name/Room number: ',
            subTitle: '${orderModel.order?.deliveryAddress?.buildingNameRoomNumber}',
          ),
          VendorCustomerInfoTextRow(
            title: 'Phone number: ',
            subTitle: '${orderModel.order?.deliveryAddress?.phoneNumber}',
          ),
          VendorCustomerInfoTextRow(
            title: 'Date and time: ',
            subTitle: DateFormat('dd MMM yyyy, hh:mm a').format(jstTime),
          ),
        ],
      ),
    );
  }
}