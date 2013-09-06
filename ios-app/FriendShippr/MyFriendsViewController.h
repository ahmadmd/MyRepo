//
//  MyFriendsViewController.h
//  FriendShippr
//
//  Created by Zoondia on 13/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "MyFriendsCell.h"
#import "InviteFriendsViewController.h"
#import "UIImage+ResizeAdditions.h"

@interface MyFriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *lblFirstCount;
@property (retain, nonatomic) IBOutlet UILabel *lblSecondCount;
@property (retain, nonatomic) IBOutlet UILabel *lblTotalCount;
@property (retain, nonatomic) IBOutlet UITableView *tblFriendsList;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) NSMutableArray *friendsListArray;
@property (retain, nonatomic) IBOutlet UILabel *lblErrorMsg;
@property(nonatomic,assign)BOOL isFromMyProfile;
- (IBAction)bttnActionInviteFriends:(id)sender;
@end
