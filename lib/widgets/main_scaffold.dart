import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/theme/shede_colors.dart';
import '../config/theme/shede_theme.dart';
import '../config/theme/neu_context.dart';

/// Neumorphism 风格底部导航栏
/// 凸起的药丸导航 + 凸起的圆形记账按钮
class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainScaffold({super.key, required this.navigationShell});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int? _pressedIndex;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    final c = Theme.of(context).colorScheme;
    final sh = NeuShadows.of(context);

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPad + 10),
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: c.neuBg,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: sh.raised,
                  ),
                  child: Row(
                    children: [
                      _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, c, sh),
                      _buildNavItem(1, Icons.calendar_month_rounded, Icons.calendar_month_outlined, c, sh),
                      _buildNavItem(2, Icons.bar_chart_rounded, Icons.bar_chart_outlined, c, sh),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // 右侧：凸起圆形按钮
              _buildAddButton(context, c, sh),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, ColorScheme c, NeuShadows sh) {
    final isActive = index == widget.navigationShell.currentIndex;
    final isPressed = _pressedIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressedIndex = index),
        onTapUp: (_) {
          setState(() => _pressedIndex = null);
          widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
        },
        onTapCancel: () => setState(() => _pressedIndex = null),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          decoration: BoxDecoration(
            color: c.neuBg,
            borderRadius: BorderRadius.circular(28),
            boxShadow: isPressed
                ? sh.inset
                : isActive
                    ? sh.raisedSm
                    : null,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                isActive ? activeIcon : inactiveIcon,
                key: ValueKey('$index-$isActive'),
                size: 24,
                color: isActive ? c.neuTint : c.neuSecondaryLabel,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, ColorScheme c, NeuShadows sh) {
    final isPressed = _pressedIndex == -1;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressedIndex = -1),
      onTapUp: (_) {
        setState(() => _pressedIndex = null);
        context.push('/add-record');
      },
      onTapCancel: () => setState(() => _pressedIndex = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: c.neuBg,
          shape: BoxShape.circle,
          boxShadow: isPressed ? sh.inset : sh.raised,
        ),
        child: Center(
          child: Icon(Icons.add_rounded, size: 30, color: c.neuTint),
        ),
      ),
    );
  }
}
