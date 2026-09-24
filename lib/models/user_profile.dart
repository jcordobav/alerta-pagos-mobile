enum PaymentCardType { credit, debit }

class PaymentMethod {
  const PaymentMethod({
    required this.cardType,
    required this.brand,
    required this.lastFourDigits,
  });

  final PaymentCardType cardType;
  final String brand;
  final String lastFourDigits;

  String get title => switch (cardType) {
    PaymentCardType.credit => 'Tarjeta de crédito',
    PaymentCardType.debit => 'Tarjeta de débito',
  };

  /// Número enmascarado, por ejemplo `Visa •••• 9318`.
  String get maskedNumber => '$brand •••• $lastFourDigits';
}

class UserProfile {
  const UserProfile({
    required this.fullName,
    this.username,
    this.email,
    this.welcomeMessage,
    this.paymentMethod,
  });

  final String fullName;

  /// Nombre de usuario sin `@`.
  final String? username;
  final String? email;
  final String? welcomeMessage;
  final PaymentMethod? paymentMethod;

  String? get usernameLabel => username == null ? null : '@$username';
}
