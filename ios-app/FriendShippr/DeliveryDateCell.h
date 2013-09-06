//
//  DeliveryDateCell.h
//  FriendShippr
//
//  Created by Zoondia on 25/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryDateCell : UITableViewCell

+ (NSString *)reuseIdentifier;
@property (retain, nonatomic) IBOutlet UIImageView *tickImageView;
@property (retain, nonatomic) IBOutlet UILabel *lblHeadingText;
@property (retain, nonatomic) IBOutlet UILabel *lblSubHeadingText;

@end
