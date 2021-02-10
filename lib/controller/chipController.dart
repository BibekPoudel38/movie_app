import 'package:get/get.dart';

class ChipController extends GetxController {
  int selectedChip = 0;

  selectedChipUpdate(int index) {
    selectedChip = index;
    update();
  }
}
