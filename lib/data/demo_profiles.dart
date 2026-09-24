import '../models/user_profile.dart';

const demoProfile = UserProfile(
  fullName: 'Alejandra Vela',
  username: 'Alejandra.vela',
  email: 'avela@gmail.com',
  welcomeMessage: 'Bienvenida',
  paymentMethod: PaymentMethod(
    cardType: PaymentCardType.credit,
    brand: 'Visa',
    lastFourDigits: '9318',
  ),
);

const incompleteDemoProfile = UserProfile(fullName: 'Juan Pérez');

const longTextDemoProfile = UserProfile(
  fullName: 'María Fernanda de los Ángeles Rodríguez Castañeda',
  username: 'mariafernanda.rodriguez.castaneda',
  email: 'mariafernanda.rodriguez.castaneda@correo-empresarial.com.co',
  welcomeMessage: 'Bienvenida',
  paymentMethod: PaymentMethod(
    cardType: PaymentCardType.debit,
    brand: 'Mastercard Débito Empresarial',
    lastFourDigits: '0042',
  ),
);
