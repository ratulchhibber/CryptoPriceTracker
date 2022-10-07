import 'package:flutter/material.dart';

enum Favorite { enabled, disabled }

extension FavoriteExtension on Favorite {
  IconData get icon {
    switch (this) {
      case Favorite.enabled:
        return Icons.favorite;
      case Favorite.disabled:
        return Icons.favorite_border;
    }
  }

  Color get iconColor {
    switch (this) {
      case Favorite.enabled:
        return Colors.red.shade400;
      case Favorite.disabled:
        return Colors.grey;
    }
  }
}
