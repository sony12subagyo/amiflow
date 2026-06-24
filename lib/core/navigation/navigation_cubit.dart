// lib/core/navigation/navigation_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0); // tab awal = Beranda

  void selectTab(int index) {
    if (index < 0) return; // -1 = aksi kamera, bukan tab. Abaikan.
    emit(index);
  }
}