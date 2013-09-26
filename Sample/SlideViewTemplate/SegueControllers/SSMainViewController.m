//
//  SSMainViewController.m
//  SlideViewTemplate
//
//  Created by Shahzin KS on 20/09/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import "SSMainViewController.h"

@interface SSMainViewController ()

@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,weak) NSDictionary *currentAlbumDict;
@property (nonatomic,weak) SKSlideViewController *slideController;

@end

@implementation SSMainViewController

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

-(void)viewWillAppear:(BOOL)animated{
    [self processDataSource];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setDurationLabel:nil];
    [self setTitleLabel:nil];
    [self setArtistLabel:nil];
    [self setAlbumLabel:nil];
    [super viewDidUnload];
}

-(void)dealloc{
    [self setDataSource:nil];
    NSLog(@"Main controller deallocating");
}

-(void)processDataSource{
    NSString *dataStr=@"[{\"index\": 1, \"artist\": \"Aditya Roy Kapoor\", \"name\": \"Aashiqui 2\", \"songs\": [{\"duration\": \"4:21\", \"index\": \"1\", \"title\": \"Tum Hi Ho\", \"artist\": \"Arijit Singh\"}, {\"duration\": \"6:30\", \"index\": \"2\", \"title\": \"Sunn Raha Hai\", \"artist\": \"Ankit Tiwari\"}, {\"duration\": \"5:04\", \"index\": \"3\", \"title\": \"Chahun Main Ya Naa\", \"artist\": \"Palak Muchhal & Arijit Singh\"}, {\"duration\": \"5:06\", \"index\": \"4\", \"title\": \"Hum Mar Jayenge\", \"artist\": \"Tulsi Kumar & Arijit Singh\"}, {\"duration\": \"4:26\", \"index\": \"5\", \"title\": \"Meri Aashiqui\", \"artist\": \"Palak Muchhal & Arijit Singh\"}, {\"duration\": \"4:46\", \"index\": \"6\", \"title\": \"Piya Aaye Na\", \"artist\": \"KK & Tulsi Kumar\"}]}, {\"index\": 2, \"artist\": \"A R Rahman\", \"name\": \"Coke Studio @ MTV Season 3\", \"songs\": [{\"duration\": \"7:12\", \"index\": \"1\", \"title\": \"Zariya\", \"artist\": \"A. R. Rahman, Farah Siraj\"}, {\"duration\": \"5:25\", \"index\": \"2\", \"title\": \"Naan Yen\", \"artist\": \"A. R. Rahman & Rayhanah\"}, {\"duration\": \"7:29\", \"index\": \"3\", \"title\": \"Aao Balma\", \"artist\": \"A. R. Rahman, Ustad Ghulam Mustafa Khan\"}, {\"duration\": \"4:17\", \"index\": \"4\", \"title\": \"Ennile Maha Oliyo\", \"artist\": \"A. R. Rahman, Issrath Quadhri & Rayhanah\"}, {\"duration\": \"6:45\", \"index\": \"5\", \"title\": \"Jagaao Mere Des Ko\", \"artist\": \"A. R. Rahman, Suchi & Blaaze\"}, {\"duration\": \"5:09\", \"index\": \"6\", \"title\": \"Soz O Salaam\", \"artist\": \"A. R. Rahman, Ustad Ghulam Mustafa Khan\"}]}, {\"index\": 3, \"artist\": \"Rihana\", \"name\": \"Good Girl Gone Bad: Reloaded\", \"songs\": [{\"duration\": \"4:35\", \"index\": \"1\", \"title\": \"Umbrella (feat. Jay-Z)\", \"artist\": \"Rihanna & JAY Z\"}, {\"duration\": \"3:15\", \"index\": \"2\", \"title\": \"Push Up On Me\", \"artist\": \"Rihanna\"}, {\"duration\": \"4:27\", \"index\": \"3\", \"title\": \"Don't Stop the Music\", \"artist\": \"Rihanna\"}, {\"duration\": \"3:20\", \"index\": \"4\", \"title\": \"Breakin' Dishes\", \"artist\": \"Rihanna\"}, {\"duration\": \"3:32\", \"index\": \"5\", \"title\": \"Shut Up and Drive\", \"artist\": \"Rihanna\"}, {\"duration\": \"3:38\", \"index\": \"6\", \"title\": \"Hate That I Love You (feat. Ne-Yo)\", \"artist\": \"Rihanna & Ne-Yo\"}]}, {\"index\": 4, \"artist\": \"Linkin Park\", \"name\": \"LIVING THINGS\", \"songs\": [{\"duration\": \"3:25\", \"index\": \"1\", \"title\": \"LOST IN THE ECHO\", \"artist\": \"LINKIN PARK\"}, {\"duration\": \"3:20\", \"index\": \"2\", \"title\": \"IN MY REMAINS\", \"artist\": \"LINKIN PARK\"}, {\"duration\": \"3:50\", \"index\": \"3\", \"title\": \"BURN IT DOWN\", \"artist\": \"LINKIN PARK\"}, {\"duration\": \"2:26\", \"index\": \"4\", \"title\": \"LIES GREED MISERY\", \"artist\": \"LINKIN PARK\"}, {\"duration\": \"3:31\", \"index\": \"5\", \"title\": \"I'LL BE GONE\", \"artist\": \"LINKIN PARK\"}, {\"duration\": \"3:25\", \"index\": \"6\", \"title\": \"CASTLE OF GLASS\", \"artist\": \"LINKIN PARK\"}]}, {\"index\": 5, \"artist\": \"Akon\", \"name\": \"Freedom\", \"songs\": [{\"duration\": \"4:00\", \"index\": \"1\", \"title\": \"Right Now (Na Na Na)\", \"artist\": \"Akon\"}, {\"duration\": \"5:12\", \"index\": \"2\", \"title\": \"Beautiful\", \"artist\": \"Akon, Colby O'Donis & Kardinal Offishall\"}, {\"duration\": \"4:20\", \"index\": \"3\", \"title\": \"Keep You Much Longer\", \"artist\": \"Akon\"}, {\"duration\": \"3:57\", \"index\": \"4\", \"title\": \"Troublemaker\", \"artist\": \"Akon & Sweet Rush\"}, {\"duration\": \"4:16\", \"index\": \"5\", \"title\": \"We Don't Care\", \"artist\": \"Akon\"}, {\"duration\": \"4:20\", \"index\": \"6\", \"title\": \"I'm So Paid\", \"artist\": \"Akon, Lil Wayne & Young Jeezy\"}]}, {\"index\": 6, \"artist\": \"Madonna\", \"name\": \"Celebration\", \"songs\": [{\"duration\": \"5:36\", \"index\": \"1\", \"title\": \"Hung Up\", \"artist\": \"Madonna\"}, {\"duration\": \"3:45\", \"index\": \"2\", \"title\": \"Music\", \"artist\": \"Madonna\"}, {\"duration\": \"5:16\", \"index\": \"3\", \"title\": \"Vogue\", \"artist\": \"Madonna\"}, {\"duration\": \"3:09\", \"index\": \"4\", \"title\": \"4 Minutes\", \"artist\": \"Madonna\"}, {\"duration\": \"6:08\", \"index\": \"5\", \"title\": \"Holiday\", \"artist\": \"Madonna\"}, {\"duration\": \"4:10\", \"index\": \"6\", \"title\": \"Everybody\", \"artist\": \"Madonna\"}]}]";
    
    NSArray *dataSource=[NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    self.dataSource=dataSource;
    self.currentAlbumDict=[dataSource objectAtIndex:0];
}

#pragma mark -
#pragma mark SKSlideViewDelegate
#pragma mark -

-(void)setSKSlideViewControllerReference:(SKSlideViewController *)aSlideViewController{
    self.slideController=aSlideViewController;
}

- (IBAction)didTappedRevealLeftButton:(id)sender {
    if(self.slideController.isActive){
        [self.slideController revealLeftContainerViewAnimated:YES];
    }else{
        [self.slideController showMainContainerViewAnimated:YES];
    }
}

- (IBAction)didTappedRevealRightButton:(id)sender {
    if(self.slideController.isActive){
        [self.slideController revealRightContainerViewAnimated:YES];
    }else{
        [self.slideController showMainContainerViewAnimated:YES];
    }
}

- (IBAction)didTappedExitButton:(id)sender {
    [self.slideController dismissViewControllerAnimated:YES completion:nil];
}

-(NSArray *)getDataSource{
    return self.dataSource;
}

-(NSDictionary *)getCurrentAlbum{
    return self.currentAlbumDict;
}

-(void)setViewWithSongDict:(NSDictionary *)songDict{
    [self.titleLabel setText:[songDict objectForKey:@"title"]];
    [self.artistLabel setText:[songDict objectForKey:@"artist"]];
    [self.durationLabel setText:[NSString stringWithFormat:@"-%@",[songDict objectForKey:@"duration"]]];
}

-(void)setCurrentAlbumDict:(NSDictionary *)currentAlbumDict{
    _currentAlbumDict=currentAlbumDict;
    [self.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ai%@.jpg",[currentAlbumDict objectForKey:@"index"]]]];
    [self.albumLabel setText:[currentAlbumDict objectForKey:@"name"]];
    NSArray *songs=[self.currentAlbumDict objectForKey:@"songs"];
    [self setViewWithSongDict:[songs objectAtIndex:0]];
}

@end
