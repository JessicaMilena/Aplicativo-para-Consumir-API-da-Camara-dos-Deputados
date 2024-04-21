import 'package:flutter/material.dart';
import 'package:camara_dos_deputados/repositories/expense.dart';
import 'package:camara_dos_deputados/services/exceptions.dart';

import '../models/expense.dart';

class ExpenseStore {
  final ExpenseRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Expense>> state = ValueNotifier<List<Expense>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  ExpenseStore({required this.repository});

  Future getExpenses(int id, int year, int month) async {
    isLoading.value = true;
    try {
      final result = await repository.getExpenses(id, year, month);
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
