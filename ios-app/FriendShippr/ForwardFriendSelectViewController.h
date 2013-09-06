//
//  ForwardFriendSelectViewController.h
//  FriendShippr
//
//  Created by Zoondia on 28/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Common.h"
#import "MyFriendsCell.h"
#import "UIImage+ResizeAdditions.h"
#import "MBProgressHUD.h"

@interface ForwardFriendSelectViewController : UIViewController<MBProgressHUDDelegate>{
    MBProgressHUD *progressHud;
}

@property(nonatomic,retain)PFObject *shippingReqObj;
@property (retain, nonatomic) NSMutableArray *invitedFriends;
@property (retain, nonatomic) IBOutlet UITableView *tableFriendSelect;
@property(nonatomic,retain)NSArray *friendsArray;
@property (retain, nonatomic) IBOutlet UILabel *lblErrMsg;
- (IBAction)bttnActionForwardShippingRequest:(id)sender;
@end
