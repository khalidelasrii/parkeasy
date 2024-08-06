import 'package:flutter/material.dart';
import 'package:parkeasy/core/constant/enum.dart';

extension AccountStatusExtension on AccountStatus {
  // Méthode pour obtenir une description de chaque statut
  String get description {
    switch (this) {
      case AccountStatus.initial:
        return 'Initial: Account setup is in progress.';
      case AccountStatus.pending:
        return 'Pending: Account approval is pending.';
      case AccountStatus.accepted:
        return 'Accepted: Account has been accepted.';
      case AccountStatus.blocked:
        return 'Blocked: Account has been blocked.';
      default:
        return 'Unknown: Status is unknown.';
    }
  }

  // Méthode pour obtenir une couleur associée à chaque statut
  Color get color {
    switch (this) {
      case AccountStatus.initial:
        return Colors.blue;
      case AccountStatus.pending:
        return Colors.orange;
      case AccountStatus.accepted:
        return Colors.green;
      case AccountStatus.blocked:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Méthode pour obtenir une icône associée à chaque statut
  IconData get icon {
    switch (this) {
      case AccountStatus.initial:
        return Icons.hourglass_empty;
      case AccountStatus.pending:
        return Icons.hourglass_full;
      case AccountStatus.accepted:
        return Icons.check_circle;
      case AccountStatus.blocked:
        return Icons.block;
      default:
        return Icons.help;
    }
  }

  // Méthode pour obtenir un AccountStatus à partir d'une chaîne de caractères
  static AccountStatus fromString(String statusString) {
    switch (statusString.toLowerCase()) {
      case 'initial':
        return AccountStatus.initial;
      case 'pending':
        return AccountStatus.pending;
      case 'accepted':
        return AccountStatus.accepted;
      case 'blocked':
        return AccountStatus.blocked;
      default:
        throw ArgumentError('Invalid AccountStatus string: $statusString');
    }
  }
}
