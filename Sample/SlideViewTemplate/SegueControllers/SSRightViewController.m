//
//  SSRightViewController.m
//  SlideViewTemplate
//
//  Created by Shahzin KS on 20/09/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import "SSRightViewController.h"
#import "SSMainViewController.h"

@interface SSRightViewController ()

@property (nonatomic,weak) SKSlideViewController *slideController;
@property (nonatomic,weak) NSDictionary *currentAlbum;
@property (nonatomic,weak) NSArray *dataSource;

@end

@implementation SSRightViewController

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
    [self setImageView:nil];
    [self setArtistLabel:nil];
    [self setAlbumLabel:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    [self reloadData];
}

-(void)reloadData{
    SSMainViewController *mainController=(SSMainViewController *)[self.slideController getMainViewController];
    self.currentAlbum=[mainController getCurrentAlbum];
    self.dataSource=(NSArray *)[self.currentAlbum objectForKey:@"songs"];
    
    [self.artistLabel setText:[self.currentAlbum objectForKey:@"artist"]];
    [self.albumLabel setText:[self.currentAlbum objectForKey:@"name"]];
    [self.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ai%@.jpg",[self.currentAlbum objectForKey:@"index"]]]];
    
    [self.tableView reloadData];
}

-(void)dealloc{
    NSLog(@"Right controller deallocating");
}

#pragma mark - TableView Delegate/DataSource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *song=[self.dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%d %@",indexPath.row+1,[song objectForKey:@"title"]]];
    [cell.detailTextLabel setText:[song objectForKey:@"duration"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *song=[self.dataSource objectAtIndex:indexPath.row];
    SSMainViewController *mainController=(SSMainViewController *)[self.slideController getMainViewController];
    [mainController setViewWithSongDict:song];
    [self.slideController showMainContainerViewAnimated:YES];
}

#pragma mark - SKSlideViewDelegate -

-(void)setSKSlideViewControllerReference:(SKSlideViewController *)aSlideViewController{
    self.slideController=aSlideViewController;
}

@end
