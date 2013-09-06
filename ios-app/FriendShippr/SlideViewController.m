//
//  SlideViewController.m
//  FriendShippr
//
//  Created by Zoondia on 20/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "SlideViewController.h"

@implementation SlideViewController
@synthesize pageIndex,productImgView,currentCell;

- (void)setPageIndex:(NSInteger)newPageIndex
{
	pageIndex = newPageIndex;
	
	if (pageIndex >= 0 && pageIndex < [currentCell numDataPages])
	{
		NSString *imageUrl =[currentCell dataForPage:pageIndex];
		[productImgView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"NoProduct.png"] options:SDWebImageRefreshCached];
	}
}

- (void)dealloc {
    [productImgView release];
    [currentCell release];
    [super dealloc];
}

@end
