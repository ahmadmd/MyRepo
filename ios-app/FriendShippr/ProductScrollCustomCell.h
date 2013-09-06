//
//  ProductScrollCustomCell.h
//  FriendShippr
//
//  Created by Zoondia on 03/09/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductScrollCustomCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *productImageHolder;

+ (NSString *)reuseIdentifier;

@end
