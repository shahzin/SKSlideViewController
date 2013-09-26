//
//  SILeftViewController.m
//  SlideViewTemplate
//
//  Created by Shahzin KS on 18/09/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import "SILeftViewController.h"
#import "SIMainViewController.h"

@interface SILeftViewController ()

@property (nonatomic,weak) SKSlideViewController *slideController;
@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation SILeftViewController

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

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    self.dataSource=@[[UIColor whiteColor],[UIColor blueColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor redColor],[UIColor grayColor]];
    [self.tableView reloadData];
}

-(void)dealloc{
    NSLog(@"Left Dealloc");
}

#pragma mark -
#pragma mark Table View Delegate/ DataSource
#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.contentView setBackgroundColor:(UIColor *)[self.dataSource objectAtIndex:indexPath.row]];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Background Colors";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIColor *color=[self.dataSource objectAtIndex:indexPath.row];
    SIMainViewController *mainController=(SIMainViewController *)[self.slideController getMainViewController];
    [mainController setBgColor:color];
    [self.slideController showMainContainerViewAnimated:YES];
}

#pragma mark -
#pragma mark SlideControllerDelegate
#pragma mark -

-(void)setSKSlideViewControllerReference:(SKSlideViewController *)aSlideViewController{
    self.slideController=aSlideViewController;
}

@end
