import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ctrl_glitch_logo.dart';

enum CustomAppBarVariant {
  standard,
  withBack,
  withClose,
  minimal,
  withSearch,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final CustomAppBarVariant variant;
  final Color? vibeColor;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onLeadingPressed;
  final ValueChanged<String>? onSearchChanged;
  final String searchHint;
  final bool showSearchInitially;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.variant = CustomAppBarVariant.standard,
    this.vibeColor,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.onLeadingPressed,
    this.onSearchChanged,
    this.searchHint = 'Search...',
    this.showSearchInitially = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final bg = backgroundColor ??
        (variant == CustomAppBarVariant.minimal
            ? Colors.transparent
            : scheme.surface);

    final fg = foregroundColor ?? scheme.onSurface;
    final vibe = vibeColor ?? scheme.primary;

    return AppBar(
      backgroundColor: bg,
      foregroundColor: fg,
      centerTitle: centerTitle,
      elevation: elevation,
      leading: _buildLeading(context, fg),
      title: _buildTitle(context, fg, vibe),
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: theme.brightness,
        statusBarIconBrightness:
            theme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, Color fg) {
    if (leading != null) return leading;

    switch (variant) {
      case CustomAppBarVariant.withBack:
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          color: fg,
          onPressed: () {
            HapticFeedback.lightImpact();
            (onLeadingPressed ?? () => Navigator.pop(context))();
          },
        );

      case CustomAppBarVariant.withClose:
        return IconButton(
          icon: const Icon(Icons.close),
          color: fg,
          onPressed: () {
            HapticFeedback.lightImpact();
            (onLeadingPressed ?? () => Navigator.pop(context))();
          },
        );

      default:
        return null;
    }
  }

  Widget? _buildTitle(BuildContext context, Color fg, Color vibe) {
    if (titleWidget != null) return titleWidget;
    if (title == null) return null;

    if (variant == CustomAppBarVariant.withSearch) {
      return _SearchField(
        hint: searchHint,
        onChanged: onSearchChanged,
        showInitially: showSearchInitially,
        color: fg,
      );
    }

    if (title == 'CTRL') {
      return CtrlGlitchLogo(fontSize: 22);
    }

    return Text(
      title!,
      style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
            color: fg,
          ),
    );
  }
}

class _SearchField extends StatefulWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final bool showInitially;
  final Color color;

  const _SearchField({
    required this.hint,
    required this.onChanged,
    required this.showInitially,
    required this.color,
  });

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late bool searching;
  final controller = TextEditingController();
  final focus = FocusNode();

  @override
  void initState() {
    super.initState();
    searching = widget.showInitially;
    if (searching) WidgetsBinding.instance.addPostFrameCallback((_) {
      focus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!searching) {
      return Row(children: [
        Expanded(
            child: Text(widget.hint,
                style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                  color: widget.color,
                ))),
        IconButton(
          icon: const Icon(Icons.search),
          color: widget.color,
          onPressed: _toggle,
        )
      ]);
    }

    return TextField(
      controller: controller,
      focusNode: focus,
      style: TextStyle(color: widget.color),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hint,
        hintStyle: TextStyle(color: widget.color.withOpacity(0.6)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          color: widget.color,
          onPressed: _toggle,
        ),
      ),
      onChanged: widget.onChanged,
    );
  }

  void _toggle() {
    setState(() => searching = !searching);
    if (!searching) {
      controller.clear();
      widget.onChanged?.call('');
      focus.unfocus();
    }
    HapticFeedback.lightImpact();
  }
}
