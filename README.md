# AGF Framework
Embed AGF (App Group Finder) framework in your app to debug iOS app group container.

## Setting Up
Due to the nature of how Apple implements the App Groups capability, there is no way AGF can be able to just download the source, build and run, and be able to just work with your App Groups apps. By extension, there's no way to provide a pre-build binary to do the same. The basic gist is you need to have an App Group ID, an Explicit App ID, and have all the apps linked into the same App Group for AGF to work.

To set things up, follow the below brief outline below to get AGF working with your App Groups app. *The outline is by no means comprehensive and there are a resources available on the Internet to help you through the process if you are not familiar with the iTunes Connect portal and how App Groups apps works.*

### In iTunes Connect
1. Create App Groups ID (If not already created).
1. Create App ID.
	* Add App Groups capability with App Group ID in the above step.
	* App ID Suffix must be Explicit App ID (Apple does not allow app signed with Wildcard ID to attach App Group capability).
	* Remember to enable App Group Service in App Services section.
	* You can have multiple App Groups associated to one App ID.

### In Xcode
The outline below is for creating a standalone debugging app with AGF. If you intend to embed the AGF Framework into your actual app, you should skip this section.

1. Create new Xcode project.
	* Bundle Identifier must be exactly the same as the App ID create in iTunes Connect.
	* Bundle ID is case sensitive.
	* Bundle ID can be change in project settings if you can't get it to match exactly during project creation.
1. Turn on App Groups under Capabilities section in project settings.
	* If you have setup the App ID, App Group ID in iTunes Connect and the Bundle ID in Xcode correctly, the App Groups ID will show up once the App Groups capability is turned on.
	* If you have multiple App Groups ID associated with the App ID, you will see them in the App Groups list.
	* Check the check-box for all the app groups that applies.

## Installation
The current supported way to use the AGF framework is to add it as a submodule in your project or by adding the AGF framework project into your Xcode project manually *(Help is welcome to get AGF framework project to be compatible with CocoaPods or Carthage)*.

### Installation in a Git Project as a Submodule
This section assumes you are familiar with git and how to setup a submodule. *The outline is by no means comprehensive and there are a resources available on the Internet to help you through the process if you requires help with git.*

1. Create a submodule from the AGF Framework reops in github
	* Repos URL: [AGF-Framework](https://github.com/Motileware/AGF-Framework.git "AGF-Framework")
	* Go to [AGF-Framework github page](https://github.com/Motileware/AGF-Framework "AGF-Framework github page") for details.
1. Check out the master branch for the released version or any other branch for unreleased changes you may need.

### Manual Installation
1. Download AGF Framework as a zip file from [github](https://github.com/Motileware/AGF-Framework "github")
1. Extract the AGF Framework zip and place the whole content in to your app project folder.

### Adding the AppGroupFinder Framework to the Xcode Project

1. From the Finder, drag the AGF project file (AGF.xcodeproj) into Xcode Project Navigator to add the AGF Framework to your App Groups app project.
1. In the project settings under Linked Frameworks and Libraries, click + to add the AGF Framework.
	* The AGF Framework should show up right on top of the add list under Workspace.
1. <Linking up the storyboard>


# License
AGSFinder is released under the Apache license 2.0. See LICENSE for details.
