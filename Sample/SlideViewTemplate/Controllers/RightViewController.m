//
//  RightViewController.m
//  SlideViewTemplate
//
//  Created by Shahzin KS on 18/07/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@property (nonatomic,weak) SKSlideViewController *slideController;

@end

@implementation RightViewController

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
    self.slideController=aSlideViewController;
    NSLog(@"Here in right");
}

@end
