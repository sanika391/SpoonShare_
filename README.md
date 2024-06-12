# SpoonShare 🥣

## 💡 Introduction

**Problem Statement**: Inadequate surplus food distribution generates hunger, necessitating a comprehensive solution. Our project addresses this challenge through an innovative platform, connecting donors with recipients to bridge the gap in food distribution.

**Solution**: Spoon Share is an Android app tackling food insecurity by connecting surplus food donors with individuals and NGOs in need. Our platform reduces food waste, promotes sustainability, and supports the UN's Sustainable Development Goals of No Poverty and Zero Hunger by 2030. With real-time food listings, volunteer networks, and collaborative partnerships, Spoon Share empowers communities to make a positive impact on food distribution and well-being.


## Live Preview

**Download the APK:**

- [SpoonShare APK](https://github.com/shuence/SpoonShare/releases/download/v.1.1.0/SpoonShare.apk)

**Experience SpoonShare firsthand by visiting the deployed version:**

- [SpoonShare](https://spoonshare-meals.web.app/)


Join us in the mission to minimize food waste, foster community engagement, and make a positive impact on the world!!!

Spoon Share is an Android app that fights food insecurity by connecting surplus food donors with those in need. Our goal is to reduce food waste, tackle child malnutrition, and promote sustainability. Join us in achieving UN Sustainable Development Goals 1 *(No Poverty)* and 2 *(Zero Hunger)* by 2030. Together, let's make a meaningful impact on food distribution and well-being.

# SpoonShare Project

## Intro To SpoonShare Video

[![Intro To SpoonShare](https://github.com/shuence/SpoonShare/assets/65482186/927266f1-8703-4dac-9bb6-922e5844458e)](https://www.youtube.com/watch?v=Ui9rmhcHARM)


Short but detailed introduction to SpoonShare. Click on the image above to watch the video.

## Getting Started
Before running the project, make sure you have the necessary files downloaded:
1. **firebase_options.dart**: Located in the `lib` folder.
2. **google-services.json**: Located in the `android/app/` directory.

You can download these files from the following links:
- [firebase_options.dart](https://drive.google.com/drive/folders/16JjJ-FC_-CMKyd1OO5Nejc1W44c6fM9y?usp=drive_link)
- [google-services.json](https://drive.google.com/drive/folders/16JjJ-FC_-CMKyd1OO5Nejc1W44c6fM9y?usp=drive_link)

## Installation

To install and run the project, follow these steps:
1. Clone this repository to your local machine.
2. Place the downloaded `firebase_options.dart` file in the `lib` folder.
3. Place the downloaded `google-services.json` file in the `android/app/` directory.

## Setup

### With Docker

1. Clone the repository:
```bash
git clone https://github.com/shuence/SpoonShare
```
2. Navigate to the project directory:
```bash
cd SpoonShare
```
3. Build docker Image (only needed during first installation)
```bash
docker build -t spoonshare:latest .     
```
4. Run docker image
```bash
docker run -d -p 80:80 spoonshare:latest
```
The app should now be running at [http://localhost:80](http://localhost:80).

### With Docker Compose

1. Clone the repository:
```bash
git clone https://github.com/shuence/SpoonShare
```
2. Navigate to the project directory:
```bash
cd SpoonShare
```
3. Build docker-compose (only needed during first installation)
```bash
docker-compose up --build               
```
4. Run docker-compose
```bash
docker-compose up
```
The app should now be running at [http://localhost:80](http://localhost:80).

### Without Docker

```bash
git clone https://github.com/shuence/SpoonShare
```
```bash
cd SpoonShare
```
```bash
flutter pub get
```
```bash
flutter run
```

## Resources

- [Flutter Docs](https://docs.flutter.dev/)
- [Figma](https://help.figma.com/hc/en-us)
- [Firebase Docs](https://firebase.google.com/docs)
  
# Screenshots
<pre>
<img src="https://github.com/shuence/SpoonShare/assets/65482186/a9f9423f-6843-445d-8233-4be9e731cbe4" width="250"> <img
src="https://github.com/shuence/SpoonShare/assets/65482186/e171eb6c-41d5-4d54-a254-c61838fc18e5" width="250"> <img 
src="https://github.com/shuence/SpoonShare/assets/65482186/b6560714-09a7-4673-aeb1-c9ed7e59d1c0"  width="250"> <img 
src="https://github.com/shuence/SpoonShare/assets/65482186/15307620-b76f-4423-a2fc-ac6a08e91abe" width="250"> <img src="https://github.com/shuence/SpoonShare/assets/65482186/840be77d-0420-4647-b9d9-ab2c47c602f7" width="250">
<img src="https://github.com/shuence/SpoonShare/assets/65482186/8ff0b600-2bfc-4ebd-bd90-299b5a07b2f8" width="250"> <img 
src="https://github.com/shuence/SpoonShare/assets/65482186/d1bc11d6-e72e-497a-9b27-32c4c1962836" width="250"> <img
src="https://github.com/shuence/SpoonShare/assets/65482186/70cd7833-fce3-438a-a71b-967c06fe8035" width="250"> <img src="https://github.com/shuence/SpoonShare/assets/65482186/f45e4157-969c-4f73-b048-f5cd6df87f71" width="250"> <img 
src="https://github.com/shuence/SpoonShare/assets/65482186/8d4585f0-09ac-41a1-be2f-d6e93d4ed592" width="250"> 
<img src="https://github.com/shuence/SpoonShare/assets/65482186/ba41649b-6726-44fb-a6e0-96781f63e2b1" width="250"> <img 
src="https://github.com/shuence/SpoonShare/assets/65482186/be11e412-6fa8-48a6-a8ce-5b7d1b7a8fd6" width="250"> <img
src="https://github.com/shuence/SpoonShare/assets/65482186/7c65f0db-8744-43d4-b7a6-13d9ef60ee3e" width="250"> <img src="https://github.com/shuence/SpoonShare/assets/65482186/a3d8c217-379c-4f8b-bf17-51b45f8bd4bb" width="250"> <img src="https://github.com/shuence/SpoonShare/assets/65482186/ed3f38a2-b663-4df0-8762-07fc1440a21b" width="250"> 
<img src="https://github.com/shuence/SpoonShare/assets/65482186/8e463244-f8b9-4b03-8c7a-a9d028d2a549" width="250"> <img
src="https://github.com/shuence/SpoonShare/assets/65482186/122679cf-0f07-4344-b65a-dcc473e2dd21" width="250"> <img 
src="https://github.com/shuence/SpoonShare/assets/65482186/5cd3781a-645d-45c1-a54a-0b58fbc9e605" width="250"> <img src="https://github.com/shuence/SpoonShare/assets/65482186/c6cc77a5-232e-4626-a4cb-f6af9229ab81" width="250"> <img src="https://github.com/shuence/SpoonShare/assets/65482186/8a3089ef-5144-4089-93fb-20cb9f7279c5" width="250"> 
<img src="https://github.com/shuence/SpoonShare/assets/65482186/a0ff1d91-e9f7-4768-a91d-24f8d510962a" width="250"> <img src="https://github.com/shuence/SpoonShare/assets/65482186/ba441ec8-78ec-43d5-8829-a3b8273370c5" width="250"> 
</pre>

## Key Features:
1. **Surplus Food Map:**
   - Visualize surplus food locations on an interactive map, facilitating easy navigation and access to available resources within a 30km radius.
2. **User-Friendly Interface:**
   - Intuitive design ensures a seamless experience for donors, recipients, volunteers, and NGOs, promoting accessibility and usability for all users.
3. **Real-Time Updates:**
   - Stay informed with instant notifications about surplus food availability, ensuring timely distribution and reducing food wastage.
4. **Volunteer Matching:**
   - Connect volunteers with surplus food distribution opportunities tailored to their preferences and availability, fostering community involvement and support.
5. **Quality and Safety Standards Verification:**
   - Implement rigorous guidelines to verify the quality and safety of donated food, ensuring compliance with standards and regulations.
6. **Collaboration with Local Governments and NGOs:**
   - Forge partnerships with local authorities and non-governmental organizations (NGOs) to streamline operations, leverage resources, and adhere to regulatory requirements effectively.

## Additional Features:
- **Food Sharing:** 
  - Facilitate the sharing of surplus food among community members, encouraging generosity and reducing food waste.
- **Food Donation:**
  - Enable users to donate surplus food to those in need, promoting compassion and addressing food insecurity issues.
- **Food Recycling:**
  - Promote sustainable practices by facilitating the recycling of surplus food, minimizing environmental impact and promoting resource efficiency.
- **Admin Dashboard:**
  - Empower administrators to verify shared, donated, and recycled food, ensuring adherence to quality standards and regulatory compliance.
- **NGO Dashboard:**
  - Provide NGOs with a dedicated platform to verify volunteer activities, donated food, and shared resources, enhancing transparency and accountability.
- **User Roles:**
  - Users can join as volunteers or NGOs, contributing to community welfare and fostering a sense of social responsibility.

## Tech Stack

![Archtectural-diagram.png](https://i.postimg.cc/x1Xf3tBh/TECH-STACK.png)


# SpoonShare Project Implementation Overview

### Technology Stack
- Flutter: Cross-platform app development.
- Firebase: Real-time updates, user authentication, and data storage.
- Google Maps API: Efficient navigation.

### User Interface (UI) Design
- Figma: Collaborative UI/UX design.
- User-friendly interface with clear "Donate Food" and "Find Food" buttons.

### Educational Resources
- Collaboration with NGOs to provide educational content on food waste.

### Volunteer Matching
- Feature to connect willing volunteers with NGOs and events.

### Quality and Safety Standards Verification
- Establishment of guidelines for donor verification.

### Feedback and Ratings System
- System to maintain transparency and encourage user participation.

### Collaboration with Local Governments
- Partnerships with local governments for legal compliance.

### Marketing and Awareness
- Utilization of social media platforms for promotional campaigns.
- Collaboration with influencers and organizations for a wider reach.

### Post-Launch Optimization
- Regular analysis of user data for improvements and enhancements.
- Community feedback encouraged for continuous improvement.

### Community Building and Partnerships
- Robust community engagement strategy for user interaction.
- Partnerships with NGOs, local businesses, and institutions for expanded impact.

# Hi, We are InnovisionSquad! 👋


## 🚀 About me

I am from Deogiri Institute of Engineering And Management Studies Chh. Sambhajinagar and Core Team Members of [GDSC DIEMS](https://gdsc.community.dev/deogiri-institute-of-engineering-and-management-studies-aurangabad/)

- Sanika Chavan - [Sanika](https://linkedin.com/in/sanika-chavan-52457b236/)


## Happy coding 💯

Made with love from [InnovsionSquad]() ❤️
