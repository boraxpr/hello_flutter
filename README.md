# my_first_flutter_app (<https://codelabs.developers.google.com/> )

## Tutorial version

![](/screenshots/1d26af443561f39c.gif)

## My version (Added : From NavigatorRail to ButtomNavigatorBar, Camera, ElevatedButton, Remove Favorite Button)

![My First Flutter App Demo GIF](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNDk4ZDkxMDkwYWU2MmIxMGM5ZDc3YWI0YmMyZTQxZmIwMTYxZTRmNiZjdD1n/6EEWZPCyH25v1q9mZl/giphy-downsized-large.gif)\
Once upon a time, I let GitHub Copilot (OpenAI) teach me Flutter.\
It began with me trying to understand a Flutter code architecture.\
Tutorials after tutorials, they only provide code with no deep explanation of what each part does.\
Following Codelabs ( <https://codelabs.developers.google.com/> ),I decided to spin up a very basic Flutter app (Flutter Demo) and let Copilot explains to me in the comments.

## Learn

- I understand about widgets that is each parts of Flutter components is a widget. \
There are 2 types of widgets ie. stateless and stateful widgets. \
A stateless widget is static and the only way to change them is through manually updates by making use of ChangeNotifier. \
In contrast, Stateful widget is dynamic and is the best way to update variables, widgets. \
- Nullable, late init variables.
- Commonly used widgets.
- Multiple pages app.
- Responsive app.

## Added Features

### 1. Camera Preview

### 2. Take a picture

!['Feature: Take a picture'](/screenshots/Screenshot_1681803427.png)

### 3. Detect when there is no camera available (In iOS simulator, there is no camera testing capabilities i.e. availableCamera = 0)

!['Feature: Detect Camera Unavailability'](/screenshots/Screenshot_1681803285.png)

### GitHub Copilot teacher
- Widgets are the building blocks of a Flutter app.
- In Flutter, almost everything is a widget, including alignment, padding, and layout.
- Widgets are immutable, meaning that their properties can’t change—all values are final.
- Widgets are used to build everything in Flutter, from the smallest icon to the largest screen.
- Widgets are the basic building blocks of a Flutter app’s user interface and they form a hierarchy based on composition.
- This hierarchy is called the widget tree.
- Each widget nests inside its parent and receives context from the parent.
- Widgets can be stateful or stateless.
- A stateless widget is drawn to the screen and is never redrawn.
- A stateful widget can change dynamically, for example by animating a property in response to user input.
- When the state of a widget changes, the widget rebuilds its user interface by calling the build method.
- The framework then compares the new version of the widget tree to the previous version and determines the minimum changes needed in the underlying render tree to ensure that the user interface reflects the changes.
- The framework then updates the render tree, which results in visual changes on the device.
- The widget tree is a lightweight object that can be easily discarded and regenerated, but the render tree is a heavy object that requires a lot of processing to build and update.
- The framework optimizes the build process by caching the render tree. When the widget tree is rebuilt, the framework compares the new version of the widget tree to the previous version and determines what has changed.
- The framework then updates the render tree accordingly, without having to go through the heavy process of calculating the changes.
- Then, when the user interacts with the app, the framework handles the interaction by scheduling a new frame for the UI, which causes the framework to rebuild the widget tree in the zone where the interaction occurred.

### Revision 1 (19-Oct-23) : Add Biometric (Local Auth)
![image](https://github.com/boraxpr/hello_flutter/assets/43258373/90ec4d14-57bd-4b92-8e0d-c864acd646a8)

#### Knowledge gained
- Warning "Don't use 'BuildContext's across async gaps
  - I came across the issue by trying to Navigator.push(context,route); Change the page
  - I learn that I should not pass BuildContext into function. Instead, I should work on page route in Widget build() then wrap it with context.mounted check.
main.dart; @line 111-119
```
bool isAuthenticated = await _authenticate();
if (isAuthenticated) {
  if (context.mounted) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyApp(camera: widget.camera)));
  }
}
```
- I learn about FutureBuilder. It's possible to capture Future variable (Async function) and also snapshot instance of the variable in-action while asyncing.
```
icon: FutureBuilder<bool>(
  future: _authenticate(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else {
      return Icon(
        snapshot.data == true ? Icons.lock_open : Icons.lock,
      );
    }
  },
)
```

TODOS : Build iOS/ Due a large gap in iOS version 11-17, many function of dependencies are now deprecated and must be updated to successfully build. 
