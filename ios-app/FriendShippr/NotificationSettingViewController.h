//
//  NotificationSettingViewController.h
//  FriendShippr
//
//  Created by Zoondia on 29/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationSettCustomCell.h"

@interface NotificationSettingViewController : UIViewController

//Notification Settings selection index..
typedef enum {
	AnnouncementsSettingIndex = 0,
	PermissionsSettingIndex = 1,
	CommentsSettingIndex = 2,
    FeedsSettingIndex = 3,
    NewProductSettingIndex = 4
} NotificationPageSettingsIndex;

@property (retain, nonatomic) IBOutlet UISwitch *headerSwitch;
@property (retain, nonatomic) IBOutlet UITableView *tableNotifSetting;
@property (retain, nonatomic) NSMutableArray *notifSettMenuArray;
@property (retain, nonatomic) IBOutlet UIView *sectionHeaderView;
@property (assign, nonatomic) BOOL isHeaderSwitchOn;
- (IBAction)headerSwitchValueChanged:(id)sender;
@end
