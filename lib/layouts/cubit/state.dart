abstract class SocialLayoutStates {}

class SocialIntialState extends SocialLayoutStates {}

class SocialLayoutChangBottomNavState extends SocialLayoutStates {}

class SocialLayoutGetUserLoadingState extends SocialLayoutStates {}

class SocialLayoutGetUserSucssesState extends SocialLayoutStates {}

class SocialLayoutGetUserErrorState extends SocialLayoutStates {
  final String error;

  SocialLayoutGetUserErrorState(this.error);
}

class SocialNewPostState extends SocialLayoutStates {}

class SocialGetImageProfileSucssesState extends SocialLayoutStates {}

class SocialGetImageProfileErrorState extends SocialLayoutStates {}

class SocialGetCoverProfileSucssesState extends SocialLayoutStates {}

class SocialGetCoverProfileErrorState extends SocialLayoutStates {}

class SocialUploadImageProfileSucssesState extends SocialLayoutStates {}

class SocialUploadImageProfileErrorState extends SocialLayoutStates {}

class SocialUploadCoverProfileSucssesState extends SocialLayoutStates {}

class SocialUploadCoverProfileErrorState extends SocialLayoutStates {}

class SocialUserUpdateErrorState extends SocialLayoutStates {}

class SocialUpdateProfileLoadingState extends SocialLayoutStates {}

class SocialUpdateCoverLoadingState extends SocialLayoutStates {}
