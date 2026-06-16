import 'package:f1_news/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ErrorRetry extends StatefulWidget {
  final String errorMessage;
  final Future<void> Function() onRetry;

  const ErrorRetry({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  State<ErrorRetry> createState() => _ErrorRetryState();
}

class _ErrorRetryState extends State<ErrorRetry> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
             Text(
              l10n.errorRetry,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 24),
            // ElevatedButton.icon(
            //   onPressed: widget.onRetry,
            //   icon: const Icon(Icons.refresh),
            //   label: Text(l10n.retryButton),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.red,
            //     foregroundColor: Colors.white,
            //   ),
            // ),
            ElevatedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () async {
                setState(() {
                  _isLoading = true;
                });

                try {
                  await widget.onRetry();
                } finally {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
              icon: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.refresh),
              label: Text(_isLoading ? l10n.loadingButton : l10n.retryButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.red.withValues(),
                disabledForegroundColor: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}