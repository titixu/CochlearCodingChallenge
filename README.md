#  Cochlear Coding Challenge

## Requirements
- Xcode 10.3 or above
- Swift 5 or above
- macOS 10.14.5 or above
- iOS 11.0 or above

## Assumptions and Limitations
- The product only has the minimum functionalities that fulfil the Coding Challenge requirements
- one coordinate can have a maximum one location object
- if user local storage has no location objects, locations will be loaded from server API http://bit.ly/test-locations
- Changing a location's name in Location Detail View Controller
- Locations can only be removed from the Map View Controller by tapping the "Remove" button from the Annotation Callout view

## Bugs
- Somehow, the user location indicator ( the blue dot ) is not showing in the map, but the user location is detected with no problem. 

## Product requirements 

- [x] Provide a map screen (using any map SDK of your choosing) 
- [x] Allow custom locations to be added from the map screen
- [x] Show pins for both default and custom locations on the map
- [x] Provide a screen listing all locations, sorted by distance
- [x] When locations are selected on either the map or list screen, show a detailed screen
- [x] In the detail screen, allows the user to enter notes about the location
- [x] All information entered by the user must be persisted between app launches

## Technical requirements
- [x] Unit Tests added
- [x] Load from JSON file http://bit.ly/test-locations
- [x] 2 - 4 hours
