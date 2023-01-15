# Early bird - Stay awake using Cosinuss° One

For the KIT module "Mobile Computing and Internet of Things" (https://teco.edu/education-mociot/), we got the exercises to build a creative mobile app for Cosinuss° One sensors based on https://github.com/teco-kit/cosinuss-flutter.
I got the idea to build an app that detects when you fall asleep and wakes you up so that you stay awake in early lectures.

My Bluetooth LE part for comminucating with the sensor can be found here: https://github.com/cadivus/cosinuss-flutter-lib-with-emulator/
and is used for this project. The other repository contains an emulator for Cosinuss° One.

## Use the emulator

For using the emulator, you have to start your application with  
`flutter run --dart-define=COSINUSS_EMULATOR_MODE=true` or  
`flutter run --dart-define=COSINUSS_EMULATOR_MODE=true --dart-define=COSINUSS_EMULATOR_HOST=your-host`

The emulator UI can be found here: https://github.com/cadivus/cosinuss-flutter-lib-with-emulator/tree/main/cosinuss_emulator

## The app in action

### Connect to Cosinuss° One and start

<img src="https://user-images.githubusercontent.com/51089187/212564757-9f3cd09d-88dc-4981-b89c-7577fbeca795.png" width="250px">    <img src="https://user-images.githubusercontent.com/51089187/212564759-a31f8f8e-fcb3-441e-a3b9-f1bf70223489.png" width="250px">    <img src="https://user-images.githubusercontent.com/51089187/212564764-c93dde4d-1abc-4371-9172-fd555dc48d14.png" width="250px">



### When you fell asleep

Your phone will begin to vibrate and show a pulsating alarm clock you have to press.

<img src="https://user-images.githubusercontent.com/51089187/212564854-5435ac85-6de0-4d73-a3ca-a3de79096b48.png" width="250px">    <img src="https://user-images.githubusercontent.com/51089187/212564860-6bc56ded-760d-4906-af8a-f5dad9f03925.png" width="250px">    <img src="https://user-images.githubusercontent.com/51089187/212564871-b788b639-ea10-490f-bb59-172da1b07cbb.png" width="250px">



### Change settings

The thresholds for sleep detections can be changed and the new settings will be saved to your phone.

<img src="https://user-images.githubusercontent.com/51089187/212564994-42d1720f-2534-416c-9def-249fea22f114.png" width="250px">    <img src="https://user-images.githubusercontent.com/51089187/212565063-5779811f-fda1-4317-b536-2818a3805f95.png" width="250px">

