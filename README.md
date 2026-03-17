# RecTracker

A lightweight macOS menu bar app to track your lecture and video watching progress.

## What it does

RecTracker lives in your menu bar and helps you keep track of recorded lectures or video courses you are working through. Instead of losing your place or forgetting which lectures you have already watched, you can log each one with the course name, date, and how many minutes in you stopped. When you pick up again, your progress is right there waiting.

**Key features:**
- Add lectures with a course name, optional title, date, and total duration
- Record how many minutes into each lecture you have watched using a simple slider
- Mark lectures as completed when you finish them
- See all pending lectures sorted by date, and browse completed ones separately
- Everything is saved locally — no account, no internet connection required
- Minimal footprint: lives in the menu bar, out of your way until you need it

## Requirements

- macOS 26 (Tahoe) or later
- Xcode 26 or later (to build from source)

## How to build the .app file

1. **Clone the repository**
   ```bash
   git clone https://github.com/fradane/RecTracker.git
   cd RecTracker
   ```

2. **Open the project in Xcode**
   ```bash
   open RecTracker.xcodeproj
   ```

3. **Select the target and scheme**
   - In the toolbar at the top of Xcode, make sure the scheme is set to **RecTracker** and the destination is **My Mac**.

4. **Build the app**
   - Press `Cmd + B` to build, or go to **Product → Build**.
   - To create the final `.app` file, go to **Product → Archive**, then in the Organizer window click **Distribute App → Copy App** and choose a destination folder.

   Alternatively, for a quick local build without archiving:
   - Press `Cmd + R` to build and run directly.
   - The built `.app` is located inside Xcode's derived data folder. You can find the exact path by going to **Product → Show Build Folder in Finder**.

5. **Run the app**
   - Double-click the `.app` file (or press `Cmd + R` in Xcode).
   - A video icon will appear in your menu bar. Click it to open RecTracker.

> **Note:** Because the app is not signed with an Apple Developer certificate, macOS may block it on first launch. To open it anyway, right-click the `.app` file and choose **Open**, then confirm in the dialog.
