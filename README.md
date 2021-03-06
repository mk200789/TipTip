# Pre-work - TipTip

TipTip is a tip calculator application for iOS.

Submitted by: Wan Kim Mok

Time spent: 5 hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] User can change the default color theme of the app.
- [x] Add the ability to set how many people will split the bill and providing the amount each person has to pay
- [x] Add App Icon from [Icon Finder](https://www.iconfinder.com/icons/1055102/calculation_calculator_math_mathematics_icon#size=512)
## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://github.com/mk200789/TipTip/blob/master/extra/tiptipdemo.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Project Analysis

As part of your pre-work submission, please reflect on the app and answer the following questions below:

**Question 1**: "What are your reactions to the iOS app development platform so far? How would you describe outlets and actions to another developer? Bonus: any idea how they are being implemented under the hood? (It might give you some ideas if you right-click on the Storyboard and click Open As->Source Code")

**Answer:** 
I enjoy using the iOS app development platform, it's easy to understand and use. I would describe outlets and actions to another developer as:
* _Outlets are linkage between the UI elements in the storyboard and the viewcontroller that allows you to change the properties of that element
* _Actions are event listeners that listen to changes of the UI element and pass message to the viewcontroller. It's a method that once trigger it performs an action.

Question 2: "Swift uses [Automatic Reference Counting](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID49) (ARC), which is not a garbage collector, to manage memory. Can you explain how you can get a strong reference cycle for closures? (There's a section explaining this concept in the link, how would you summarize as simply as possible?)"

**Answer:** [Enter your answer here in a paragraph or two].


## License

    Copyright [2017] [Wan Kim Mok]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
