//
//  SlideViewTemplateTests.m
//  SlideViewTemplateTests
//
//  Created by Shahzin KS on 14/07/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import "SlideViewTemplateTests.h"
#import "SKSlideViewController.h"

@implementation SlideViewTemplateTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    NSUInteger styleMask=SKSlideControllerStyleRevealLeft|SKSlideControllerStyleRevealRight;
    
    NSLog(@"Testing");
    if(styleMask&SKSlideControllerStyleRevealLeft){
        NSLog(@"Left True");
    }
    if(styleMask&SKSlideControllerStateRevealedRight){
        NSLog(@"Right True");
    }
}

@end
