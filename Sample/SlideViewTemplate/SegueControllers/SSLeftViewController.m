//
//  SSLeftViewController.m
//  SlideViewTemplate
//
//  Created by Shahzin KS on 20/09/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import "SSLeftViewController.h"
#import "SSMainViewController.h"

@interface SSLeftViewController ()

@property (nonatomic,weak) SKSlideViewController *slideController;
@property (nonatomic,weak) NSArray *dataSource;

@end

@implementation SSLeftViewController

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

-(void)dealloc{
    NSLog(@"Left Controller Deallocating");
}


#pragma mark - Table View Delagate/DataSource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *albumDict=[self.dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:[albumDict objectForKey:@"name"]];
    [cell.detailTextLabel setText:[albumDict objectForKey:@"artist"]];
    [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ai%@.jpg",[albumDict objectForKey:@"index"]]]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *albumDict=[self.dataSource objectAtIndex:indexPath.row];
    SSMainViewController *mainController=(SSMainViewController *)[self.slideController getMainViewController];
    [mainController setCurrentAlbumDict:albumDict];
    [self.slideController showMainContainerViewAnimated:YES];
}

#pragma mark - SKSlideViewDelegate -

-(void)setSKSlideViewControllerReference:(SKSlideViewController *)aSlideViewController{
    self.slideController=aSlideViewController;
    
    //Getting the datasource reference from the main view controller
    SSMainViewController *controller=(SSMainViewController *)[self.slideController getMainViewController];
    self.dataSource=[controller getDataSource];
    [self.tableView reloadData];
}

@end
