import 'package:flutter/material.dart';
import 'package:parkeasy/core/constant/enum.dart';



extension AppStatusExtension on AppStatus {
  // Méthode pour obtenir un AppStatus à partir d'une chaîne de caractères
  AppStatus fromString(String statusString) {
    switch (statusString.toLowerCase()) {
      case 'warning':
        return AppStatus.warning;
      case 'success':
        return AppStatus.success;
      case 'error':
        return AppStatus.error;
      case 'loading':
        return AppStatus.loading;
      case 'infos':
        return AppStatus.infos;
      case 'unknown':
      default:
        return AppStatus.unknown;
    }
  }

// Méthode pour obtenir une description de chaque statut

  String get description {
    switch (this) {
      case AppStatus.warning:
        return 'Warning: Be cautious!';
      case AppStatus.success:
        return 'Success: Operation completed successfully!';
      case AppStatus.error:
        return 'Error: An error occurred!';
      case AppStatus.loading:
        return 'Loading: Please wait...';
      case AppStatus.infos:
        return 'Infos: Here are some information!';
      case AppStatus.unknown:
      default:
        return 'Unknown: Status is unknown!';
    }
  }

  // Méthode pour obtenir une couleur associée à chaque statut
  Color get color {
    switch (this) {
      case AppStatus.warning:
        return Colors.yellow;
      case AppStatus.success:
        return Colors.green;
      case AppStatus.error:
        return Colors.red;
      case AppStatus.loading:
        return Colors.blue;
      case AppStatus.infos:
        return Colors.grey;
      case AppStatus.unknown:
      default:
        return Colors.black;
    }
  }

  // Méthode pour obtenir une icône associée à chaque statut
  IconData get icon {
    switch (this) {
      case AppStatus.warning:
        return Icons.warning;
      case AppStatus.success:
        return Icons.check_circle;
      case AppStatus.error:
        return Icons.error;
      case AppStatus.loading:
        return Icons.hourglass_empty;
      case AppStatus.infos:
        return Icons.info;
      case AppStatus.unknown:
      default:
        return Icons.help;
    }
  }
}
