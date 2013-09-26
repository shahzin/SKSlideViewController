//
//  SILeftViewController.h
//  SlideViewTemplate
//
//  Created by Shahzin KS on 18/09/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSlideViewController.h"

@interface SILeftViewController : UIViewController<SKSlideViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
