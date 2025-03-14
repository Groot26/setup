import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:setup/app/modules/home/model/animal_model.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Animals'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () => controller.getAnimals(),
          child: Obx(
            () => controller.allAnimals.isEmpty
                ? const Center(child: Text("No animals available"))
                : ListView.builder(
                    itemCount: controller.allAnimals.length,
                    itemBuilder: (context, index) =>
                        BuildCard(animal: controller.allAnimals[index]),
                  ),
          ),
        ));
  }
}

Widget BuildCard({required Animal animal}) {
  return Card(
    child: Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(animal.habitatUrl),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${animal.name}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Species: ${animal.species}"),
              Text("Age: ${animal.age}"),
              Text("Habitat: ${animal.habitat}"),
            ],
          ),
        )
      ],
    ),
  );
}
