//
//  SSMainViewController.h
//  SlideViewTemplate
//
//  Created by Shahzin KS on 20/09/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSlideViewController.h"

@interface SSMainViewController : UIViewController<SKSlideViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;


- (IBAction)didTappedRevealLeftButton:(id)sender;

- (IBAction)didTappedRevealRightButton:(id)sender;

- (IBAction)didTappedExitButton:(id)sender;


-(NSArray *)getDataSource;

-(NSDictionary *)getCurrentAlbum;

-(void)setCurrentAlbumDict:(NSDictionary *)currentAlbumDict;

-(void)setViewWithSongDict:(NSDictionary *)songDict;

@end
