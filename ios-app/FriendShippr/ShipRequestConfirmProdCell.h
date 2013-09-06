//
//  ShipRequestConfirmProdCell.h
//  FriendShippr
//
//  Created by Zoondia on 29/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShipRequestConfirmProdCell : UITableViewCell

+ (NSString *)reuseIdentifier;
@property (retain, nonatomic) IBOutlet UILabel *lblProductName;
@property (retain, nonatomic) IBOutlet UILabel *lblProductNumber;
@property (retain, nonatomic) IBOutlet UIImageView *productImageView;

@end
