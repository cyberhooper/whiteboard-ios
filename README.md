# Whiteboard iOS

Whiteboard is Fueled's standard starting project for photo sharing platforms.
It is basically Parse's [Anypic](https://www.anypic.org/), but decoupled from Parse.
It features uploading picture, comments, likes and followers. 
It was meant to be modular and easy to modify. Whiteboard comes with a data source/database built with Parse, but it can be modified or extended to use other backend services (such as a custom backend) or other methods of data storage (such as Core Data).

## Getting Started

- Get the project on your machine

        git clone git@github.com:Fueled/whiteboard-ios-2.git
    
- Install pods

        pod update

If you don't have Cocoapods installed on your machine, follow the installation here : http://cocoapods.org/


- Open Whiteboard.xcworkspace

- Launch the iPhone test App called "WBAnypic" and you're all set!


## Documentation

### Backend Customization

The overall idea behind whiteboard is to have a template "white label" social app customizable at will, to speed up development process.
Anypic is great as a starting point, but it has a huge drawback : it is strongly coupled with Parse.

The goal of Whitebaord is to address this main concern, by "decoupling" Anypic from parse.
Indeed the View Controllers in WBAnypic are not linked to Parse directly anymore. Instead, they call abstract methods on Whiteboard's framework.


Whiteboard is shipped by default with a Parse Implementation, but it's up to you to add your own implementation using a custom backend or another third party service.


### UI Customization

Another Problem addressed by Whiteboard is the Interface customization.
Indeed If you want to change a color or a font in Anypic, you need to go and change it in every single place in code.
Thanks to Whiteboard, changing a font, a color or an image is as simple as changing an entry in the WBTheme.plist.

## Using default Parse implementation

- First and foremost you are strongly encouraged to check out the [Parse cloud code tutorial](https://www.parse.com/docs/cloud_code_guide).

- Then you can Install parse tools 

        curl -s https://www.parse.com/downloads/cloud_code/installer.sh | sudo /bin/bash

- Navigate to the cloud code folder : whiteboard-ios-2/Examples/WBCloudCode/cloud

- To deploy the Cloud code just run :

        parse deploy



Enjoy :)


