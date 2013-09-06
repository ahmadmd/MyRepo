//
//  SelectedProductCell.m
//  FriendShippr
//
//  Created by Zoondia on 23/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "SelectedProductCell.h"

@implementation SelectedProductCell

+ (NSString *)reuseIdentifier{
    return @"selectedProductIdentifier";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 3) ? NO : YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"quantityChangedNotif" object:self];
}


- (void)dealloc {
    [_lblProductName release];
    [_txtQuantity release];
    [super dealloc];
}
@end
