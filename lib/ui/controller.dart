import 'package:flutter/material.dart';

import '../data/models/device.dart';
import '../data/models/new_user_model.dart';
import '../data/models/user_model.dart';
import '../data/repository/user_repository.dart';
import '../data/repository/device_repository.dart';
import '../di/service_locator.dart';

class HomeController {
  // --------------- Repository -------------
  final userRepository = getIt.get<UserRepository>();
  final deviceRepository = getIt.get<DeviceRepository>();

  // -------------- Textfield Controller ---------------
  final nameController = TextEditingController();
  final jobController = TextEditingController();

  // -------------- Local Variables ---------------
  final List<NewUser> newUsers = [];

  // -------------- Methods ---------------

  Future<List<UserModel>> getUsers() async {
    final users = await userRepository.getUsersRequested();
    return users;
  }

  Future<NewUser> addNewUser() async {
    final newlyAddedUser = await userRepository.addNewUserRequested(
      nameController.text,
      jobController.text,
    );
    newUsers.add(newlyAddedUser);
    return newlyAddedUser;
  }

  Future<NewUser> updateUser(int id, String name, String job) async {
    final updatedUser = await userRepository.updateUserRequested(
      id,
      name,
      job,
    );
    newUsers[id] = updatedUser;
    return updatedUser;
  }

  Future<void> deleteNewUser(int id) async {
    await userRepository.deleteNewUserRequested(id);
    newUsers.removeAt(id);
  }

  Future<Device> provisionDevice(String? deviceName) async {
    final device = await deviceRepository.provisionDevice(deviceName);
    return device;
  }
}
