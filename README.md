# Trunk Mate - BMW DLI Code Challenge
## The Problem: Will items fit inside a BMW trunk? 

When presented with any software problem, the first thing that comes to mind is design. I approached this challenge in what I like to call the "outside - in" approach, meaning that I designed the application focusing on the "outward" appearance and overall user experience, them moving on to the "internal" code and features that are necessary to facilitate a great user experience. 

When I first read the challenge, I began to work on a basic interface in Xcode's built in Storyboard editor, as it allows for much more rapid UI development than a programmatic interface.

### The Home Screen
For this screen, I focused on providing the user with a simple, clear, and beautiful interface that allows them to see their car immediately upon launch. Most BMW owners love their car, and so I used images throughout the application that feature the car in a studio shot and gorgeous photo. Tapping the image under “My BMW” will bring the user to the next screen I designed. 

### The Car Picker Screen
The next screen I designed was nothing special, just a simple table view that allows the user to select their model from a collection view up top, that in a final app setting would “snap” to reflect the selection of the user. In this contact, I put the model as “P”, indicating “prototype”. In the production app, this would be omitted. 

### The AR Experience
After designing a basic UI/UX that allows the user to select their specific model of BMW, I began work using ARkit and the SceneKit editor. My first thought was to place an AR trunk on a surface, that would require the user to stack whatever boxes they are contemplating fitting inside on the floor, and the application would then project the trunk next to the items. However, on Saturday, two days before the assignment was due, I thought of another approach that I could have taken. I have detailed my thoughts under the heading “Alternate Approaches”. 

In order to place the trunk in AR space, it was necessary to configure ARkit to search for horizontal planes. I had never worked with this configuration before, as my previous app AR Orbits did not require it. During my research, I found this [guide by Apple]( https://developer.apple.com/documentation/arkit/placing_objects_and_handling_3d_interaction) that gave a description of how to use a “Focus Square”, which allows the user to preview where the model will go in the augmented world. 



After implementing the focus square, I began constructing the various trunk models using the dimensions provided programmatically. However, this approach turned out to be painstakingly slow and unstable. I figured there had to be a better and faster way, so I stumbled upon [this tutorial](https://www.youtube.com/watch?v=oAj9hKyeyrk) which gave the knowledge necessary to construct a 3-D model of the trunks in SceneKit, to be used in ARKit. 

## Next Steps 
Due to the time constraints of this project, I didn’t get a chance to implement all the features I would want to see in an app like this. I had begun work on opening the seats to give more room, but this was on Sunday, one day before this project was due, so I commented several TODO’s in the code, where I would continue working if given more time. 

## Alternate Approaches
In a team setting, I like to fully flush out the design and features required prior to writing a single line of code. Mistakes in the production phase are costly and time consuming, so the more work a team can do up front to prevent these issues, the better.

While working on this challenge, there were several features you listed as inspiration. I prioritized design and user experience, because I believe that most features can be built with time, but the user experience must be great from the start, as this is what the users see – they don’t care about what fancy engineering or code wizardry is or is not contained within the app. The only thing they care about is if it works and is easy to use. 

If I were to take a more engineering centered approach, I would have designed a simple interface that allows the user to enter a box of size, whereby the enter the x, y, and z dimensions of a box they are attempting to fit inside their trunk. The app would then build the trunk, and place a virtual box of the same size that the user entered in the previous screen 

## Known Issues 
The issue with my solution is that of occlusion. When the user places the boxes on the floor, the app has trouble figuring out what is and isn’t behind the augmented content projected. The use case for this would be to see if any part of the box is “stick out” of the AR trunk, which indicates to the user that the box will not fit inside the trunk.  In fact, occlusion is a very big issue in AR in general, as apparent by Apple only having recently demonstrated human occlusion at WWDC19. This is a problem that I can comfortably say is beyond my abilities at the moment but given the time and resources to figure it out, I can say I will eventually come up with a solution. But to do so in a week was exceptionally difficult for me. 

## In conclusion
To me, the most challenging part was picking which features to implement. I couldn’t do them all in the span of a week, so I went with my first idea of scanning the floor and placing a trunk on it. This is why I can’t stress enough that I prefer to fully flush out exactly what is needed prior to coding, so I don’t run into the issue I had with this challenge; which was discovering an alternate and perhaps better method of solving the problem of seeing if a user can fit items inside their trunk. 

