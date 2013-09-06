//
//  InviteFriendsViewController.h
//  FriendShippr
//
//  Created by Zoondia on 13/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFriendsCell.h"
#import "Common.h"

@interface InviteFriendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) NSMutableArray *invitedFriends;
@property (retain, nonatomic) NSMutableArray *facebookFriends;
@property (retain, nonatomic) NSMutableArray *friendshipprFriends;
@property (retain, nonatomic) IBOutlet UITableView *tblInviteFriends;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (retain, nonatomic) IBOutlet UILabel *lblErrorMsg;
- (IBAction)bttnActionSearchFriend:(id)sender;
- (IBAction)bttnActionPostInvite:(id)sender;
@end
