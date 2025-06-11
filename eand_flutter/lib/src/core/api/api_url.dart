class ApiUrl {
  const ApiUrl._();

  static const baseUrl = "https://api.github.com/users/mralexgray/repos";

  static String getUserReposUrl(String username) {
    return "https://api.github.com/users/$username/repos";
  }
}
