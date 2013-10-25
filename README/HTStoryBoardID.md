SKSlideViewController
=========

**SKSlideViewController** is an easy to use, slide-to-navigate view controller for ios 6.0 +. It enables you to present a main view controller and an optional, direction-sensitive accessory view controller. It is easy to setup and modify.


###How To (Using Storyboard IDs)

1. Create A New Project (Sample)

	![Alt text](/HTStoryBoardIDSCR/sc1.jpg?raw=true)

2. Import **SKSlideViewController** to the project

	![Alt text](/HTStoryBoardIDSCR/sc2.png?raw=true)
	
	![Alt text](/HTStoryBoardIDSCR/sc3.jpg?raw=true)

3. In the storyboard add 4 View Controllers.
**SKSlideViewController**,**MainViewController**, **LeftViewController** and **RightViewController**

4. Set the the custom class of one of the controller to **SKSlideViewController**.

	![Alt text](/HTStoryBoardIDSCR/sc4.jpg?raw=true)

5. Add Storyboard ID of the MainViewController, LeftViewController and RightViewController to **MainVC**, **LeftVC** and **RightVC** respectively.
	
	![Alt text](/HTStoryBoardIDSCR/sc5.jpg?raw=true)

6. Create a modal segue from InitialViewController(SAViewController) to SKSlideViewController and name it as **SlideVC**.
	
	![Alt text](/HTStoryBoardIDSCR/sc6.jpg?raw=true)

7. In the InitialViewController's implementation file add the following method.

		-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
		    if([segue.identifier isEqualToString:@"SlideVC"]){
		        SKSlideViewController *slideController=(SKSlideViewController *)[segue destinationViewController];
		        [slideController setStoryBoardIDForMainController:@"MainVC" leftController:@"LeftVC" rightController:@"RightVC"];
		        [slideController reloadControllers];
		    }
		}

8. Test and run the code. You could see MainViewController which can be slided to left and right to reveal LeftViewController and RightViewController.

9. Next see implementing **[SKSlideViewDelegate](HTSKSlideViewDelegate.md)**
