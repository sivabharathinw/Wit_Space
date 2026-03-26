import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum AppIconName {
  home,
  calendar,
  grid,
  users,
  settings,
  search,
  plus,
  x,
  check,
  chevronDown,
  chevronRight,
  chevronLeft,
  chevronUp,
  arrowUp,
  arrowDown,
  arrowRight,
  clock,
  mapPin,
  star,
  wifi,
  coffee,
  monitor,
  phone,
  mail,
  lock,
  eye,
  eyeOff,
  logOut,
  barChart,
  filter,
  edit,
  trash,
  bell,
  user,
  creditCard,
  zap,
  menu,
}

class AppIcon extends StatelessWidget {
  final AppIconName name;
  final double size;
  final Color? color;

  const AppIcon(this.name, {super.key, this.size = 16, this.color});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (name) {
      case AppIconName.home: iconData = LucideIcons.home; break;
      case AppIconName.calendar: iconData = LucideIcons.calendar; break;
      case AppIconName.grid: iconData = LucideIcons.layoutGrid; break;
      case AppIconName.users: iconData = LucideIcons.users; break;
      case AppIconName.settings: iconData = LucideIcons.settings; break;
      case AppIconName.search: iconData = LucideIcons.search; break;
      case AppIconName.plus: iconData = LucideIcons.plus; break;
      case AppIconName.x: iconData = LucideIcons.x; break;
      case AppIconName.check: iconData = LucideIcons.check; break;
      case AppIconName.chevronDown: iconData = LucideIcons.chevronDown; break;
      case AppIconName.chevronRight: iconData = LucideIcons.chevronRight; break;
      case AppIconName.chevronLeft: iconData = LucideIcons.chevronLeft; break;
      case AppIconName.chevronUp: iconData = LucideIcons.chevronUp; break;
      case AppIconName.arrowUp: iconData = LucideIcons.arrowUp; break;
      case AppIconName.arrowDown: iconData = LucideIcons.arrowDown; break;
      case AppIconName.arrowRight: iconData = LucideIcons.arrowRight; break;
      case AppIconName.clock: iconData = LucideIcons.clock; break;
      case AppIconName.mapPin: iconData = LucideIcons.mapPin; break;
      case AppIconName.star: iconData = LucideIcons.star; break;
      case AppIconName.wifi: iconData = LucideIcons.wifi; break;
      case AppIconName.coffee: iconData = LucideIcons.coffee; break;
      case AppIconName.monitor: iconData = LucideIcons.monitor; break;
      case AppIconName.phone: iconData = LucideIcons.phone; break;
      case AppIconName.mail: iconData = LucideIcons.mail; break;
      case AppIconName.lock: iconData = LucideIcons.lock; break;
      case AppIconName.eye: iconData = LucideIcons.eye; break;
      case AppIconName.eyeOff: iconData = LucideIcons.eyeOff; break;
      case AppIconName.logOut: iconData = LucideIcons.logOut; break;
      case AppIconName.barChart: iconData = LucideIcons.barChart; break;
      case AppIconName.filter: iconData = LucideIcons.filter; break;
      case AppIconName.edit: iconData = LucideIcons.edit; break;
      case AppIconName.trash: iconData = LucideIcons.trash; break;
      case AppIconName.bell: iconData = LucideIcons.bell; break;
      case AppIconName.user: iconData = LucideIcons.user; break;
      case AppIconName.creditCard: iconData = LucideIcons.creditCard; break;
      case AppIconName.zap: iconData = LucideIcons.zap; break;
      case AppIconName.menu: iconData = LucideIcons.menu; break;
    }

    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
}
