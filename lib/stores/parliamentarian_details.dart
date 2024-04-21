import 'package:flutter/material.dart';
import 'package:camara_dos_deputados/repositories/parliamentarian_details.dart';

import '../models/parliamentarian_details.dart';

class ParliamentarianDetailsStore {
  final ParliamentarianDetailsRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<ParliamentarianDetails> state =
      ValueNotifier<ParliamentarianDetails>(ParliamentarianDetails());
  final ValueNotifier<String> error = ValueNotifier<String>('');

  ParliamentarianDetailsStore({required this.repository});

  Future getParliamentarianDetails(int id) async {
    isLoading.value = true;
    try {
      final result = await repository.getParliamentarian(id);
      state.value = result;
    } on Exception catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
