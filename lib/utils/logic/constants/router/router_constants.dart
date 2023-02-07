/*
If the route contains slashes, then it is treated as a "deep link",
and before this route is pushed, the routes leading to this one are pushed also.
For example, if the route was /a/b/c, then the app would start with
the three routes /a, /a/b, and /a/b/c loaded, in that order.
 */

class RouterConstants {
  static const notFound = "404";
  static const home = "home";
  static const tattooChoose = "tattooChoose";
  static const signUpIn = "signUpIn";
  static const photo = "photo";
  static const retouch = "retouch";
  static const more = "more";
  static const credits = "credits";
  static const privacyPolicy = "privacyPolicy";
  static const termOfUse = "termOfUse";
}
