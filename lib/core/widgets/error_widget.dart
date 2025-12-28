import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.title = '¡Ups! Algo salió mal',
    this.message =
        'Ha ocurrido un error inesperado. Por favor, intenta de nuevo.',
    this.onRetry,
    this.icon,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red..withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child:
                  icon ??
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 80,
                    color: Colors.redAccent,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'Reintentar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
