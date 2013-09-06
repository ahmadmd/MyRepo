//
//  SelectedProductCell.h
//  FriendShippr
//
//  Created by Zoondia on 23/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedProductCell : UITableViewCell<UITextFieldDelegate>

+ (NSString *)reuseIdentifier;
@property (retain, nonatomic) IBOutlet UILabel *lblProductName;
@property (retain, nonatomic) IBOutlet UITextField *txtQuantity;

@end
