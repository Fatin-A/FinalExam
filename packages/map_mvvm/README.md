# MAP MVVM

## Features

Simplified version  of the implementation of MVVM architectural pattern for the course Mobile Application Programming that I teach

## Installation

Copy the package zip file and extract to your consumer project (i.e., Flutter project) to a dedicated folder for example under the folder called packages (this folder is the same level as your project `lib` folder).

You should have the following folder structure:

```console
[<Your_FlutterProject>]
       |
       |---[android]
       |---[ios]
       |---[lib]
       |---pubspec.yaml
       |---[packages]
          | 
          |---[packages]
               | 
               |---[map_mvvm]
```

Then in your project pubspec.yaml, add

```console
dependencies:
  flutter:
    sdk: flutter

  map_mvvm:
    path: packages/map_mvvm
```