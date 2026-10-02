# 🧘 YogaBliss – Yoga Pose Image Classification  

🚀 **YogaBliss** is a Flutter-based mobile app for **classifying five yoga poses from gallery images**, using a CNN-based model integrated with **TensorFlow Lite**.  

## 🌟 Features  

✅ **Image Classification** – Classifies gallery images into five yoga pose categories.  
✅ **User-Friendly UI** – Intuitive design for a smooth experience.  
✅ **Pose Guide** – Illustrations and descriptions of the five supported poses.  
✅ **TensorFlow Lite Integration** – Runs the image classifier on-device.  
✅ **Firebase Integration** – Email/password authentication, user profiles, and profile-picture uploads.  


---

# 📱 App Screenshots  

### 🔹 **Main Screens**  
<p align="center">
  <img src="https://github.com/riiddhii28/flutter-yoga-pose-detection/blob/main/assets/readme_images/home_screen.jpeg?raw=true" alt="Home Screen" width="30%">
  <img src="https://github.com/riiddhii28/flutter-yoga-pose-detection/blob/main/assets/readme_images/pose_detection.jpeg?raw=true" alt="Pose Detection Screen" width="30%">
  <img src="https://github.com/riiddhii28/flutter-yoga-pose-detection/blob/main/assets/readme_images/pose_guide.jpeg?raw=true" alt="Pose Guide Screen" width="30%">
</p>

### 🔹 **Other Screens**  
<p align="center">
  <img src="https://github.com/riiddhii28/flutter-yoga-pose-detection/blob/main/assets/readme_images/sidebar.jpeg?raw=true" alt="Sidebar" width="30%">
  <img src="https://github.com/riiddhii28/flutter-yoga-pose-detection/blob/main/assets/readme_images/user.jpeg?raw=true" alt="User" width="30%">
</p>


---

## 📂 Dataset  
YogaBliss is trained on the **Yoga Pose Classification** dataset from Kaggle:  
[![Kaggle Dataset](https://img.shields.io/badge/Kaggle-Yoga%20Pose%20Classification-blue?style=flat&logo=kaggle)](https://www.kaggle.com/datasets/ujjwalchowdhury/yoga-pose-classification)  

This dataset contains **5 yoga poses** with images:  
- 🧎 **Downdog**  
- 💪 **Plank**  
- 🏋️ **Goddess**  
- 🌲 **Tree**  
- 🏹 **Warrior2**  

## 🔥 Model Training  

The **CNN-based classifier** was trained using **TensorFlow & Keras** in Google Colab and converted to **TensorFlow Lite** for integration into the Flutter app. The training notebook is linked below:  
🔗 **[YogaBliss Model Training Notebook](https://colab.research.google.com/drive/1Nja1O9GkNPofoix8EtKbfo7nZYF-JihF?usp=sharing)**  

### **Training Details:**  
- Model: **CNN-based classifier** trained on **Yoga Pose Classification** dataset  
- Framework: **TensorFlow & Keras**  
- **85% test accuracy across five yoga poses.**  
- Converted to **TensorFlow Lite** for mobile integration  

## 🚀 Installation  

📝 This older project requires local setup before running: provide the model files (`assets/yoga_pose_classifier.tflite` and `assets/movenet_thunder.tflite`) and sample course video (`assets/yoga_video.mp4`) declared in `pubspec.yaml`, and configure Firebase for your target platform. These assets and the Android/iOS Firebase configuration files are not included in this checkout.

1️⃣ **Clone the repository**  
```bash
git clone https://github.com/riiddhii28/flutter-yoga-pose-detection.git
cd flutter-yoga-pose-detection
```  

2️⃣ **Install dependencies**  
```bash
flutter pub get
```  

3️⃣ **Run the app**  
```bash
flutter run
```  

## ⚡ Tech Stack  

- **Flutter** (Dart) – Frontend framework  
- **TensorFlow Lite** – AI model integration  
- **Firebase** – Authentication, Firestore user profiles, and Storage for profile pictures  

