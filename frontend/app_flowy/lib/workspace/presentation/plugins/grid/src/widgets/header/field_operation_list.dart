import 'package:app_flowy/workspace/application/grid/field/edit_field_bloc.dart';
import 'package:flowy_infra/image.dart';
import 'package:flowy_infra/theme.dart';
import 'package:flowy_infra_ui/style_widget/button.dart';
import 'package:flowy_infra_ui/style_widget/text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app_flowy/generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldOperationList extends StatelessWidget {
  final VoidCallback onDismiss;
  const FieldOperationList({required this.onDismiss, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = FieldAction.values
        .map((action) => FieldActionItem(
              action: action,
              onTap: onDismiss,
            ))
        .toList();
    return GridView(
      // https://api.flutter.dev/flutter/widgets/AnimatedList/shrinkWrap.html
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4.0,
        mainAxisSpacing: 8,
      ),
      children: children,
    );
  }
}

class FieldActionItem extends StatelessWidget {
  final VoidCallback onTap;
  final FieldAction action;
  const FieldActionItem({required this.action, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppTheme>();
    return FlowyButton(
      text: FlowyText.medium(action.title(), fontSize: 12),
      hoverColor: theme.hover,
      onTap: () {
        action.run(context);
        onTap();
      },
      leftIcon: svg(action.iconName(), color: theme.iconColor),
    );
  }
}

enum FieldAction {
  hide,
  duplicate,
  delete,
}

extension _FieldActionExtension on FieldAction {
  String iconName() {
    switch (this) {
      case FieldAction.hide:
        return 'grid/hide';
      case FieldAction.duplicate:
        return 'grid/duplicate';
      case FieldAction.delete:
        return 'grid/delete';
    }
  }

  String title() {
    switch (this) {
      case FieldAction.hide:
        return LocaleKeys.grid_field_hide.tr();
      case FieldAction.duplicate:
        return LocaleKeys.grid_field_duplicate.tr();
      case FieldAction.delete:
        return LocaleKeys.grid_field_delete.tr();
    }
  }

  void run(BuildContext context) {
    switch (this) {
      case FieldAction.hide:
        context.read<EditFieldBloc>().add(const EditFieldEvent.hideField());
        break;
      case FieldAction.duplicate:
        context.read<EditFieldBloc>().add(const EditFieldEvent.duplicateField());
        break;
      case FieldAction.delete:
        context.read<EditFieldBloc>().add(const EditFieldEvent.deleteField());
        break;
    }
  }
}