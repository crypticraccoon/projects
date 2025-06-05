abstract final class Routes {
  static const login = "/";

  //Registration Routes
  static const register = "/register";
  static const registerProfileSetup = "/setup/:id/:code";

  //Recovery Routes
  static const recover = "/recover";
  static const recoveryUpdate = "/update/:email/:code";

  // Todo
  static const home = "/home";
  static const createTodo = "/create";
  static const updateTodo = "/update";
  static const todo = "/:id";

  // Settings
  static const settings = '/settings';
  static const settingsUpdatePassword = '/password';
  static const settingsUpdateUsername = '/username';
  static const settingsUpdateEmail = '/email';
}
