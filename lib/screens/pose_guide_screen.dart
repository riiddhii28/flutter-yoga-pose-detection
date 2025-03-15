import 'package:flutter/material.dart';

class PoseGuideScreen extends StatelessWidget {
  final List<Map<String, String>> yogaPoses = [
    {
      "name": "Downdog",
      "description": "Start on your hands and knees. Lift your hips upward, forming an inverted 'V' shape. Keep your hands and feet firmly on the ground.",
      "image": "assets/images/downdog.png"
    },
    {
      "name": "Goddess",
      "description": "Stand with feet wide apart. Bend your knees and lower into a squat, keeping your back straight and arms raised.",
      "image": "assets/images/goddess.png"
    },
    {
      "name": "Plank",
      "description": "Keep your body straight, balancing on your hands and toes. Engage your core and hold the position.",
      "image": "assets/images/plank.png"
    },
    {
      "name": "Tree",
      "description": "Stand straight, place one foot on the opposite inner thigh, and balance while keeping hands in a prayer position.",
      "image": "assets/images/tree.png"
    },
    {
      "name": "Warrior 2",
      "description": "Stand with feet wide apart, bend one knee forward while keeping the other leg straight, and extend both arms parallel to the ground.",
      "image": "assets/images/warrior2.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yoga Pose Guide")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: yogaPoses.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Image.asset(
                yogaPoses[index]["image"]!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(
                yogaPoses[index]["name"]!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(yogaPoses[index]["description"]!),
            ),
          );
        },
      ),
    );
  }
}
