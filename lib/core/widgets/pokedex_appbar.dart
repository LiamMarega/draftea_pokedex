import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PokedexAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PokedexAppBar({
    super.key,
    this.title = 'Draftea Pokedex',
    this.showBackButton = false,
    this.titleStyle,
  });

  final String title;
  final bool showBackButton;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3350D), // Bright Pokemon Red
            Color(0xFFA31A00), // Darker Red for depth
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              if (showBackButton) ...[
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 12),
              ],
              SvgPicture.asset(
                'assets/icons/pokeball.svg',
                height: 32,
                width: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style:
                      titleStyle ??
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
