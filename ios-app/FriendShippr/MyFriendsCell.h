//
//  MyFriendsCell.h
//  FriendShippr
//
//  Created by Zoondia on 13/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFriendsCell : UITableViewCell

+ (NSString *)reuseIdentifier;
@property (retain, nonatomic) IBOutlet UIImageView *friendProfileImage;
@property (retain, nonatomic) IBOutlet UILabel *friendName;
@property (retain, nonatomic) IBOutlet UIImageView *friendAccesoryImage;
@end
