//
//  SSLeftViewController.h
//  SlideViewTemplate
//
//  Created by Shahzin KS on 20/09/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSlideViewController.h"

@interface SSLeftViewController : UIViewController<SKSlideViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
