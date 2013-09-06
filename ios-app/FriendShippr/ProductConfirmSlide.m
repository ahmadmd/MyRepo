//
//  ProductConfirmSlide.m
//  FriendShippr
//
//  Created by Zoondia on 22/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "ProductConfirmSlide.h"
#import "UIImage+AlphaAdditions.h"
#import "UIImage+ResizeAdditions.h"
#import "UIImage+RoundedCornerAdditions.h"

@implementation ProductConfirmSlide
@synthesize pageIndex,introImageView;

- (void)setPageIndex:(NSInteger)newPageIndex
{
	pageIndex = newPageIndex;
	
	if (pageIndex >= 0 && pageIndex < [[IntroDataSource sharedDataSource] numDataPages:NO])
	{
		NSString *imageUrl =[[IntroDataSource sharedDataSource] dataForPage:pageIndex pageType:NO];
        //[introImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"NoProduct.png"] options:SDWebImageRefreshCached];
        
        self.introImageView.image=[UIImage imageNamed:@"NoProduct.png"];
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error,SDImageCacheType cacheType, BOOL finished){
            if (image)
            {
                self.introImageView.image=[image thumbnailImage:320 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationLow];
            }
        }];
	}
}

- (void)dealloc {
    [introImageView release];
    [super dealloc];
}

@end
