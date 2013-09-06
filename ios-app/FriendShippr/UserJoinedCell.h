//
//  UserJoinedCell.h
//  FriendShippr
//
//  Created by Zoondia on 24/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserJoinedCell : PFTableViewCell

+ (NSString *)reuseIdentifier;
@property (retain, nonatomic) IBOutlet UILabel *lblUserName;
@property (retain, nonatomic) IBOutlet UILabel *lblTimeDisplay;

@end
