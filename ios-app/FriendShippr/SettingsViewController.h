//
//  SettingsViewController.h
//  FriendShippr
//
//  Created by Zoondia on 29/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsCustomCell.h"
#import "NotificationSettingViewController.h"

@interface SettingsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

//Settings selection index..
typedef enum {
	NotificationSettingsIndex = 0,
	FeedbackSettingsIndex = 1,
	TermsSettingsIndex = 2,
    LogoutIndex = 3
} SettingsIndex;

@property (retain, nonatomic) IBOutlet UITableView *tableSettings;
@property (retain, nonatomic) NSMutableArray *settingsMenuArray;
@end
