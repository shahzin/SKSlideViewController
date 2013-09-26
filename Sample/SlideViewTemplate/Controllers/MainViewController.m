//
//  MainViewController.m
//  SlideViewTemplate
//
//  Created by Shahzin KS on 18/07/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic,weak) SKSlideViewController *slideController;

@end

@implementation MainViewController

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

#pragma mark -
#pragma mark Slide Delegate
#pragma mark -

-(void)setSKSlideViewControllerReference:(SKSlideViewController *)aSlideViewController{
    NSLog(@"Slide Controller reference set");
    self.slideController=aSlideViewController;
}

-(void)didReceiveDataFromLeftContainer:(UIViewController *)container info:(NSDictionary *)userInfo{
    
}

-(void)didReceiveDataFromRightContainer:(UIViewController *)container info:(NSDictionary *)userInfo{
    
}


- (IBAction)didTappedRevealLeft:(id)sender {
    NSLog(@"Did tapped reveal left %@ %d",self.slideController,self.slideController.isActive);
    if([self.slideController isActive]){
        [self.slideController revealLeftContainerViewAnimated:YES];
    }else{
        [self.slideController showMainContainerViewAnimated:YES];
    }
}

- (IBAction)didTappedRevealRight:(id)sender {
    NSLog(@"Did tapped reveal right");
    if([self.slideController isActive]){
        [self.slideController revealRightContainerViewAnimated:YES];
    }else{
        [self.slideController showMainContainerViewAnimated:YES];
    }
}
@end
