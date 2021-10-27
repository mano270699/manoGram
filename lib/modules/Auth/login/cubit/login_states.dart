abstract class SocialLoginStates {}

class SocialLoginInitalStates extends SocialLoginStates {}

class SocialLoginLoadingStates extends SocialLoginStates {}

class SocialLoginSuccesStates extends SocialLoginStates {
  final String? uId;

  SocialLoginSuccesStates(this.uId);
}

class SocialLoginErrorStates extends SocialLoginStates {
  final String error;

  SocialLoginErrorStates(this.error);
}

class SocialChangePasswordVisabilityStates extends SocialLoginStates {}
