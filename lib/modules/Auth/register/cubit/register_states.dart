abstract class SocialRegisterStates {}

class SocialRegisterInitalStates extends SocialRegisterStates {}

class SocialRegisterLoadingStates extends SocialRegisterStates {}

class SocialRegisterSuccesStates extends SocialRegisterStates {
  final String? uId;

  SocialRegisterSuccesStates(this.uId);
}

class SocialRegisterErrorStates extends SocialRegisterStates {
  final String error;

  SocialRegisterErrorStates(this.error);
}

class SocialCreateUserSuccesStates extends SocialRegisterStates {}

class SocialCreateUserErrorStates extends SocialRegisterStates {
  final String error;

  SocialCreateUserErrorStates(this.error);
}

class SocialRegisterfChangePasswordVisabilityStates
    extends SocialRegisterStates {}

class SocialLayoutGetUserLoadingState extends SocialRegisterStates {}

class SocialLayoutGetUserSucssesState extends SocialRegisterStates {}

class SocialLayoutGetUserErrorState extends SocialRegisterStates {}
