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
      backgroundColor: Color(0xFFF8F5F2), 
      appBar: AppBar(
        title: Text("🧘 Pose Guide", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6D3A3F), 
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: yogaPoses.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        yogaPoses[index]["image"]!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            yogaPoses[index]["name"]!,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text(
                            yogaPoses[index]["description"]!,
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
