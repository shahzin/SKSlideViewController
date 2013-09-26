//
//  SKSlideViewController.h
//  SlideViewTemplate
//
//  Created by Shahzin KS on 14/07/13.
//  Copyright (c) 2013 sksarts. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef SK_SEGUE_IDENTIFIER

    #define SK_SEGUE_IDENTIFIER

    //If using storyboard segues
    #define SK_DEFAULT_SEGUE_IDENTIFIER_LEFT @"SKSegueIdentifierLeft"
    #define SK_DEFAULT_SEGUE_IDENTIFIER_MAIN @"SKSegueIdentifierMain"
    #define SK_DEFAULT_SEGUE_IDENTIFIER_RIGHT @"SKSegueIdentifierRight"

    //If using storyboard IDs - Default
    #define SK_DEFAULT_STORY_BOARD_IDENTIFIER_LEFT @"SKStoryBoardIdentifierLeft"
    #define SK_DEFAULT_STORY_BOARD_IDENTIFIER_MAIN @"SKStoryBoardIdentifierMain"
    #define SK_DEFAULT_STORY_BOARD_IDENTIFIER_RIGHT @"SKStoryBoardIdentifierRight"

    #define SK_DEFAULT_REVEAL_ANIMATION_DURATION 0.25
    #define SK_DEFAULT_PAN_END_ANIMATION_DURATION 0.2
    #define SK_DEFAULT_PAN_END_VELOCITY 250.00
    #define SK_DEFAULT_VISIBLE_WIDTH_WHILE_REVEALED 50.00
    #define SK_DEFAULT_STORY_BOARD_NAME @"MainStoryboard_iPhone"

#endif

typedef NS_ENUM(NSUInteger, SKSlideControllerState){
    SKSlideControllerStateRevealedNone=112,
    SKSlideControllerStateRevealedLeft,
    SKSlideControllerStateRevealedRight,
};

typedef NS_OPTIONS(NSUInteger, SKSlideControllerStyle){
    SKSlideControllerStyleRevealNone= 1 << 0,
    SKSlideControllerStyleRevealLeft= 1 << 1,
    SKSlideControllerStyleRevealRight= 1 << 2,
};

@class SKSlideViewController;


#pragma mark -
#pragma mark SKSlideController Protocol
#pragma mark -

@protocol SKSlideViewDelegate <NSObject>

@required

-(void)setSKSlideViewControllerReference:(SKSlideViewController *)aSlideViewController;

@optional

-(void)didReceiveDataFromLeftContainer:(UIViewController *)container info:(NSDictionary *)userInfo;

-(void)didReceiveDataFromRightContainer:(UIViewController *)container info:(NSDictionary *)userInfo;

-(void)didReceiveDataFromMainContainer:(UIViewController *)container info:(NSDictionary *)userInfo;

@end

@interface SKSlideViewController : UIViewController{
    
}

#pragma mark -
#pragma mark Properties
#pragma mark -

@property (nonatomic,readonly) BOOL isActive;

@property (nonatomic,readonly) SKSlideControllerState slideControllerState;


#pragma mark -
#pragma mark Methods
#pragma mark -

#pragma mark __Class Methods -


/**
 This Class Method returns SKSlideViewController instance with the given instantiated view controllers. Use this method only if you are instantiating all the view controllers programattically. Impact memory usage. Use story board ids instead
 
 */
+(SKSlideViewController *)getSlideViewControllerWithMainController:(UIViewController<SKSlideViewDelegate> *)mainController
                                                    leftController:(UIViewController<SKSlideViewDelegate> *)leftController
                                                   rightController:(UIViewController<SKSlideViewDelegate> *)rightController;


/**
 This Class Method returns SKSlideViewController instance using storyboard ids from the given storyboard.
 */
+(SKSlideViewController *)getSlideViewControllerUsingStoryBoardName:(NSString *)storyBoardName
                            usingStoryBoardIdentifiersMainControllerID:(NSString *)mainControllerID
                                                      leftControllerID:(NSString *)leftControllerID
                                                     rightControllerID:(NSString *)rightControllerID
                                           loadViewControllersOnDemand:(BOOL)loadsOnDemand;


#pragma mark - __Instance Methods -


/**
 This method sets the storyboard IDs of the view Controllers
 */
-(void)setStoryBoardIDForMainController:(NSString *)mainControllerID
                         leftController:(NSString *)leftControllerID
                        rightController:(NSString *)rightControllerID;



/**
 This method sets the segue IDs of the view Controllers
 */
-(void)setSegueIDForMainController:(NSString *)mainControllerID
                    leftController:(NSString *)leftControllerID
                   rightController:(NSString *)rightControllerID;


/**
 This method sets the view controllers of the slide view controller
 */

-(void)setSlideViewControllerUsingMainViewController:(UIViewController<SKSlideViewDelegate> *)mainController
                                  leftViewController:(UIViewController<SKSlideViewDelegate> *)leftViewController
                                 rightViewController:(UIViewController<SKSlideViewDelegate> *)rightController;



/**
 This method determines whether the left and right view controllers should be loaded on demand or not. 
 If the view controllers are loaded using story board IDs, It is highly recommended to set this flag, to reduce memory usage.
 */
-(void)setLoadViewControllersOnDemand:(BOOL)loadOnDemand;


/**
 The style mask helps the slideview controller to determine which are the possible direction towards which the controller slides.
 */

-(void)setSlideControllerStyleMask:(SKSlideControllerStyle)slideControllerStyleMask;


/**
 This method can be used to set the visible part of the main controller when it slides to left or right
 */
-(void)setVisibleWidthOfMainContainerWhileRevealingLeftContainer:(CGFloat)leftOffset
                                                  rightContainer:(CGFloat)rightOffset;

/**
 This method can be used to set whether the controller respondes to pan gesture.
 */
-(void)setSlidesOnPanGesture:(BOOL)pansOnGesture;


/**

 */
-(void)setHasShadow:(BOOL)hasShadow;

/**
 This method invokes reload method of the SKSlideViewProtocol of the currently loaded view controllers
 */
-(void)reloadControllers;

/**
 This methods reveals Right container view
 */
-(void)revealRightContainerViewAnimated:(BOOL)animate;

/**
 This methods reveals Left container view
 */
-(void)revealLeftContainerViewAnimated:(BOOL)animate;

/**
 This methods makes the main view controller active and unloads or hides the accessory views.
 */
-(void)showMainContainerViewAnimated:(BOOL)animate;


#pragma mark - __Controller Reference

/**
 */

-(UIViewController *)getMainViewController;

-(UIViewController *)getLeftViewController;

-(UIViewController *)getRightViewController;

@end
