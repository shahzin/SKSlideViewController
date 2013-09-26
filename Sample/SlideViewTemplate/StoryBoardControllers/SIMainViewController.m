//
//  SIMainViewController.m
//  SlideViewTemplate
//
//  Created by Shahzin KS on 18/09/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import "SIMainViewController.h"

@interface SIMainViewController ()

@property (nonatomic,copy) NSArray *dataSource;
@property (nonatomic,weak) SKSlideViewController *slideController;
@property (nonatomic,weak) NSDictionary *currentDict;
@end

@implementation SIMainViewController

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
    NSLog(@"In View Will appear");
    [self processDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)processDataSource{
    __weak SIMainViewController *weakSelf=self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Begun processing");
        NSString *dataStr=@"[{\"name\":\"Bill Gates\",\"rank\":1,\"worth\":\"$71.2 billion\",\"description\":\"Bill Gates is the man behind Microsoft, the biggest software maker in the world that is responsible for the popular Windows operating system. He owns 4.8 percent of the company. He also has a stake in Cascade Investment. He is also the largest shareholder of the biggest railroad company in Canada. Additionally, he has interests in energy through Sapphire Energy, photography through Corbis Images, and real estate through the Four Seasons Hotels. He established the Bill and Melinda Gates Foundation for charitable causes. His wealth has increased by 16.1 percent since the start of the year.\",\"image\":\"b1.jpg\"},{\"name\":\"Carlos Slim\",\"rank\":2,\"worth\":\"$66.8 billion\",\"description\":\"Carlos Slim is the richest man in Mexico and in the world. He has interests in telecommunications through America Movil; banking through Inbursa; and mining through Minera Frisco. He also has investments in the construction industry. He has shares in Caixabank, the New York Times, Philip Morris and Saks. He also has a stake in YPF, an oil company based in Argentina. His net worth has gone down by 2.7 percent since the start of the year.\",\"image\":\"b2.jpg\"},{\"name\":\"Warren Buffett\",\"rank\":3,\"worth\":\"$60.2 billion\",\"description\":\"Warren Buffett is the Chairman and Chief Executive officer of the publicly traded holding company called Berkshire Hathaway. The company has a broad and diversified line of business with investments in energy through Lubrizol and MidAmerican Energy; insurance through Geico; manufacturing through Clayton Homes; and service through NetJets. It also has shares in companies like American Express, Coca-Cola, Procter & Gamble, and Wells Fargo. He is one of the movers behind The Giving Pledge.  His net worth has increased by 25.8 percent since the start of the year.\",\"image\":\"b3.jpg\"},{\"name\":\"Amancio Ortega\",\"rank\":4,\"worth\":\"$57.3 billion\",\"description\":\"Amancio Ortega is the richest man in Spain. He owns 59 percent of the largest clothing retailer in the world called Inditex. The company also owns the fashion chain called Zara. It also controls other brands like Pull & Bear, Bershka, Massimo Dutti and Stradivarius. He has invested most of his dividend income in real estate, acquiring properties in the major cities of Spain, the United States and all over Europe. His net worth has actually gone down by 0.3 percent since the start of the year.\",\"image\":\"b4.jpg\"},{\"name\":\"Ingvar Kamprad\",\"rank\":5,\"worth\":\"$56.5 billion\",\"description\":\"Ingvar Kamprad is the richest man in Sweden. He controls the largest furniture retailer in the world called Ikea. He is also part of his family’s investment vehicle called the Ikano Group, which owns four Ikea franchises in Asia, a credit card business and several investments in real properties. He used to be a member of a local Nazi party during World War II, a fact that he now regrets. He lived in Switzerland for 40 years to escape the progressive taxes of his native Sweden before coming back in June 2013. His net worth has grown by 31.8 percent since the start of the year.\",\"image\":\"b5.jpg\"}]";
        
        NSArray *datas=(NSArray *)[NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];

        NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
        weakSelf.dataSource=[datas sortedArrayUsingDescriptors:@[descriptor]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setInitialView];
        });
    });
}

- (NSArray *)getDataSource{
    return self.dataSource;
}

-(void)setInitialView{
    if([self.dataSource count]>0){
        NSDictionary *dict=[self.dataSource objectAtIndex:0];
        [self setViewUsingDict:dict];
    }
}

-(void)setViewUsingDict:(NSDictionary *)aDict{
    self.currentDict=aDict;
    NSString *name=[aDict objectForKey:@"name"];
    NSString *worth=[aDict objectForKey:@"worth"];
    NSString *description=[aDict objectForKey:@"description"];
    NSString *imageName=[aDict objectForKey:@"image"];
    
    [self.imageView setImage:[UIImage imageNamed:imageName]];
    [self.nameLabel setText:name];
    [self.worthLabel setText:worth];
    [self.descriptionLabel setText:description];
    
    CGSize size=[description sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(self.descriptionLabel.bounds.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame=self.descriptionLabel.frame;
    frame.size=size;
    
    [self.descriptionLabel setFrame:frame];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, frame.origin.y+frame.size.height+20)];
}

-(void)setBgColor:(UIColor *)color{
    [self.view setBackgroundColor:color];
}


- (IBAction)didTappedRevealLeft:(id)sender {
    if([self.slideController isActive]){
        [self.slideController revealLeftContainerViewAnimated:YES];
    }else{
        [self.slideController showMainContainerViewAnimated:YES];
    }
}

- (IBAction)didTappedRevealRight:(id)sender {
    if([self.slideController isActive]){
        [self.slideController revealRightContainerViewAnimated:YES];
    }else{
        [self.slideController showMainContainerViewAnimated:YES];
    }
}


#pragma mark -
#pragma mark Slide Controller Delegate
#pragma mark -

-(void)setSKSlideViewControllerReference:(SKSlideViewController *)aSlideViewController{
    self.slideController=aSlideViewController;
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setNameLabel:nil];
    [self setWorthLabel:nil];
    [self setDescriptionLabel:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(@"Will Rotate");
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [UIView setAnimationsEnabled:NO];
    [self setViewUsingDict:self.currentDict];
    [UIView setAnimationsEnabled:YES];
}

@end
