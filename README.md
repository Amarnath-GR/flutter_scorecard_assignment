
# 🚉 Digital Score Card – Flutter App

A mobile application for station cleanliness inspection using Flutter. This replicates the "Score Card" PDF into a structured digital form.

## 📋 Features

- Station Name and Date picker
- 10 inspection parameters (score from 0 to 10)
- Optional remarks for each parameter
- Validation before submission
- Sends form data as JSON to a mock API endpoint (`https://httpbin.org/post`)

## 🛠️ Tech Stack

- Flutter & Dart
- HTTP package for API
- Material UI

## 🚀 Getting Started

```bash
git clone https://github.com/YOUR_USERNAME/flutter_scorecard_assignment.git
cd flutter_scorecard_assignment
flutter pub get
flutter run
```

## 📡 API

Data is sent as JSON to `https://httpbin.org/post` with structure:

```json
{
  "station": "Sample Station",
  "date": "2025-07-05",
  "parameters": [
    {
      "name": "Platform Cleanliness",
      "score": 9,
      "remark": "Clean and dry"
    },
    ...
  ]
}
```

## 🎬 Demo Videos

- [Form UI Demo](https://drive.google.com/yourname_scorecard_assignment_ui.mp4)
- [Technical Walkthrough](https://drive.google.com/yourname_scorecard_assignment_tech.mp4)

## 📦 Submission

Submit your code (GitHub link or ZIP) + video links to `contact@suvidhaen.com`.
