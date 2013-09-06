//
//  IntroDataSource.m
//  scrollDynamicLoadingTest
//
//  Created by Zoondia on 01/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "IntroDataSource.h"

@implementation IntroDataSource
@synthesize imageNames,imageUrls;


static IntroDataSource *sharedDataSource = nil;

// Get the shared instance and create it if necessary.
+ (IntroDataSource *)sharedDataSource {
    if (sharedDataSource == nil) {
        sharedDataSource = [[super allocWithZone:NULL] init];
    }
    
    return sharedDataSource;
}

// Init method for the object.
- (id)init
{
	self = [super init];
	if (self != nil)
	{
		imageNames=[[NSArray alloc] initWithObjects:introScreenImages];
	}
	return self;
}

- (NSInteger)numDataPages:(BOOL)fromLoginPage
{
    if(fromLoginPage){
        return [self.imageNames count];
    }
    else{
        return [self.imageUrls count];
    }
}

- (NSString *)dataForPage:(NSInteger)pageIndex pageType:(BOOL)fromLoginPage
{
    if(fromLoginPage){
        return [self.imageNames objectAtIndex:pageIndex];
    }
    else{
       return [self.imageUrls objectAtIndex:pageIndex]; 
    }
}

@end
