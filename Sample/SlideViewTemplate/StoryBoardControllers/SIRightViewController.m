//
//  SIRightViewController.m
//  SlideViewTemplate
//
//  Created by Shahzin KS on 18/09/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import "SIRightViewController.h"
#import "SIPCell.h"
#import "SIMainViewController.h"

@interface SIRightViewController ()

@property(nonatomic,weak) SKSlideViewController *slideController;
@property (nonatomic,weak) NSArray *dataSource;

@end

@implementation SIRightViewController


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

-(void)dealloc{
    NSLog(@"in right dealloc");
}


#pragma mark -
#pragma mark Table View Delegate / DataSource
#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *dict=[self.dataSource objectAtIndex:indexPath.row];
    
    SIPCell *aCell=(SIPCell *)cell;
    [aCell.title setText:[dict objectForKey:@"name"]];
    [aCell.subtitle setText:[dict objectForKey:@"worth"]];
    [aCell.cellImageView setImage:[UIImage imageNamed:[dict objectForKey:@"image"]]];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[self.dataSource objectAtIndex:indexPath.row];
    SIMainViewController *mainController=(SIMainViewController *)[self.slideController getMainViewController];
    [mainController setViewUsingDict:dict];
    [self.slideController showMainContainerViewAnimated:YES];
}

#pragma mark -
#pragma mark Slide Delegate
#pragma mark -

-(void)setSKSlideViewControllerReference:(SKSlideViewController *)aSlideViewController{
    self.slideController=aSlideViewController;
    self.dataSource=[(SIMainViewController *)[self.slideController getMainViewController] getDataSource];
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
