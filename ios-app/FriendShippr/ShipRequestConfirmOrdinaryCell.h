//
//  ShipRequestConfirmOrdinaryCell.h
//  FriendShippr
//
//  Created by Zoondia on 29/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShipRequestConfirmOrdinaryCell : UITableViewCell

+ (NSString *)reuseIdentifier;
@property (retain, nonatomic) IBOutlet UILabel *lblName;
@property (retain, nonatomic) IBOutlet UIImageView *imageHolder;
@end
