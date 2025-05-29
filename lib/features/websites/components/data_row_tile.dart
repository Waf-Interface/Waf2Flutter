import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/component/widgets/status_widget.dart';

class DataRowTile {
  static DataRow websiteRow({
    required String name,
    required String application,
    required String listenTo,
    required String realWebServer,
    required VoidCallback onTapLog,
    required String status,
    required String statusNotes,
    required String mode, // Added mode parameter to reflect API data
    required Function(String) onModeChanged, // Changed to String to match API
    required VoidCallback onListenTap,
    required VoidCallback onTapEdit,
    required VoidCallback onTapStart,
    required VoidCallback onTapPause,
    required VoidCallback onTapDelete,
  }) {
    DataCell dataCellMaker(String title) => DataCell(
      SizedBox(
        width: 100,
        child: Text(title, overflow: TextOverflow.ellipsis),
      ),
    );
    String capitalize(String input) =>
        "${input[0].toUpperCase()}${input.substring(1)}";

    bool isActive = status == 'Active'.tr;

    return DataRow(
      cells: [
        dataCellMaker(name),
        dataCellMaker(application),
        DataCell(
          SizedBox(
            width: 100,
            child: InkWell(
              onTap: onListenTap,
              child: Text(listenTo, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        dataCellMaker(realWebServer),
        DataCell(
          IconButton(
            icon: const Center(
              child: Icon(
                Icons.search_sharp,
                size: 25,
              ),
            ),
            onPressed: onTapLog,
            padding: EdgeInsets.zero,
          ),
        ),
        // Status
        DataCell(
          SizedBox(
            width: 80,
            child: StatusWidget(
              title: isActive ? 'Enabled'.tr : 'Disabled'.tr,
              titleColor: isActive ? Colors.green[900] : Colors.red[900],
            ),
          ),
        ),
        // Status Notes
        DataCell(
          SizedBox(
            width: 200,
            child: Text(
              statusNotes,
              style: TextStyle(
                color: isActive ? Colors.grey : Colors.red[700],
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // Mode
        DataCell(
          SizedBox(
            width: 100,
            child: DropdownButton<String>(
              value: mode.isEmpty ? 'disabled'.tr : mode, // Default to 'disabled' if empty
              isExpanded: true,
              items: ['enabled'.tr, 'disabled'.tr].map((modeValue) {
                return DropdownMenuItem<String>(
                  value: modeValue,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      capitalize(modeValue),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) => onModeChanged(value!),
            ),
          ),
        ),
        // Actions
        DataCell(
          SizedBox(
            width: 150,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconbuttonWidget(
                  icon: Icons.edit,
                  backColor: Colors.blue,
                  onPressed: onTapEdit,
                ),
                const SizedBox(width: 5),
                CustomIconbuttonWidget(
                  icon: Icons.play_arrow,
                  backColor: Colors.green,
                  onPressed: onTapStart,
                ),
                const SizedBox(width: 5),
                CustomIconbuttonWidget(
                  icon: Icons.pause,
                  backColor: Colors.yellow,
                  iconColor: Colors.black,
                  onPressed: onTapPause,
                ),
                const SizedBox(width: 5),
                CustomIconbuttonWidget(
                  icon: Icons.delete,
                  backColor: Colors.red,
                  onPressed: onTapDelete,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static DataRow addWebsiteRow({
    required String name,
    required String applicationUrl,
    required String status,
    required String author,
    required VoidCallback onTapDeploy,
    required VoidCallback onTapDelete,
  }) {
    DataCell dataCellMaker(String title) => DataCell(
      SizedBox(
        width: 100,
        child: Text(title, overflow: TextOverflow.ellipsis),
      ),
    );
    return DataRow(
      cells: [
        dataCellMaker(name),
        dataCellMaker(applicationUrl),
        DataCell(
          SizedBox(
            width: 80,
            child: StatusWidget(
              title: status,
              titleColor: Colors.green[900],
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 80,
            child: StatusWidget(
              title: author,
              backgrounColor: Colors.blue[100],
              titleColor: Colors.blueAccent,
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconbuttonWidget(
                  icon: Icons.rocket_launch,
                  backColor: Colors.green[300]!,
                  iconColor: Colors.black,
                  titleColor: Colors.black,
                  title: "Deploy".tr,
                  onPressed: onTapDeploy,
                ),
                const SizedBox(width: 5),
                CustomIconbuttonWidget(
                  icon: Icons.delete_outline_rounded,
                  backColor: Colors.redAccent,
                  title: "Delete".tr,
                  onPressed: onTapDelete,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}