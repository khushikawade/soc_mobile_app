import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/src/html_elements.dart';

class SelectableHTMLWidget extends StatelessWidget {
  SelectableHTMLWidget(
      {Key? key,
      GlobalKey? anchorKey,
      required this.data,
      this.onLinkTap,
      this.onAnchorTap,
      this.customRender = const {},
      this.customImageRenders = const {},
      this.onCssParseError,
      this.onImageError,
      this.onMathError,
      this.shrinkWrap = false,
      this.onImageTap,
      this.tagsList = const [],
      this.style = const {},
      this.navigationDelegateForIframe,
      this.selectionControls})
      : document = null,
        assert(data != null),
        _anchorKey = anchorKey ?? GlobalKey(),
        super(key: key);

  SelectableHTMLWidget.fromDom(
      {Key? key,
      GlobalKey? anchorKey,
      @required this.document,
      this.onLinkTap,
      this.onAnchorTap,
      this.customRender = const {},
      this.customImageRenders = const {},
      this.onCssParseError,
      this.onImageError,
      this.onMathError,
      this.shrinkWrap = false,
      this.onImageTap,
      this.tagsList = const [],
      this.style = const {},
      this.navigationDelegateForIframe,
      this.selectionControls})
      : data = null,
        assert(document != null),
        _anchorKey = anchorKey ?? GlobalKey(),
        super(key: key);

  /// A unique key for this Html widget to ensure uniqueness of anchors
  final GlobalKey _anchorKey;

  /// The HTML data passed to the widget as a String
  final String? data;

  /// The HTML data passed to the widget as a pre-processed [dom.Document]
  final dom.Document? document;

  /// A function that defines what to do when a link is tapped
  final OnTap? onLinkTap;

  /// A function that defines what to do when an anchor link is tapped. When this value is set,
  /// the default anchor behaviour is overwritten.
  final OnTap? onAnchorTap;

  /// An API that allows you to customize the entire process of image rendering.
  /// See the README for more details.
  final Map<ImageSourceMatcher, ImageRender> customImageRenders;

  /// A function that defines what to do when CSS fails to parse
  final OnCssParseError? onCssParseError;

  /// A function that defines what to do when an image errors
  final ImageErrorListener? onImageError;

  /// A function that defines what to do when either <math> or <tex> fails to render
  /// You can return a widget here to override the default error widget.
  final OnMathError? onMathError;

  /// A parameter that should be set when the HTML widget is expected to be
  /// flexible
  final bool shrinkWrap;

  /// A function that defines what to do when an image is tapped
  final OnTap? onImageTap;

  /// A list of HTML tags that defines what elements are not rendered
  final List<String> tagsList;

  /// Either return a custom widget for specific node types or return null to
  /// fallback to the default rendering.
  final Map<String, CustomRender> customRender;

  /// An API that allows you to override the default style for any HTML element
  final Map<String, Style> style;

  /// Decides how to handle a specific navigation request in the WebView of an
  /// Iframe. It's necessary to use the webview_flutter package inside the app
  /// to use NavigationDelegate.
  final NavigationDelegate? navigationDelegateForIframe;

  /// Custom Selection controls allows you to override default toolbar and build custom toolbar
  /// options
  final TextSelectionControls? selectionControls;

  static List<String> get tags => new List<String>.from(STYLED_ELEMENTS)
    ..addAll(INTERACTABLE_ELEMENTS)
    ..addAll(REPLACED_ELEMENTS)
    ..addAll(LAYOUT_ELEMENTS)
    ..addAll(TABLE_CELL_ELEMENTS)
    ..addAll(TABLE_DEFINITION_ELEMENTS);

  @override
  Widget build(BuildContext context) {
    final dom.Document doc =
        data != null ? HtmlParser.parseHTML(data!) : document!;
    // final double? width = shrinkWrap ? null : MediaQuery.of(context).size.width;

    return Container(
      // width: width,
      child: HtmlParser(
        selectionControls: materialTextSelectionControls,
        key: _anchorKey,
        htmlData: doc,
        onLinkTap: onLinkTap,
        onAnchorTap: onAnchorTap,
        onImageTap: onImageTap,
        onCssParseError: onCssParseError,
        onImageError: onImageError,
        onMathError: onMathError,
        shrinkWrap: shrinkWrap,
        selectable: true,
        style: style,
        customRender: customRender,
        imageRenders: {}
          ..addAll(customImageRenders)
          ..addAll(defaultImageRenders),
        tagsList: tagsList.isEmpty ? Html.tags : tagsList,
        navigationDelegateForIframe: navigationDelegateForIframe,
      ),
    );
  }
}
