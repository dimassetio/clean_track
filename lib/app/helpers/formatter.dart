import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

String dateTimeFormatter(
  DateTime? date, {
  bool useSeparator = false,
  bool useSecond = false,
  String? def,
}) {
  if (date is DateTime) {
    var timeFormat = 'H.m';
    if (useSecond) {
      timeFormat = 'H.m.s';
    }
    if (useSeparator) {
      return DateFormat('d MMM y | $timeFormat').format(date);
    }
    return DateFormat('d MMM y $timeFormat').format(date);
    // return "${DateFormat.yMMMMd('id').format(date)} ${DateFormat.Hm('id').format(date)}";
  } else
    return def ?? '';
}

String dateChartFormatter(DateTime? date, {String? def}) {
  if (date is DateTime) {
    return DateFormat('d/M').format(date);
    // return "${DateFormat.yMMMMd('id').format(date)} ${DateFormat.Hm('id').format(date)}";
  } else
    return def ?? '';
}

String dateFormatter(DateTime? date) {
  if (date is DateTime) {
    return DateFormat('d MMM y').format(date);
  } else
    return '';
}

String timeFormatter(DateTime? date) {
  if (date is DateTime) {
    return DateFormat('H.m').format(date);
  } else
    return '';
}

bool isSameDay(DateTime? date1, DateTime? date2) {
  if (date1 == null || date2 == null) {
    return false;
  }
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String getTimeCategory() {
  int hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) {
    return 'Morning'; // Pagi
  } else if (hour >= 12 && hour < 17) {
    return 'Afternoon'; // Siang
  } else if (hour >= 17 && hour < 20) {
    return 'Evening'; // Sore
  } else {
    return 'Night'; // Malam
  }
}

String decimalFormatter(int? amount, {String? locale, String? symbol}) {
  final format = NumberFormat.decimalPattern("id_ID");
  return format.format(amount ?? 0);
}

int currencyDeformatter(String value) {
  return int.parse(value.replaceAll('Rp', '').replaceAll('.', ''));
}

GeoPoint posToGeo(Position pos) {
  return GeoPoint(pos.latitude, pos.longitude);
}

Position geoToPost(GeoPoint geo) {
  return Position.fromMap({
    'latitude': geo.latitude,
    'longitude': geo.longitude,
  });
}

String writeCoordinate({GeoPoint? geo, Position? position}) {
  var value = position;
  if (geo is GeoPoint) {
    value = geoToPost(geo);
  }
  return "${value?.latitude}, ${value?.longitude}";
}

Future<String> getAddress({GeoPoint? geo, Position? position}) async {
  var value = position;
  if (geo is GeoPoint) {
    value = geoToPost(geo);
  }
  if (value is Position) {
    var places = await placemarkFromCoordinates(
      value.latitude,
      value.longitude,
    );
    if (places.isNotEmpty) {
      var place = places.first;
      return "${place.name}, ${place.street}, ${place.subLocality}, ${place.locality}";
    }
    return '';
  }
  return '';
}

class CurrrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    int value = int.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(
      locale: "ID",
      decimalDigits: 0,
    );

    String newText = formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: new TextSelection.collapsed(offset: newText.length),
    );
  }
}
