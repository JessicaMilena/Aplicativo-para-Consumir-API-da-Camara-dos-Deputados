import 'package:flutter/material.dart';

import 'package:camara_dos_deputados/repositories/commission.dart';
import 'package:camara_dos_deputados/services/exceptions.dart';
import '../models/commission.dart';

class CommissionStore {
  final CommissionRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Commission>> state =
      ValueNotifier<List<Commission>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  CommissionStore({required this.repository});

  Future getCommissions() async {
    isLoading.value = true;

    try {
      final result = await repository.getCommissions();
      state.value = result;
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
