SKSlideViewController
=========

**SKSlideViewController** is an easy to use, slide-to-navigate view controller for ios 6.0 +. It enables you to present a main view controller and an optional, direction-sensitive accessory view controller. It is easy to setup and modify.


###Implementing SKSlideViewDelegate


Now the connections have been made between the **SKSlideViewController** and the accessory view controllers. The next task is initiating communication between the connected view controllers. To achieve this the View controllers must implement **SKSlideViewDelegate** protocol.

In the following tutorial we will add two buttons to MainViewController on click of which will reveal the LeftViewController and RightViewController.

1. Create new UIViewController subclass for MainViewController, LeftViewController and RightViewController.

	![Alt text](/HTSKSlideViewDelegateSCR/sc1.jpg?raw=true)

	![Alt text](/HTSKSlideViewDelegateSCR/sc2.jpg?raw=true)

2. Implement **SKSlideViewDelegate** protocol.

	![Alt text](/HTSKSlideViewDelegateSCR/sc3.jpg?raw=true)

3. Override 

		-(void)setSKSlideViewControllerReference:(SKSlideViewController *)aSlideViewController{
			self.slideController=aSlideViewController;
		}
	to get hold of SKSlideViewController reference.

4. Add two buttons to MainViewController. Set its title as "Left" and "Right".

	![Alt text](/HTSKSlideViewDelegateSCR/sc4.jpg?raw=true)

5. Implement an action for touch up inside event for the "Left" button in MainViewController and add the following code to that method.

	![Alt text](/HTSKSlideViewDelegateSCR/sc5.png?raw=true)

		- (IBAction)didTappedLeftButton:(id)sender {
		    if(self.slideController.isActive){
		        [self.slideController revealLeftContainerViewAnimated:YES];
		    }else{
		        [self.slideController showMainContainerViewAnimated:YES];
		    }
		}

6. Implement an action for touch up inside event for the "Right" button in MainViewController and add the following code to that method.

	![Alt text](/HTSKSlideViewDelegateSCR/sc6.png?raw=true)

		- (IBAction)didTappedRightButton:(id)sender {
		    if(self.slideController.isActive){
		        [self.slideController revealRightContainerViewAnimated:YES];
		    }else{
		        [self.slideController showMainContainerViewAnimated:YES];
		    }
		}
       
7. Build and run the code. Now we can tap the "Left" button on the MainViewController to reveal the LeftViewController and "Right" button to reveal the RightViewController.

8. To initiate communication between MainViewController, LeftViewController and the RightViewController, we could make use of the SKSlideViewController reference. 
eg. To send a message from LeftViewController to MainViewController

		SAMainViewController *mainController=[self.slideController getMainViewController];
    	[mainController someMethod:someDataFromLeftViewController];

