import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:settings_ui/src/cupertino_settings_item.dart';
import 'package:settings_ui/src/extensions.dart';

enum _SettingsTileType { simple, switchTile, dropDown }

class SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final Widget trailing;
  final VoidCallback onTap;
  final Function(bool value) onToggle;
  final Function(String value) onDropDownSelected;
  final bool switchValue;
  final bool enabled;
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;
  final Color switchActiveColor;
  final _SettingsTileType _tileType;

  final List<String> dropDownList;

  const SettingsTile({
    Key key,
    @required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.enabled = true,
    this.switchActiveColor,
    this.dropDownList,
    this.onDropDownSelected,
  })  : _tileType = _SettingsTileType.simple,
        onToggle = null,
        switchValue = null,
        super(key: key);

  const SettingsTile.switchTile({
    Key key,
    @required this.title,
    this.subtitle,
    this.leading,
    this.enabled = true,
    this.trailing,
    @required this.onToggle,
    @required this.switchValue,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.switchActiveColor,
    this.dropDownList,
    this.onDropDownSelected,
  })  : _tileType = _SettingsTileType.switchTile,
        onTap = null,
        super(key: key);

  const SettingsTile.dropDown({
    Key key,
    @required this.title,
    this.subtitle,
    this.leading,
    this.enabled = true,
    this.trailing,
    @required this.onToggle,
    @required this.switchValue,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.switchActiveColor,
    this.dropDownList,
    this.onDropDownSelected,
  })  : _tileType = _SettingsTileType.dropDown,
        onTap = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return androidTile();
  }

  Widget iosTile() {
    if (_tileType == _SettingsTileType.switchTile) {
      return CupertinoSettingsItem(
        enabled: enabled,
        type: SettingsItemType.toggle,
        label: title,
        leading: leading,
        switchValue: switchValue,
        onToggle: onToggle,
        labelTextStyle: titleTextStyle,
        switchActiveColor: switchActiveColor,
        subtitleTextStyle: subtitleTextStyle,
        valueTextStyle: subtitleTextStyle,
      );
    } else if (_tileType == _SettingsTileType.simple) {
      return CupertinoSettingsItem(
        enabled: enabled,
        type: SettingsItemType.modal,
        label: title,
        value: subtitle,
        trailing: trailing,
        hasDetails: false,
        leading: leading,
        onPress: onTap,
        labelTextStyle: titleTextStyle,
        subtitleTextStyle: subtitleTextStyle,
        valueTextStyle: subtitleTextStyle,
      );
    } else {
      
      List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
        List<DropdownMenuItem<String>> items = List();
        for (String listItem in listItems) {
          items.add(
            DropdownMenuItem(
              child: Text(listItem),
              value: listItem,
            ),
          );
        }
        return items;
      }

      return DropdownButton(
        value: title,
          items: buildDropDownMenuItems(dropDownList),
          onChanged: (value) {
            onDropDownSelected(value);
          });
    }
  }

  Widget androidTile() {
    if (_tileType == _SettingsTileType.switchTile) {
      return SwitchListTile(
        secondary: leading,
        value: switchValue,
        activeColor: switchActiveColor,
        onChanged: enabled ? onToggle : null,
        title: Text(title, style: titleTextStyle),
        subtitle:
            subtitle != null ? Text(subtitle, style: subtitleTextStyle) : null,
      );
    } else if(_tileType==_SettingsTileType.simple) {
      return ListTile(
        title: Text(title, style: titleTextStyle),
        subtitle:
            subtitle != null ? Text(subtitle, style: subtitleTextStyle) : null,
        leading: leading,
        enabled: enabled,
        trailing: trailing,
        onTap: onTap,
      );
    } else {

      return ListTile(
        leading:  leading,
        title: Text(title),
        trailing:    DropdownButton(
          underline: null,
            value: subtitle,
            items: buildDropDownMenuItems(dropDownList),
            onChanged: (value) {
              onDropDownSelected(value);
            }),
      );
    }
  }


  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem),
          value: listItem,
        ),
      );
    }
    return items;
  }

}
