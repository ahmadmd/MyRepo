//
//  IntroPageDesign.m
//  scrollDynamicLoadingTest
//
//  Created by Zoondia on 01/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "IntroPageDesign.h"

@implementation IntroPageDesign
@synthesize pageIndex,introImageView;

- (void)setPageIndex:(NSInteger)newPageIndex
{
	pageIndex = newPageIndex;
	
	if (pageIndex >= 0 && pageIndex < [[IntroDataSource sharedDataSource] numDataPages:YES])
	{
		NSString *imageName =[[IntroDataSource sharedDataSource] dataForPage:pageIndex pageType:YES];
		introImageView.image=[UIImage imageNamed:imageName];
	}
}

- (void)dealloc {
    [introImageView release];
    [super dealloc];
}
@end
