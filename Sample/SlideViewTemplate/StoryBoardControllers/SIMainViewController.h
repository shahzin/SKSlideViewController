//
//  SIMainViewController.h
//  SlideViewTemplate
//
//  Created by Shahzin KS on 18/09/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSlideViewController.h"

@interface SIMainViewController : UIViewController<SKSlideViewDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *worthLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)didTappedRevealLeft:(id)sender;

- (IBAction)didTappedRevealRight:(id)sender;

- (void)setViewUsingDict:(NSDictionary *)aDict;

- (void)setBgColor:(UIColor *)color;

- (NSArray *)getDataSource;

@end
