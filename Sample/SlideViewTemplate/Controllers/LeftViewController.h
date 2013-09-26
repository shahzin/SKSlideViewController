//
//  LeftViewController.h
//  SlideViewTemplate
//
//  Created by Shahzin KS on 18/07/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSlideViewController.h"

@interface LeftViewController : UIViewController<SKSlideViewDelegate>{
    
}

@property (nonatomic,weak) SKSlideViewController *slideController;

@end
