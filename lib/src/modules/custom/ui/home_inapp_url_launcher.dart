import 'dart:async';
import 'dart:io';
import 'package:Soc/src/globals.dart';
import 'package:Soc/src/modules/home/bloc/home_bloc.dart';
import 'package:Soc/src/modules/home/models/app_setting.dart';
import 'package:Soc/src/styles/theme.dart';
import 'package:Soc/src/widgets/empty_container_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:Soc/src/widgets/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class HomeInAppUrlLauncher extends StatefulWidget {
  final bool? isiFrame;
  final String url;

  final String? language;
  @override
  HomeInAppUrlLauncher(
      {Key? key, required this.url, required this.language, this.isiFrame})
      : super(key: key);
  _HomeInAppUrlLauncherState createState() => new _HomeInAppUrlLauncherState();
}

class _HomeInAppUrlLauncherState extends State<HomeInAppUrlLauncher> {
  bool? iserrorstate = false;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  HomeBloc _homeBloc = HomeBloc();
  String? checkUrlChange;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkUrlChange = widget.url;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
          edgeOffset: MediaQuery.of(context).size.height * 0.6,
          key: refreshKey,
          child: OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                final bool connected = connectivity != ConnectivityResult.none;
                if (connected) {
                  if (iserrorstate == true) {
                    iserrorstate = false;
                  }
                } else if (!connected) {
                  iserrorstate = true;
                }

                return connected
                    ? ListView(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                            Container(
                                height: MediaQuery.of(context).size.height,
                                // width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  children: [
                                    WebView(
                                      onProgress: (progress) {
                                        if (progress >= 50) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      },
                                      gestureRecognizers: Set()
                                        ..add(Factory<
                                                VerticalDragGestureRecognizer>(
                                            () =>
                                                VerticalDragGestureRecognizer()
                                                  ..onDown = (DragDownDetails
                                                      dragDownDetails) {
                                                    Globals.webViewController1!
                                                        .getScrollY()
                                                        .then((value) {
                                                      if (value == 0 &&
                                                          dragDownDetails
                                                                  .globalPosition
                                                                  .direction <
                                                              1) {
                                                        refreshPage();
                                                      }
                                                    });
                                                  })),
                                      gestureNavigationEnabled:
                                          widget.isiFrame == true
                                              ? true
                                              : false,
                                      initialUrl: widget.isiFrame == true
                                          ? Uri.dataFromString(widget.url,
                                                  mimeType: 'text/html')
                                              .toString()
                                          : widget.url,
                                      javascriptMode:
                                          JavascriptMode.unrestricted,
                                      onWebViewCreated: (WebViewController
                                          webViewController) {
                                        _controller.complete(webViewController);
                                        Globals.webViewController1 =
                                            webViewController;
                                      },
                                    ),
                                    isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryVariant,
                                            ),
                                          )
                                        : Stack(),
                                  ],
                                )),
                            Container(
                              height: 0,
                              width: 0,
                              child: BlocListener<HomeBloc, HomeState>(
                                  bloc: _homeBloc,
                                  listener: (context, state) async {
                                    if (state is BottomNavigationBarSuccess) {
                                      AppTheme.setDynamicTheme(
                                          Globals.appSetting, context);
                                      Globals.appSetting =
                                          AppSetting.fromJson(state.obj);
                                      setState(() {});
                                    }
                                  },
                                  child: EmptyContainer()),
                            ),
                          ])
                    : NoInternetErrorWidget(
                        connected: connected, issplashscreen: false);
              },
              child: Container()),
          onRefresh: refreshPage),
    );
  }

  Future refreshPage() async {
    await Future.delayed(Duration(seconds: 2));
    refreshKey.currentState?.show(atTop: false);
    _homeBloc.add(FetchStandardNavigationBar());
    Globals.webViewController1!.reload();
    if (checkUrlChange == widget.url) {
      Globals.webViewController1!.reload();
      checkUrlChange = widget.url;
    } else {
      Globals.webViewController1!.loadUrl(widget.url);
      checkUrlChange = widget.url;
    }
  }
}
