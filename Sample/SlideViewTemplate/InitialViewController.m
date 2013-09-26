//
//  InitialViewController.m
//  SlideViewTemplate
//
//  Created by Shahzin KS on 02/09/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import "InitialViewController.h"
#import "SKSlideViewController.h"
#import "TestViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segue1"]){
        NSLog(@"In Perform segue");
        SKSlideViewController *controller=(SKSlideViewController *)[segue destinationViewController];
        [controller setStoryBoardIDForMainController:SK_DEFAULT_STORY_BOARD_IDENTIFIER_MAIN leftController:SK_DEFAULT_STORY_BOARD_IDENTIFIER_LEFT  rightController:SK_DEFAULT_STORY_BOARD_IDENTIFIER_RIGHT];
        [controller setVisibleWidthOfMainContainerWhileRevealingLeftContainer:60.0 rightContainer:60.0];
        [controller reloadControllers];
    }else if([segue.identifier isEqualToString:@"segue2"]){
        SKSlideViewController *controller=(SKSlideViewController *)[segue destinationViewController];
        [controller setSegueIDForMainController:SK_DEFAULT_SEGUE_IDENTIFIER_MAIN leftController:SK_DEFAULT_SEGUE_IDENTIFIER_LEFT rightController:SK_DEFAULT_SEGUE_IDENTIFIER_RIGHT];
        [controller setLoadViewControllersOnDemand:YES];
        [controller setSlideControllerStyleMask:SKSlideControllerStyleRevealLeft|SKSlideControllerStyleRevealRight];
        [controller setHasShadow:YES];
        [controller reloadControllers];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (IBAction)didTappedCodeButton:(id)sender {
    
    UIStoryboard *storyBoard=[self storyboard];
    TestViewController *mainController=[storyBoard instantiateViewControllerWithIdentifier:@"TestController"];
    TestViewController *leftController=[storyBoard instantiateViewControllerWithIdentifier:@"TestController"];
    TestViewController *rightController=[storyBoard instantiateViewControllerWithIdentifier:@"TestController"];
    
    [mainController.view setBackgroundColor:[UIColor redColor]];
    [leftController.view setBackgroundColor:[UIColor greenColor]];
    [rightController.view setBackgroundColor:[UIColor blueColor]];
    
    SKSlideViewController *controller=[[SKSlideViewController alloc] init];
    [controller setSlideViewControllerUsingMainViewController:mainController leftViewController:nil rightViewController:rightController];
    //[controller setSlideControllerStyleMask:SKSlideControllerStyleRevealLeft];
    [controller setHasShadow:YES];
    [controller reloadControllers];
    [self.navigationController pushViewController:controller animated:YES];
    
    
    mainController=nil;
    leftController=nil;
    rightController=nil;
    //To Present modally uncomment the following and remove the above line
    /*
    [self presentViewController:controller animated:YES completion:^{
        
    }];*/
}

-(void)didTappedClickButton:(id)sender{
    NSLog(@"Did tapped");
}

- (IBAction)didTappedSegueButton:(id)sender {
    [self performSegueWithIdentifier:@"segue2" sender:nil];
}
@end
