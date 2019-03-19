![Badger](assets/logo.png)

Badger is a bash script that takes a badge image and adds it on top of App Icons. 

![How it works](assets/how_it_works.png)

More information about how it works you can find in [this article](https://brainarchives.com/adding-badges-to-ios-app-icons/).

## Requirements

Badger requires `ImageMagic`. You can install it using `brew install imagemagic`.

## Instalation

Copy the `badger.sh` to your project folder.

## Usage

1. Badge icon should have:
    - size of the bigest icon in the `AppIcon.appiconset`. Right now it is `1024x1024` px.
    - transparent background.

2. Run this command in Terminal:

```
 ./badger.sh -b "/path/to/badge.png" -i "/path/to/Assets.xcassets/AppIcon.appiconset"
```

## License

Badger is released under the MIT license. See LICENSE for details.
