//
//  MyProfileViewController.h
//  FriendShippr
//
//  Created by Zoondia on 28/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SDWebImageDownloader.h"
#import "SettingsViewController.h"

@interface MyProfileViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *lblKarmaValue;
@property (retain, nonatomic) IBOutlet UILabel *lblDisplayName;
@property (retain, nonatomic) IBOutlet UILabel *lblShipperTitle;
@property (retain, nonatomic) IBOutlet UIImageView *profileImageView;
- (IBAction)bttnActionBadges:(id)sender;
- (IBAction)bttnActionKarma:(id)sender;
- (IBAction)bttnActionAccount:(id)sender;
- (IBAction)bttnActionFriends:(id)sender;
- (IBAction)bttnActionTopCities:(id)sender;
@end
