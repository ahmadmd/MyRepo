//
//  HomeViewController.h
//  FriendShippr
//
//  Created by Zoondia on 15/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "PopoverViewController.h"
#import "WEPopoverController.h"
#import "ProductEntryViewController.h"
#import "PickUpPointViewController.h"
#import "MyFriendsViewController.h"
#import "FeedsTableController.h"
#import "MBProgressHUD.h"

@interface HomeViewController : UIViewController<WEPopoverControllerDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *progressHud;
}

@property (assign, nonatomic) BOOL isFirstLoad;
@property (nonatomic, retain) WEPopoverController *popoverController;
@property (retain, nonatomic) IBOutlet UIImageView *bgImageHolder;
@property (retain, nonatomic) IBOutlet UIView *tutorialHolder;
@property (retain, nonatomic) IBOutlet UITextView *txtFirstTutorialView;
@property (retain, nonatomic) IBOutlet UITextView *txtSecondTutorialView;
@property(nonatomic,retain)FeedsTableController *feedsTableViewController;
@property(nonatomic,retain)NSArray *userfriends;
- (IBAction)bttnActionFriends:(id)sender;

@end
