# Project 3: Photo Social Network App

## Please open Photos.xcworkspace not Photos.xcodeproj since this project uses Cocoapods. 

## Due
Monday, November 16 at 11:59 PM

## Description
We have covered the basics of networking in iOS apps, as well as the different
elements from UIKit.  This project will combine both concepts, and result in an
app that displays photos pulled from Instagram via its public API. 

In this project, you will be parsing JSON objects to display the photos and
additional relevant information that Instagram users have posted and shared. The
purpose of this assignment is to familarize you with creating UICollectionViews,
and have you practice the iOS Networking knowledge you learned to use a
popular company's API.

## Instructions
1. Fork the assignment's repository from (https://github.com/iosdecal).
2. Clone your forked repository to your local machine (the URL should contain
   YOUR_USERNAME/ios-decal-..).
3. **Create Photo app**
  * Required
    * Photo.swift - the model which represents a single Photo object
      * You only need to implement the init
    * InstagramAPI.swift - the object which connects with the Instagram API
      * You must implement the loadPhotos method
    * PhotosCollectionViewController.swift - Collection View of Photos 
      * One photo per cell
      * You must implement any necessary delegate methods
      * You must implement loadImageForCell
    * Tapping a cell takes you to a photo-specific view  with the following:
      * UIImage of the Photo (from the URL)
      * UILabels to display:
        * The poster's username
        * The date posted
        * The number of Likes on the photo
      * A Heart button to Like the photo
        * Something in the view should change (perhaps the button?) to indicate
        whether you have Liked the photo or not
  * Optional
    * Toggle between different feeds (Popular, Photos from Berkeley, etc.)
      * Suggested: Tabbed Application
    * Enable ability to "push" to Instagram's servers (e.g. A Like that you make
            in your app is reflected on Instagram)
      * Note: Requires facilitating OAuth with Instagram's API
    * Add a Search tab so that you can search for Users, Hashtags, etc. and
    retrieve the relevant images
    * Optimize the app's performance
      * Add GCD to use background threads for smoother loading
      * Add a NSCache for the images
4. Add, commit, and push your modified file(s) to your forked remote repository.
