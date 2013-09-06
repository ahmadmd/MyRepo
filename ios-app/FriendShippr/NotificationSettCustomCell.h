//
//  NotificationSettCustomCell.h
//  FriendShippr
//
//  Created by Zoondia on 30/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationSettCustomCell : UITableViewCell

+ (NSString *)reuseIdentifier;
- (IBAction)accessorySwitchValueChanged:(id)sender;

@property (retain, nonatomic) IBOutlet UIImageView *notifSettIcon;
@property (retain, nonatomic) IBOutlet UILabel *lblNotifSettName;
@property (retain, nonatomic) IBOutlet UISwitch *accessorySwitch;
@end
