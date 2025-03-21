# kite

A Flutter app for consuming [Kite](https://kite.kagi.com) news summaries.

Runs on Android, iOS/iPadOS, macOS, and web (presumably other platforms as well, but not tested).

## Features
- ⌨️ **full[^1] keyboard support** - never lift your hands from the keyboard!
- ✨ **adaptive layout** - adapts to any screen size, including foldables and tablets.
- 🔆 **theme toggle** - easily switch between light and dark modes.
- ⚙️ **no `material`/`cupertino` dependencies** - Focuses on platform-independent UI components.

Rationale for focusing on these features is that power users (which are most likely to use services like Kite) expect their software to adapt to any platform they use (including foldables or iPads with Stage Manager, where app window size can be dynamically adjusted). They are also more likely to have hardware keyboards attached to their mobile devices, prompting the need to support keyboard interactivity.

### Keybindings

| Shortcut | Action                  |
|----------|-------------------------|
| `h`/`l`  | Select next/previous category. |
| `j`/`k`  | Select next/previous content in the list. |
| `/`      | Toggle search for categories. |
| `t`      | Toggle theme (light/dark). |
| `cmd-]`  | Unselect content (go back). |

## Demo

https://github.com/user-attachments/assets/6c1fd7ee-2c2e-4363-9eb6-61ae2b3d6a61

demonstrates layout changes as the app screen is resized

https://github.com/user-attachments/assets/010e51e9-c5e7-4343-9b4f-4872d935c025

demonstrates interacting with the app via keyboard (keystrokes are displayed in the bottom right corner)

## Features skipped for simplicity's sake
- localization/internationalization (especially when it comes to semantic labels)
- accessibility accommodations past the basics
- storing any data locally, including:
    - user customization settings
    - caching most recent data for offline consumption
- more informative error messages: currently, there's really nothing a user can do when an api call fails, except try try again
- fancy animations (e.g., for page transitions) 
- custom app icon

## Next steps
- Customization
    - setting keybinding preferences (although clearly superior, vim keybindings might not be for everyone)
    - saving theme preference or adapting to system theme
- Offline support
    - storing fetched data locally (instead of in-memory), so that it is available for offline consumption
- Proper screen reader support
- Better test coverage

## Building the app
A simple `flutter run` should do the trick.

## Architecture
Since the functionality is currently essentially limited to displaying results of two API calls, the app structure reflects this simplicity.
- `KiteService` initiates API calls and caches the results in memory, only requesting new data after noon UTC (which is a checkpoint I got from Kite's intro page)
- `KiteViewModel` holds the state of the app
    - it exposes `ValueListenable`s, which are consumed by various widgets to build the UI
    - its state is modified through [`Action`s](https://docs.flutter.dev/ui/interactivity/actions-and-shortcuts) (dispatched either by keyboard shortcuts or widget onTap callbacks)
- `HomePage` builds the UI as a function of screen size

[^1]: _technically true_ if you have been blessed by a very tall display that can preview the entire `ClusterView` without the need for scrolling; support for scrolling using keyboard is comming soon™
