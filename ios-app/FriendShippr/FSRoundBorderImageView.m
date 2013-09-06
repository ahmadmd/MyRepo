//
//  FSRoundBorderImageView.m
//  FriendShippr
//
//  Created by Zoondia on 02/09/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "FSRoundBorderImageView.h"

@implementation FSRoundBorderImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)layoutSubviews{
    UIImageView *borderImageView=[[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, self.bounds.size.width+2, self.bounds.size.height+2)];
    borderImageView.image=[UIImage imageNamed:@"imageBorderedRound.png"];
    [self addSubview:borderImageView];
    [borderImageView release];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
