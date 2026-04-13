# Task Manager App

A simple Flutter task management app that uses Firebase Firestore for real-time data storage. Users can create, complete, search, and delete tasks with a clean and responsive UI.

---

## Features

### Core Features
- Add new tasks
- Mark tasks as completed
- Delete tasks with confirmation
- Real-time updates using Firestore streams

---

## Enhanced Features

### 1. Real-Time Search / Filter
Users can search tasks by title using the search bar.

- Filters update instantly as the user types
- Case-insensitive matching
- Displays "No matching tasks found" when no results exist

**Why**  
Improves usability by helping users quickly find tasks in large lists.

**Limitations**
The adding task bar doesn't reset after adding a new task, so user needs to delete the bar manually.
The filter wasn't added, so only the search bar is available to search for the task

---

### 2. System-Based Dark Mode
The app automatically adapts to the device’s theme.

- Uses `ThemeMode.system`
- Switches between light and dark mode automatically
- No manual toggle required

**Why** 
Provides better user experience and accessibility without extra user effort.

**Limitations**
Since the dark/light mode is based on the emulator's theme, the user should change the light to dark mode on their emulator in the setting first in order to test the dark mode. Having a light/dark toggle inside the app would be easier to test the dark mode, but it will require more coding to do so.
---

## Setup Instructions

1. Clone the repo from my github link
2. Open Android Studio
3. Find "Device Manager" tab and select one emulator
4. Click on "3 dot" icon and select "Wipe Data"
5. Run that emulator and run using flutter run
6. On the "Adding task" bar, add one task, user wants to do, and click "Add" to add it
7. After adding a task, the task will be shown on the screen
8. Click on the checkbox to check/uncheck the task the user has finished
9. Click "bin" icon to delete a task, and the confirmation message is shown before officially delete a task
10. Type the task name in the search bar to find the tasks that match the name

* Note: Since the dark/light mode is based on the emulator's theme, the user should change the light to dark mode on their emulator in the setting first in order to test the dark mode.
1. On the emulator home screen, find the search bar (google search on medium phone api 36)
2. Type "Setting" and click it
3. In the Setting menu, either use a search bar or manual find the "Display and touch" tab
4. Click in that tab to find the light/dark theme button on the emulator
5. Switch light to dark theme to experience dark mode of the task manager app
