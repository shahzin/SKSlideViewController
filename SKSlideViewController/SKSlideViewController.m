/**
 The MIT License (MIT)
 
 Copyright (c) 2013 Shahzin KS
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import "SKSlideViewController.h"
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, SKSlideDirection){
    SKSlideDirectionLeft=312,
    SKSlideDirectionRight,
    SKSlideDirectionNone,
};

typedef NS_ENUM(NSUInteger, SKLoadSource){
    SKLoadSourceStoryBoardIDs=412,
    SKLoadSourceStoryBoardSegues,
    SKLoadSourceCode,
};

typedef struct{
    CGFloat minX;
    CGFloat maxX;
}SKControllerBounds;


SKControllerBounds SKControllerBoundsMake(CGFloat minX,CGFloat maxX){
    SKControllerBounds controllerBounds;
    controllerBounds.minX=minX;
    controllerBounds.maxX=maxX;
    return controllerBounds;
}

#pragma mark -
#pragma mark Private Declarations
#pragma mark -

@interface SKSlideViewController ()

@property (nonatomic,weak) UIViewController *leftViewController;
@property (nonatomic,weak) UIViewController *mainViewController;
@property (nonatomic,weak) UIViewController *rightViewController;
@property (nonatomic,weak) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic) BOOL isMainControllerActive;
@property (nonatomic,strong) NSString *storyBoardName;

//Story board IDs
@property (nonatomic,copy) NSString *leftViewControllerStoryBoardID;
@property (nonatomic,copy) NSString *mainViewControllerStoryBoardID;
@property (nonatomic,copy) NSString *rightViewControllerStoryBoardID;


//Segue IDs
@property (nonatomic,copy) NSString *leftViewControllerSegueID;
@property (nonatomic,copy) NSString *mainViewControllerSegueID;
@property (nonatomic,copy) NSString *rightViewControllerSegueID;

@property (nonatomic) BOOL slidesOnPanGesture;
@property (nonatomic) BOOL hasShadow;
@property (nonatomic) CGFloat panEndVelocity;

@property (nonatomic) SKLoadSource loadSource;
@property (nonatomic) SKSlideDirection currentSlideDirection;
@property (nonatomic) SKSlideControllerStyle controllerStyleMask;

@property (nonatomic) BOOL hasIdentifiedPanDirection;
@property (nonatomic) BOOL loadsOnDemand;
@property (nonatomic) SKControllerBounds currentControllerBounds;


@property (nonatomic) CGFloat mainControllerVisibleWidthWhileLeftControllerRevealed;
@property (nonatomic) CGFloat mainControllerVisibleWidthWhileRightControllerRevealed;

-(void)loadControllersMainViewController:(UIViewController<SKSlideViewDelegate> *)mainViewController leftViewController:(UIViewController<SKSlideViewDelegate> *)leftViewController rightViewController:(UIViewController *)rightViewController;

@end

#pragma mark -
#pragma mark Implementation
#pragma mark -

@implementation SKSlideViewController{
    BOOL hasLoaded;
    
    //Only if loaded via segue
    BOOL hasLoadedLeftView;
    BOOL hasLoadedRightView;
    
    //To 
    BOOL canAcquireVisibleWidthFromAccessoryView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initialiseToSourceCodeDefaults];
    }
    return self;
}

-(id)init{
    self=[super init];
    if(self){
        [self initialiseToSourceCodeDefaults];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        
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

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)dealloc{
    [self removePanGestureFromMainView];
    [self forceUnloadViewControllers];
    
    _storyBoardName=nil;
    _mainViewControllerStoryBoardID=nil;
    _mainViewControllerSegueID=nil;
    
    _leftViewControllerStoryBoardID=nil;
    _leftViewControllerSegueID=nil;
    
    _rightViewControllerStoryBoardID=nil;
    _rightViewControllerSegueID=nil;
}

#pragma mark -
#pragma mark Initializers
#pragma mark -


-(void)initialiseToDefaults{
    //Read only properties : using ivars
    _slideControllerState=SKSlideControllerStateRevealedNone;
    
    self.slidesOnPanGesture=YES;
    self.hasIdentifiedPanDirection=NO;
    self.loadsOnDemand=YES;
    self.hasShadow=NO;
    self.currentSlideDirection=SKSlideDirectionNone;
    self.panEndVelocity=SK_DEFAULT_PAN_END_VELOCITY;
    
    self.isMainControllerActive=YES;
    
    //Reveals both left and right controllers
    self.controllerStyleMask=SKSlideControllerStateRevealedNone;
    
    self.mainControllerVisibleWidthWhileLeftControllerRevealed=SK_DEFAULT_VISIBLE_WIDTH_WHILE_REVEALED;
    self.mainControllerVisibleWidthWhileRightControllerRevealed=SK_DEFAULT_VISIBLE_WIDTH_WHILE_REVEALED;
    
}

-(void)initialiseToSourceStoryBoardIDsDefaults{
    [self initialiseToDefaults];
    //Story Board IDS
    self.loadSource=SKLoadSourceStoryBoardIDs;
    self.storyBoardName=SK_DEFAULT_STORY_BOARD_NAME;
    self.leftViewControllerStoryBoardID=SK_DEFAULT_STORY_BOARD_IDENTIFIER_LEFT;
    self.rightViewControllerStoryBoardID=SK_DEFAULT_STORY_BOARD_IDENTIFIER_RIGHT;
    self.mainViewControllerStoryBoardID=SK_DEFAULT_STORY_BOARD_IDENTIFIER_MAIN;
}

-(void)initialiseToSourceSeguesDefaults{
    [self initialiseToDefaults];
    //Segues Identifier Defaults
    self.loadSource=SKLoadSourceStoryBoardSegues;
    self.mainViewControllerSegueID=SK_DEFAULT_SEGUE_IDENTIFIER_MAIN;
    self.leftViewControllerSegueID=SK_DEFAULT_SEGUE_IDENTIFIER_LEFT;
    self.rightViewControllerSegueID=SK_DEFAULT_SEGUE_IDENTIFIER_RIGHT;
}

-(void)initialiseToSourceCodeDefaults{
    [self initialiseToDefaults];
    self.loadSource=SKLoadSourceCode;
    self.loadsOnDemand=NO;
}


-(void)loadControllers{
    [self loadMainViewController];
}

-(void)unloadControllers{
    [self unloadAccessoryViewControllers];
    [self unloadMainViewController];
}

#pragma mark -
#pragma mark Utilities
#pragma mark -

-(UIView *)getMainControllerView{
    if(self.loadSource==SKLoadSourceStoryBoardSegues){
        if(self.mainViewController){
            if([self.view.subviews containsObject:self.mainViewController.view]){
                return self.mainViewController.view;
            }
            return self.mainViewController.view.superview;
        }
        return nil;
    }else{
        return self.mainViewController.view;
    }
}

-(void)addShadow:(BOOL)shouldAdd{
    if(shouldAdd){
        if(self.hasShadow){
            UIView *view=[self getMainControllerView];
            CALayer *layer=[view layer];
            [layer setShadowPath:[UIBezierPath bezierPathWithRect:layer.bounds].CGPath];
            [layer setShadowColor:[UIColor blackColor].CGColor];
            [layer setShadowOffset:CGSizeMake(0, 4)];
            [layer setShadowOpacity:0.80];
        }
    }else{
        UIView *view=[self getMainControllerView];
        CALayer *layer=[view layer];
        [layer setShadowPath:nil];
        [layer setShadowOpacity:0.0];
        [layer setShadowColor:[UIColor clearColor].CGColor];
        [layer setShadowOffset:CGSizeMake(0.0f,0.0f)];
    }
}

-(void)rasterizeMainControllerView:(BOOL)rasterize{
    if(rasterize){
        [self addShadow:YES];
        [[self getMainControllerView].layer removeAllAnimations];
    }else{
        if(self.isMainControllerActive){
            [self addShadow:NO];
        }
    }
//    if(rasterize){
//        [self addShadow:YES];
//        [[self getMainControllerView].layer setRasterizationScale:[[UIScreen mainScreen] scale]];
//        [[self getMainControllerView].layer setShouldRasterize:YES];
//    }else{
//        [[self getMainControllerView].layer setShouldRasterize:NO];
//        if(self.isMainControllerActive){
//            [self addShadow:NO];
//        }
//    }
}


-(CGRect)getMainViewControllerFrameForState:(BOOL)isActive fromDirection:(SKSlideDirection)fromDirection{
    CGRect frame=[self getMainControllerView].frame;
    if(isActive){
        frame.origin.x=0;
    }else{
        if(fromDirection==SKSlideDirectionRight){
            frame.origin.x=self.currentControllerBounds.maxX;
        }else{
            frame.origin.x=self.currentControllerBounds.minX;
        }
    }
    return frame;
}

-(void)setMainViewSlideControllerStateForState:(BOOL)isActive direction:(SKSlideDirection)direction{
    if(isActive){
        _slideControllerState=SKSlideControllerStateRevealedNone;
    }else{
        if(direction==SKSlideDirectionRight){
            _slideControllerState=SKSlideControllerStateRevealedLeft;
        }else{
            _slideControllerState=SKSlideControllerStateRevealedRight;
        }
    }
}

-(CGRect)getFrameForLeftViewController{
    CGRect frame=self.view.bounds;
    frame.size.width-=self.mainControllerVisibleWidthWhileLeftControllerRevealed;
    return frame;
}

-(CGRect)getFrameForRightViewController{
    CGRect frame=self.view.bounds;
    frame.size.width-=self.mainControllerVisibleWidthWhileRightControllerRevealed;
    frame.origin.x+=self.mainControllerVisibleWidthWhileRightControllerRevealed;
    return frame;
}

-(CGFloat)getAnimationDurationForFrame:(CGRect)fromFrame toFrame:(CGRect)toFrame velocity:(CGFloat)velocity{
    velocity=fabs(velocity)>0.0?velocity:1;
    CGFloat displacement=fromFrame.origin.x-toFrame.origin.x;
    CGFloat deltaT=fabs(displacement/velocity);
    
    
    if(deltaT>0.4){
        deltaT=0.4;
    }else if(deltaT<0.01){
        deltaT=0.01;
    }
    return deltaT;
}


-(void)animateMainViewControllerForState:(BOOL)isActive direction:(SKSlideDirection)fromDirection duration:(CGFloat)duration completion:(void(^)(void))completion{
    
    __weak UIView *view=[self getMainControllerView];
    __weak SKSlideViewController *weakSelf=self;
    
    CGRect toFrame=[self getMainViewControllerFrameForState:isActive fromDirection:fromDirection];
    
    [self setMainViewSlideControllerStateForState:isActive direction:fromDirection];
    
    if(duration<=0.0){
        [view setFrame:toFrame];
        [weakSelf rasterizeMainControllerView:NO];
        if(!(completion==nil||completion==NULL)){
            completion();
        }
    }else{
        [self rasterizeMainControllerView:YES];
        [UIView animateWithDuration:duration animations:^{
            [view setFrame:toFrame];
        }completion:^(BOOL finished) {
            [weakSelf rasterizeMainControllerView:NO];
            if(!(completion==nil||completion==NULL)){
                completion();
            }
        }];
    }
}

-(void)animateMainViewControllerForState:(BOOL)isActive direction:(SKSlideDirection)fromDirection velocity:(CGFloat)velocity{
    UIView *view=[self getMainControllerView];
    CGRect fromFrame=view.frame;
    CGRect toFrame=[self getMainViewControllerFrameForState:isActive fromDirection:fromDirection];
    CGFloat animationDuration=[self getAnimationDurationForFrame:fromFrame toFrame:toFrame velocity:velocity];
    
    void(^completion)(void);
    completion=nil;
    
    if(isActive){
        __weak SKSlideViewController *weakSelf=self;
        
        completion=^{
            [weakSelf unloadAccessoryViewControllers];
        };
    }
    
    [self animateMainViewControllerForState:isActive direction:fromDirection duration:animationDuration completion:completion];
}


-(void)revealContainerViewForDirection:(SKSlideDirection)direction animate:(BOOL)animate duration:(CGFloat)duration{
    
    void(^completion)(void);
    completion=nil;
    
    if(direction==SKSlideDirectionNone)
    {
        self.hasIdentifiedPanDirection=NO;
        self.currentSlideDirection=direction;
        
        self.isMainControllerActive=YES;
        __weak SKSlideViewController *weakSelf=self;
        
        completion=^{
            [weakSelf unloadAccessoryViewControllers];
        };
        
    }else{
        self.hasIdentifiedPanDirection=YES;
        self.currentSlideDirection=direction;
        self.currentControllerBounds=[self getControllerBoundsForDirection:direction];
        self.isMainControllerActive=NO;
    }

    if(!animate){
        duration=0.0;
    }
    
    [self animateMainViewControllerForState:self.isMainControllerActive direction:direction duration:duration completion:^{
        if(!(completion==nil||completion==NULL)){
            completion();
        }
    }];
}

-(SKControllerBounds)getControllerBoundsForDirection:(SKSlideDirection)direction{
    CGFloat mainControllerVisibleWidth;
    CGFloat minX=0.0,maxX=0.0;
    if(direction==SKSlideDirectionRight){
        //Revealing Left controller
        mainControllerVisibleWidth=self.mainControllerVisibleWidthWhileLeftControllerRevealed;
        minX=0;
        maxX=self.view.bounds.size.width-mainControllerVisibleWidth;
    }else if(direction==SKSlideDirectionLeft){
        //Revealing Right controller
        mainControllerVisibleWidth=self.mainControllerVisibleWidthWhileRightControllerRevealed;
        minX=-(self.view.bounds.size.width-mainControllerVisibleWidth);
        maxX=0;
    }
    
    SKControllerBounds controllerBounds=SKControllerBoundsMake(minX, maxX);
    return controllerBounds;
}


#pragma mark -
#pragma mark Gesture Handling and Revealing logic
#pragma mark -

-(void)identifySlideDirectionFromTranslation:(CGFloat)translation{
    SKSlideDirection aSlideDirection;
    if(translation>0){
        if(!(self.controllerStyleMask & SKSlideControllerStyleRevealLeft)){
            return;
        }
        aSlideDirection=SKSlideDirectionRight;
    }else if(translation<0){
        if(!(self.controllerStyleMask & SKSlideControllerStyleRevealRight)){
            return;
        }
        aSlideDirection=SKSlideDirectionLeft;
    }else{
        return;
    }
    
    self.hasIdentifiedPanDirection=YES;
    self.currentSlideDirection=aSlideDirection;
    self.currentControllerBounds=[self getControllerBoundsForDirection:aSlideDirection];

    if(aSlideDirection==SKSlideDirectionRight){
        [self loadLeftViewController];
    }else{
        [self loadRightViewController];
    }
}

-(void)performPanBeginActivities{
    //[[self.mainViewController.view layer] removeAllAnimations];
    [self rasterizeMainControllerView:YES];
}

-(void)performPanEndActivitiesWithVelocity:(CGPoint)velocityPoint{
    CGFloat velocity=velocityPoint.x;
    BOOL newIsActive=self.isMainControllerActive;
    if(abs(velocity)>self.panEndVelocity){
        if(self.currentSlideDirection==SKSlideDirectionRight){
            if((self.isMainControllerActive&&velocity>=0)||(velocity<0&&!self.isMainControllerActive)){
                newIsActive=!newIsActive;
            }
        }else{
            if((self.isMainControllerActive&&velocity<0)||(!self.isMainControllerActive&&velocity>=0)){
                newIsActive=!newIsActive;
            }
        }
    }else{
        CGFloat constraintX=((self.currentControllerBounds.maxX-self.currentControllerBounds.minX)/2)*(self.currentSlideDirection==SKSlideDirectionRight?1:-1);
        CGFloat origin=[self getMainControllerView].frame.origin.x;
        
        if(self.currentSlideDirection==SKSlideDirectionRight){
            if((self.isMainControllerActive&&origin>constraintX)||(!self.isMainControllerActive&&origin<constraintX)){
                //valid
                newIsActive=!newIsActive;
            }
        }else{
            if((self.isMainControllerActive&&origin<constraintX)||(!self.isMainControllerActive&&origin>constraintX)){
                newIsActive=!newIsActive;
            }
        }
    }
    
    self.isMainControllerActive=newIsActive;

    [self animateMainViewControllerForState:self.isMainControllerActive direction:self.currentSlideDirection velocity:velocity];
    
    if(self.isMainControllerActive){
        self.hasIdentifiedPanDirection=NO;
        self.currentSlideDirection=SKSlideDirectionNone;
    }
}

-(void)didReceivePanGestureEvent:(UIPanGestureRecognizer *)recognizer{
    
    static CGFloat previousTranslation=0;
    
    CGPoint translationPoint=[recognizer translationInView:self.view];
    CGFloat currentTranslation=translationPoint.x;
    CGFloat translationDelta=0;
    
    switch(recognizer.state){
        case UIGestureRecognizerStateBegan:{
            translationDelta=currentTranslation;
            previousTranslation=currentTranslation;
            [self performPanBeginActivities];
        }break;
    
        case UIGestureRecognizerStateEnded:{
            translationDelta=currentTranslation-previousTranslation;
            previousTranslation=currentTranslation;
            //perform pan end animation
            CGPoint velocity=[recognizer velocityInView:self.view];
            [self performPanEndActivitiesWithVelocity:velocity];
            return;
        }break;
            
        case UIGestureRecognizerStateChanged:{
            translationDelta=currentTranslation-previousTranslation;
            previousTranslation=currentTranslation;
        }break;
            
        default:{
            return;
        }break;
    }
    
    if(!self.hasIdentifiedPanDirection){
        [self identifySlideDirectionFromTranslation:translationDelta];
        if(!self.hasIdentifiedPanDirection){
            return;
        }
    }
    
    UIView *view=[self getMainControllerView];
    
    CGRect frame=view.frame;
    frame.origin.x+=translationDelta;
    
    if(frame.origin.x<self.currentControllerBounds.minX){
        frame.origin.x=self.currentControllerBounds.minX;
    }else if(frame.origin.x>self.currentControllerBounds.maxX){
        frame.origin.x=self.currentControllerBounds.maxX;
    }
    
    [view setFrame:frame];
}

-(void)addPanGestureToMainView{
    if([self getMainControllerView]==nil){
        return;
    }
    
    if(!self.slidesOnPanGesture){
        return;
    }
    
    if(self.panRecognizer.view){
        [self.panRecognizer.view removeGestureRecognizer:self.panRecognizer];
        self.panRecognizer=nil;
    }
    
    UIPanGestureRecognizer *recognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePanGestureEvent:)];
    [[self getMainControllerView] addGestureRecognizer:recognizer];
    self.panRecognizer=recognizer;
    recognizer=nil;
}

-(void)removePanGestureFromMainView{
    if(self.panRecognizer==nil){
        return;
    }
    [self.panRecognizer.view removeGestureRecognizer:self.panRecognizer];
    self.panRecognizer=nil;
}

#pragma mark -
#pragma mark Controller Loading and Helpers
#pragma mark -

-(UIStoryboard *)getStoryBoard{
    UIStoryboard *storyBoard=self.storyboard;
    if(storyBoard==nil){
        storyBoard=[UIStoryboard storyboardWithName:self.storyBoardName bundle:[NSBundle mainBundle]];
    }
    return storyBoard;
}

-(UIViewController<SKSlideViewDelegate> *)getControllerWithStoryBoardIdentifier:(NSString *)storyBoardID{
    UIStoryboard *storyBoard=[self getStoryBoard];
    if(storyBoard==nil){
        return nil;
    }
    
    UIViewController<SKSlideViewDelegate> *controller=[storyBoard instantiateViewControllerWithIdentifier:storyBoardID];
    return controller;
}

-(void)loadController:(UIViewController<SKSlideViewDelegate> *)controller belowView:(UIView *)view frame:(CGRect)frame{

    if(controller==nil){
        return;
    }
    
    [self addChildViewController:controller];
    [controller.view setFrame:frame];
    
    if(view==nil||view.superview!=self.view){
        [self.view addSubview:controller.view];
    }else{
        [self.view insertSubview:controller.view belowSubview:view];
    }
    
    [controller didMoveToParentViewController:self];
    
    if([controller respondsToSelector:@selector(setSKSlideViewControllerReference:)]){
        [controller setSKSlideViewControllerReference:self];
    }
}

-(void)loadControllerByPerformingSegueWithIdentifier:(NSString *)segueID{
    [self performSegueWithIdentifier:segueID sender:nil];
}

-(void)loadControllersMainViewController:(UIViewController<SKSlideViewDelegate> *)mainViewController leftViewController:(UIViewController<SKSlideViewDelegate> *)leftViewController rightViewController:(UIViewController<SKSlideViewDelegate> *)rightViewController{
    
    [self loadController:mainViewController belowView:nil frame:self.view.bounds];
    self.mainViewController=mainViewController;
    [self addPanGestureToMainView];
    [self.mainViewController.view setClipsToBounds:NO];
    [self.mainViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    
    if(leftViewController){
        [self loadController:leftViewController belowView:mainViewController.view frame:[self getFrameForLeftViewController]];
        self.leftViewController=leftViewController;
        [self.leftViewController.view setHidden:YES];
        [self.leftViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    }
    
    if(rightViewController){
        [self loadController:rightViewController belowView:mainViewController.view frame:[self getFrameForRightViewController]];
        self.rightViewController=rightViewController;
        [self.rightViewController.view setHidden:YES];
        [self.rightViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    }
    
}

-(void)loadMainViewController{
    
    if(self.mainViewController){
        [self.mainViewController.view setHidden:NO];
    }else if(self.loadSource==SKLoadSourceStoryBoardIDs){
        UIViewController<SKSlideViewDelegate> *controller=[self getControllerWithStoryBoardIdentifier:self.mainViewControllerStoryBoardID];
        [self loadController:controller belowView:nil frame:self.view.bounds];
        self.mainViewController=controller;
        //add pan gesture if necessary
        [self addPanGestureToMainView];
        [self.mainViewController.view setClipsToBounds:NO];
        
    }else if(self.loadSource==SKLoadSourceStoryBoardSegues){
        
        [self loadControllerByPerformingSegueWithIdentifier:self.mainViewControllerSegueID];
        
    }
    
    [self unloadLeftViewController];
    [self unloadRightViewController];
}

-(void)loadLeftViewController{
    
    [self unloadRightViewController];
    
    if(self.leftViewController){
        [self.leftViewController.view setHidden:NO];
    }else if(self.loadSource==SKLoadSourceStoryBoardIDs){
        
        UIViewController<SKSlideViewDelegate> *controller=[self getControllerWithStoryBoardIdentifier:self.leftViewControllerStoryBoardID];
        
        [self loadController:controller belowView:self.mainViewController.view frame:[self getFrameForLeftViewController]];
        self.leftViewController=controller;
        
    }else if(self.loadSource==SKLoadSourceStoryBoardSegues){
        
        [self loadControllerByPerformingSegueWithIdentifier:self.leftViewControllerSegueID];
    }
    [self unloadRightViewController];
}

-(void)loadRightViewController{
    if(self.rightViewController){
        [self.rightViewController.view setHidden:NO];
    }else if(self.loadSource==SKLoadSourceStoryBoardIDs){
        
        UIViewController<SKSlideViewDelegate> *controller=[self getControllerWithStoryBoardIdentifier:self.rightViewControllerStoryBoardID];
        [self loadController:controller belowView:self.mainViewController.view frame:[self getFrameForRightViewController]];
        self.rightViewController=controller;
        
    }else if(self.loadSource==SKLoadSourceStoryBoardSegues){
        [self loadControllerByPerformingSegueWithIdentifier:self.rightViewControllerSegueID];
    }
    
    [self unloadLeftViewController];
}

-(void)loadControllerForDirection:(SKSlideDirection)direction{
    if(direction==SKSlideDirectionLeft){
        [self loadRightViewController];
    }else if(direction==SKSlideDirectionRight){
        [self loadLeftViewController];
    }
}

-(void)unloadViewController:(UIViewController *)controller{
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

-(void)unloadLeftViewController{
    if(self.leftViewController==nil){
        return;
    }
    
    if(self.loadsOnDemand){
        [self unloadViewController:self.leftViewController];
    }else{
        [self.leftViewController.view setHidden:YES];
    }
}

-(void)unloadRightViewController{
    if(self.rightViewController==nil){
        return;
    }
    
    if(self.loadsOnDemand){
        [self unloadViewController:self.rightViewController];
    }else{
        [self.rightViewController.view setHidden:YES];
    }
}

-(void)unloadMainViewController{
    if(self.mainViewController==nil){
        return;
    }
    if(self.loadsOnDemand){
        [self unloadViewController:self.mainViewController];
    }else{
        [self.mainViewController.view setHidden:YES];
    }
}

-(void)unloadAccessoryViewControllers{
    [self unloadLeftViewController];
    [self unloadRightViewController];
}

-(void)forceUnloadViewControllers{
    [self unloadViewController:self.mainViewController];
    [self unloadViewController:self.rightViewController];
    [self unloadViewController:self.leftViewController];
}



#pragma mark -
#pragma mark Public methods
#pragma mark -

#pragma mark __Class Methods -

+(SKSlideViewController *)getSlideViewControllerWithMainController:(UIViewController<SKSlideViewDelegate> *)mainController
                                                    leftController:(UIViewController<SKSlideViewDelegate> *)leftController
                                                   rightController:(UIViewController<SKSlideViewDelegate> *)rightController{
    if(mainController==nil){
        return nil;
    }
    
    SKSlideViewController *controller=[[SKSlideViewController alloc] init];
    if(controller){

        [controller setSlideViewControllerUsingMainViewController:mainController leftViewController:leftController rightViewController:rightController];
    }
    return controller;
}

+(SKSlideViewController *)getSlideViewControllerUsingStoryBoardName:(NSString *)storyBoardName
                         usingStoryBoardIdentifiersMainControllerID:(NSString *)mainControllerID
                                                   leftControllerID:(NSString *)leftControllerID
                                                  rightControllerID:(NSString *)rightControllerID
                                        loadViewControllersOnDemand:(BOOL)loadsOnDemand;{
    
    SKSlideViewController *controller=[[SKSlideViewController alloc] init];
    
    if(controller){
        [controller setStoryBoardIDForMainController:mainControllerID leftController:leftControllerID rightController:rightControllerID];
        [controller setStoryBoardName:storyBoardName];
    }
    
    return controller;
}


#pragma mark - __Instance Methods -

-(void)setStoryBoardIDForMainController:(NSString *)mainControllerID
                         leftController:(NSString *)leftControllerID
                        rightController:(NSString *)rightControllerID{
    
    
    [self initialiseToSourceStoryBoardIDsDefaults];
    
    SKSlideControllerStyle styleMask=SKSlideControllerStyleRevealNone;
    if(leftControllerID!=nil){
        styleMask=styleMask|SKSlideControllerStyleRevealLeft;
    }
    
    if(rightControllerID!=nil){
        styleMask=styleMask|SKSlideControllerStyleRevealRight;
    }
    
    [self setSlideControllerStyleMask:styleMask];
    self.mainViewControllerStoryBoardID=mainControllerID;
    self.leftViewControllerStoryBoardID=leftControllerID;
    self.rightViewControllerStoryBoardID=rightControllerID;
}

-(void)setSegueIDForMainController:(NSString *)mainControllerID
                    leftController:(NSString *)leftControllerID
                   rightController:(NSString *)rightControllerID{
    
    [self initialiseToSourceSeguesDefaults];
    
    SKSlideControllerStyle styleMask=SKSlideControllerStyleRevealNone;
    if(leftControllerID!=nil){
        styleMask=styleMask|SKSlideControllerStyleRevealLeft;
    }
    
    if(rightControllerID!=nil){
        styleMask=styleMask|SKSlideControllerStyleRevealRight;
    }
    
    [self setSlideControllerStyleMask:styleMask];
    
    self.mainViewControllerSegueID=mainControllerID;
    self.leftViewControllerSegueID=leftControllerID;
    self.rightViewControllerSegueID=rightControllerID;
}

-(void)setSlideViewControllerUsingMainViewController:(UIViewController<SKSlideViewDelegate> *)mainController
                                  leftViewController:(UIViewController<SKSlideViewDelegate> *)leftController
                                 rightViewController:(UIViewController<SKSlideViewDelegate> *)rightController{
    
    [self initialiseToSourceCodeDefaults];
    SKSlideControllerStyle styleMask=SKSlideControllerStyleRevealNone;
    
    if(leftController!=nil){
        styleMask=styleMask|SKSlideControllerStyleRevealLeft;
    }
    
    if(rightController!=nil){
        styleMask=styleMask|SKSlideControllerStyleRevealRight;
    }
    [self setSlideControllerStyleMask:styleMask];
    [self loadControllersMainViewController:mainController leftViewController:leftController rightViewController:rightController];
    
}

-(void)setLoadViewControllersOnDemand:(BOOL)loadOnDemand{
    if(self.loadSource==SKLoadSourceCode){
        _loadsOnDemand=NO;
    }
    _loadsOnDemand=loadOnDemand;
}

-(void)setSlideControllerStyleMask:(SKSlideControllerStyle)slideControllerStyleMask{
    _controllerStyleMask=slideControllerStyleMask;
}

-(void)setVisibleWidthOfMainContainerWhileRevealingLeftContainer:(CGFloat)leftOffset
                                                  rightContainer:(CGFloat)rightOffset{
    self.mainControllerVisibleWidthWhileLeftControllerRevealed=leftOffset;
    self.mainControllerVisibleWidthWhileRightControllerRevealed=rightOffset;
}

-(void)setSlidesOnPanGesture:(BOOL)pansOnGesture{
    _slidesOnPanGesture=pansOnGesture;
    if(pansOnGesture){
        [self addPanGestureToMainView];
    }else{
        [self removePanGestureFromMainView];
    }
}

-(void)setHasShadow:(BOOL)hasShadow{
    _hasShadow=hasShadow;
}

-(void)reloadControllers{
    if(self.loadSource==SKLoadSourceStoryBoardSegues){
        if([self getMainControllerView]==nil){
            return;
        }
    }
    [self unloadControllers];
    [self loadControllers];
}

-(void)revealRightContainerViewAnimated:(BOOL)animate{
    if(!(self.controllerStyleMask&SKSlideControllerStyleRevealRight)){
        return;
    }
    if(self.slideControllerState==SKSlideControllerStateRevealedRight){
        return;
    }
    [self loadControllerForDirection:SKSlideDirectionLeft];
    [self revealContainerViewForDirection:SKSlideDirectionLeft animate:animate duration:SK_DEFAULT_REVEAL_ANIMATION_DURATION];
}

-(void)revealLeftContainerViewAnimated:(BOOL)animate{
    if(!(self.controllerStyleMask&SKSlideControllerStyleRevealLeft)){
        return;
    }
    if(self.slideControllerState==SKSlideControllerStateRevealedLeft){
        return;
    }
    [self loadControllerForDirection:SKSlideDirectionRight];
    [self revealContainerViewForDirection:SKSlideDirectionRight animate:animate duration:SK_DEFAULT_REVEAL_ANIMATION_DURATION];
}

-(void)showMainContainerViewAnimated:(BOOL)animate{
    if(self.slideControllerState==SKSlideControllerStateRevealedNone){
        return;
    }
    [self revealContainerViewForDirection:SKSlideDirectionNone animate:animate duration:SK_DEFAULT_REVEAL_ANIMATION_DURATION];
}

-(BOOL)isActive{
    return self.isMainControllerActive;
}

#pragma mark -
#pragma mark Interface Orientation
#pragma mark -


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

    if(!self.isMainControllerActive){
        //[self rasterizeMainControllerView:YES];
        [self addShadow:NO];
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(!self.isMainControllerActive){
        
        [UIView setAnimationsEnabled:NO];
        
        if(self.slideControllerState==SKSlideControllerStateRevealedLeft){
            [self revealContainerViewForDirection:SKSlideDirectionRight animate:NO duration:0.0];
        }else if(self.slideControllerState==SKSlideControllerStateRevealedRight){
            [self revealContainerViewForDirection:SKSlideDirectionLeft animate:NO duration:0.0];
        }
        //[self rasterizeMainControllerView:YES];
        [self addShadow:NO];
        
        [UIView setAnimationsEnabled:YES];
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

    if(!self.isMainControllerActive){
        [self rasterizeMainControllerView:NO];
        [UIView animateWithDuration:4.0 animations:^{
           [self addShadow:YES]; 
        }];
    }
}

#pragma mark -
#pragma mark Segue identifier
#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.identifier isEqualToString:self.mainViewControllerSegueID]){
        //main controller
        UIViewController *controller=[segue destinationViewController];
        self.mainViewController=controller;
        [self sendSlideControllerReferenceToController:controller];
        [self performSelector:@selector(loadSegueMainViewController:) withObject:controller afterDelay:0.1];
    }else if([segue.identifier isEqualToString:self.leftViewControllerSegueID]){
        //Left controller
        UIViewController *controller=[segue destinationViewController];
        self.leftViewController=controller;
        [self sendSlideControllerReferenceToController:controller];
        if(!hasLoadedLeftView){
            hasLoadedLeftView=YES;
            [controller.view setHidden:YES];
            [self performSelector:@selector(unloadSegueViewController:) withObject:controller afterDelay:0.1];
        }else{
            [controller.view setHidden:NO];
            [self performSelector:@selector(loadSegueViewController:) withObject:controller afterDelay:0.1];
        }
    }else if([segue.identifier isEqualToString:self.rightViewControllerSegueID]){
        //right controller
        UIViewController *controller=[segue destinationViewController];
        self.rightViewController=controller;
        [self sendSlideControllerReferenceToController:controller];
        if(!hasLoadedRightView){
            hasLoadedRightView=YES;
            [controller.view setHidden:YES];
            [self performSelector:@selector(unloadSegueViewController:) withObject:controller afterDelay:0.1];
        }else{
            [controller.view setHidden:NO];
            [self performSelector:@selector(loadSegueViewController:) withObject:controller afterDelay:0.1];
        }
    }
}

-(void)unloadSegueViewController:(UIViewController *)controller{
    UIView *view=controller.view.superview;
    if([self.view.subviews containsObject:view]){
        [self.view insertSubview:view belowSubview:[self getMainControllerView]];
    }
    [self unloadViewController:controller];
}

-(void)loadSegueViewController:(UIViewController *)controller{
    UIView *view=controller.view.superview;
    if([self.view.subviews containsObject:view]){
        [self.view insertSubview:view belowSubview:[self getMainControllerView]];
    }
}

-(void)loadSegueMainViewController:(UIViewController *)controller{
    [self.mainViewController.view setClipsToBounds:NO];
    [self addPanGestureToMainView];
}

#pragma mark -
#pragma mark Controller References
#pragma mark -

-(void)sendSlideControllerReferenceToController:(UIViewController *)controller{
    
    if([controller respondsToSelector:@selector(setSKSlideViewControllerReference:)]){
        [(UIViewController<SKSlideViewDelegate> *)controller setSKSlideViewControllerReference:self];
    }
    
}

-(UIViewController *)getMainViewController{
    return self.mainViewController;
}

-(UIViewController *)getLeftViewController{
    return self.leftViewController;
}

-(UIViewController *)getRightViewController{
    return self.rightViewController;
}

@end
