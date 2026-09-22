import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unity_hr/helpers/constants.dart';

import '../../../controllers/navbar_controller.dart';

Widget buildButtomNavBar() {
  return GetBuilder<NavBarController>(
    builder: (controller) {
      return _buildGlassNavigationBar(
        currentIndex: controller.currentIndex,
        onTap: controller.changePage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Requests',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: 'Team'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Duty'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      );
    },
  );
}

Widget _buildGlassNavigationBar({
  required int currentIndex,
  required ValueChanged<int> onTap,
  required List<BottomNavigationBarItem> items,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 64,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            // color: Colors.white.withValues(alpha: 0.25),
            border: Border.all(
              width: 0.8,
              color: Colors.white.withValues(alpha: 0.85),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = currentIndex == index;

              return GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  // duration: const Duration(milliseconds: 300),
                  width: 65,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xffDFDDE2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          size: 22,
                          color: isSelected ? color1 : Colors.grey.shade600,
                        ),
                        child: item.icon,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label ?? '',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected ? color1 : Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    ),
  );
}

Widget buildAdminButtomNavBar() {
  return GetBuilder<NavBarController>(
    builder: (controller) {
      return _buildGlassNavigationBar(
        currentIndex: controller.currentIndex,
        onTap: controller.changePage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined, size: 23),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined, size: 23),
            label: 'Leave',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later_outlined, size: 23),
            label: 'Overtime',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline, size: 23),
            label: 'Employee',
          ),
        ],
      );
    },
  );
}
