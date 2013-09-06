//
//  SlideCustomCell.h
//  FriendShippr
//
//  Created by Zoondia on 05/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideCustomCell : UITableViewCell

+ (NSString *)reuseIdentifier;
@property (retain, nonatomic) IBOutlet UIImageView *bgView;
@property (retain, nonatomic) IBOutlet UIImageView *imageHolder;
@property (retain, nonatomic) IBOutlet UILabel *name;

@end
