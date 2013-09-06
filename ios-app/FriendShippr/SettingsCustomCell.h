//
//  SettingsCustomCell.h
//  FriendShippr
//
//  Created by Zoondia on 29/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsCustomCell : UITableViewCell

+ (NSString *)reuseIdentifier;
@property (retain, nonatomic) IBOutlet UIImageView *settingsIcon;
@property (retain, nonatomic) IBOutlet UILabel *lblSettingsName;
@property (retain, nonatomic) IBOutlet UIImageView *accessoryImage;
@end
