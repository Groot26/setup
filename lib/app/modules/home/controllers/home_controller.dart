import 'package:get/get.dart';

import '../../../../data/repos/api_repo.dart';
import '../model/animal_model.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  @override
  void onInit() {
    getAnimals();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  RxList<Animal> allAnimals = <Animal>[].obs;
  // RxList allAnimals = RxList<dynamic>.from(box.get('animals') ?? [].obs);

  Future<void> getAnimals() async {
    try {
      List<dynamic> temp = await ApiRepo().fetchAnimals(1, 5);

      if (temp.isNotEmpty) {
        // Extract animals list and map to Animal objects
        List<Animal> animalsList = (temp[0]['animals'] as List)
            .map((animalJson) => Animal.fromJson(animalJson))
            .toList();

        // Save parsed data locally (if needed)
        // await box.put('animals', animalsList.map((animal) => animal.toJson()).toList());

        // Update the reactive list
        allAnimals.assignAll(animalsList);
      }
    } catch (e) {
      print("Error fetching animals: $e");
    }
  }
}

//Usage off HIVE And API Calls
// Future<void> getCategoryChain() async {
//
//   List<dynamic> temp = await ApiRepo().getCategoryChain();
//
//   await box.put('categoryChain', temp);
//
//   categoryChain.assignAll(await box.get('categoryChain'));
// }
