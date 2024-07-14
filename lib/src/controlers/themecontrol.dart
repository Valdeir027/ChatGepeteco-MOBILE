class IsdarkTheme {

  static final IsdarkTheme _instance = IsdarkTheme._internal();
  IsdarkTheme._internal();
  factory IsdarkTheme() {
    return _instance;
  }
  static bool isDark = false;
  static void toggleTheme() {
    isDark = !isDark;
  }
}
