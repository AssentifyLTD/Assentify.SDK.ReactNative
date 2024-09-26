import {
  StackActions,
  CommonActions,
  type NavigationContainerRef,
} from '@react-navigation/native';

let _navigator: NavigationContainerRef<any>;
let currentRoute = 'Profile';

function setTopLevelNavigator(navigatorRef?: NavigationContainerRef<any>) {
  _navigator = navigatorRef!;
}

function navigate(routeName: string, params?: any) {
  _navigator.navigate(routeName, params);
}

function replace(routeName: string, params?: any) {
  _navigator.dispatch(StackActions.replace(routeName, params));
}

function push(routeName: string, params?: any) {
  _navigator.dispatch(StackActions.push(routeName, params));
}

function pop(number = 1) {
  _navigator.dispatch(StackActions.pop(number));
}

function popToTop() {
  _navigator.dispatch(StackActions.popToTop());
}

function goBack() {
  _navigator.goBack();
}

function canGoBack() {
  return _navigator.canGoBack();
}

function getNavigator() {
  return _navigator;
}

function reset(routeName: string) {
  // _navigator.dispatch(
  //   StackActions.reset({
  //     index: 0,
  //     actions: [NavigationActions.navigate({ routeName })],
  //   }),
  // );

  const resetAction = CommonActions.reset({
    index: 0,
    routes: [{ name: routeName }],
  });
  _navigator.dispatch(resetAction);
}

function setCurrentRoute(route: string) {
  currentRoute = route;
}

function getCurrentRoute() {
  return currentRoute;
  // let route = _navigator.state.nav;
  // while (route.routes) {
  //   route = route.routes[route.index];
  // }
  // return route.routeName;
}

// add other navigation functions that you need and export them

export default {
  replace,
  push,
  pop,
  setTopLevelNavigator,
  setCurrentRoute,
  getCurrentRoute,
  getNavigator,
  navigate,
  reset,
  popToTop,
  goBack,
  canGoBack,
};
