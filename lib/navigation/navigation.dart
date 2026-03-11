import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart' as nav;

import '../app_router.dart';

final navigationProvider = Provider((ref)=>(Navigator()));

class Navigator {

  Future<T?> navigateUsingPath<T>(
      {required String path, required BuildContext context, Object? params}) {
    path = _createFullPathForExploreSubScreen(path: path);
    return GoRouter.of(context).push(path, extra: params);
  }

  removeAllAndNavigate(
      {required BuildContext context, required String path, Object? params}) {
    path = _createFullPathForExploreSubScreen(path: path);
    GoRouter.of(context).go(path,extra: params);
  }

  removeCurrentAndNavigate(
      {required BuildContext context, required String path, Object? params}) {
    path = _createFullPathForExploreSubScreen(path: path);
    GoRouter.of(context).pushReplacement(path,extra: params);
  }


  removeTopPage({required BuildContext context}){

    GoRouter.of(context).pop();
  }

  void removeDialogWithResult<T>({
    required BuildContext context,
    T? result,
  }) {
    nav.Navigator.pop<T>(context, result);
  }


  removeDialog({required BuildContext context})async{
    nav.Navigator.pop(context);
  }

  removePictureDialog({required BuildContext context}) async {
    nav.Navigator.of(context, rootNavigator: true).pop();
  }

  popUnTill({required BuildContext context,required String path})
  {
    path = _createFullPathForExploreSubScreen(path: path);
    GoRouter.of(context).popUntil(path, context);
  }


  _createFullPathForExploreSubScreen({required String path})
  {
    if(!path.startsWith("/") && exploreSubScreenRoutes.contains(path))
      {
        return "$exploreScreenPath/$path";
      }
    return path;
  }


  removeTopPageAndReturnValue({required BuildContext context,dynamic result}){

    GoRouter.of(context).pop(result);
  }

}

extension GoRouterEx on GoRouter {
  void popUntil(String path,BuildContext context) {
    final router = GoRouter.of(context);
    while (router.canPop() &&
        router.location() != path) {
      pop();
    }
  }
}

extension GoRouterExtension on GoRouter {
  String location() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }
}