import 'package:flutter/material.dart';
import 'package:naylors_client/models/models.dart';

class CardStrings {
  static const String fieldReq = 'This field is required';
  static const String numberIsInvalid = 'Card is invalid';
}

class CardUtils {
  static Widget getCardIcon(CardType cardType) {
    String img = "";
    Icon icon;
    switch (cardType) {
      case CardType.MasterCard:
        img = 'mastercard.png';
        break;
      case CardType.Visa:
        img = 'visa.png';
        break;
      case CardType.Discover:
        img = 'discover.png';
        break;
      case CardType.AmericanExpress:
        img = 'american_express.png';
        break;
      case CardType.Others:
        icon = new Icon(
          Icons.credit_card,
          size: 40.0,
          color: Colors.grey[600],
        );
        break;
      case CardType.Invalid:
        icon = new Icon(
          Icons.warning,
          size: 40.0,
          color: Colors.red[600],
        );
        break;
    }

    Widget widget;
    if (img.isNotEmpty) {
      widget = new Image.asset(
        'assets/$img',
        width: 40.0,
      );
    } else {
      widget = icon;
    }
    return widget;
  }

  static CardType getCardType(String input) {
    CardType cardType;
    if (input.startsWith(new RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      cardType = CardType.MasterCard;
    } else if (input.startsWith(new RegExp(r'[4]'))) {
      cardType = CardType.Visa;
    } else if (input.startsWith(new RegExp(r'((34)|(37))'))) {
      cardType = CardType.AmericanExpress;
    } else if (input.startsWith(new RegExp(r'((6[45])|(6011))'))) {
      cardType = CardType.Discover;
    } else if (input.length <= 8) {
      cardType = CardType.Others;
    } else {
      cardType = CardType.Invalid;
    }
    return cardType;
  }

  static String getCleanedNumber(String text) {
    RegExp regExp = new RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static String validateCardNumber(String input) {
    if (input.isEmpty) {
      return CardStrings.fieldReq;
    }

    input = getCleanedNumber(input);

    if (input.length < 8) {
      return CardStrings.numberIsInvalid;
    }

    int sum = 0;
    int length = input.length;
    for (var i = 0; i < length; i++) {
      int digit = int.parse(input[length - i - 1]);

      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return null;
    }

    return CardStrings.numberIsInvalid;
  }

  static List<int> getExpiryDate(String value) {
    var split = value.split(new RegExp(r'(\/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  static String validateDate(String value) {
    if (value.isEmpty) {
      return CardStrings.fieldReq;
    }

    int year;
    int month;

    if (value.contains(new RegExp(r'(\/)'))) {
      var split = value.split(new RegExp(r'(\/)'));
      month = int.parse(split[0]);
      year = int.parse(split[1]);
    } else {
      month = int.parse(value.substring(0, (value.length)));
      year = -1;
    }

    if ((month < 1) || (month > 12)) {
      return 'Expiry month is invalid';
    }

    if ((year < 1) || (year > 2099)) {
      return 'Expiry year is invalid';
    }

    if (!hasDateExpired(month, year)) {
      return 'Date given has expired';
    }
    return null;
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool hasDateExpired(int month, int year) {
    return !(month == null || year == null) && isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();

    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    return fourDigitsYear < now.year;
  }
}
