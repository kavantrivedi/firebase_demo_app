class StringManager {
  const StringManager._();

  // General
  static String get areYouSureYouWantToLogout =>
      'Are you sure you want to log out?';
  static String get logout => 'Logout';
  static String get cancel => 'Cancel';

  // Authentication
  static String get email => "Email";
  static String get password => "Password";
  static String get dontHaveAnAccout => "Don't have an account? sign-up here";
  static String get welcomeback => "Welcome back!!";
  static String get plzEnsureTheEmailEnteredIsValid =>
      'Please ensure the email entered is valid';
  static String get validEmailMessage => "Please enter valid email.";
  static String get validPasswordMessage => "Please enter valid password.";
  static String get validNameMessage => "Please enter valid name.";
  static String get fillDetailsCorrectly =>
      "Please fill details correctly to continue.";

  // Group
  static String get createGroup => 'Create Group';
  static String get enterGroupName => 'Enter Group Name';
  static String get selectMinUsersTitle =>
      'Select minimum 2 users to create group';
  static String get groupNameValidationMessage =>
      "Please make sure, group name is at-lease 3 char long.";
  static String get groupSelectedUsersListValidationMessage =>
      "Please make sure, at-least 2 users are selected to create group.";
}
