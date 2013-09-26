//
//  SSRightViewController.h
//  SlideViewTemplate
//
//  Created by Shahzin KS on 20/09/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSlideViewController.h"

@interface SSRightViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SKSlideViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;

@end
