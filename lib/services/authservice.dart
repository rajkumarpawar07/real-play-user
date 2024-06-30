import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String formatPhoneNumber(String phoneNumber, String countryCode) {
    // Remove any non-digit characters from the phone number
    String sanitizedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // If the sanitized phone number does not start with the country code, prepend it
    if (!sanitizedPhoneNumber.startsWith(countryCode)) {
      sanitizedPhoneNumber = countryCode + sanitizedPhoneNumber;
    }

    return sanitizedPhoneNumber;
  }
  // Function to sign up with phone number
  Future<void> signUpWithPhoneNumber(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: formatPhoneNumber('8770684866','+91'), // Use the parameter value
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          // Handle sign-in success if auto-verification is successful
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification Failed: $e");
          // Handle verification failure
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to OTP screen with verificationId
          // verificationId can be used to manually verify the code
          // resendToken can be used to resend the code
          print("Code Sent: $verificationId");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle code auto-retrieval timeout
          print("Timeout: $verificationId");
        },
        timeout: Duration(seconds: 60),
      );
    } catch (e) {
      print("Error: $e");
      // Handle other errors
    }
  }

  // Function to manually verify the OTP code
  Future<void> verifyOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);
      // Handle sign-in success
    } catch (e) {
      print("Error verifying OTP: $e");
      // Handle verification failure
    }
  }
}
