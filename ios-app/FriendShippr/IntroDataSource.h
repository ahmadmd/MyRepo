//
//  IntroDataSource.h
//  scrollDynamicLoadingTest
//
//  Created by Zoondia on 01/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntroDataSource : NSObject

+ (IntroDataSource *)sharedDataSource;
- (NSInteger)numDataPages:(BOOL)fromLoginPage;
- (NSString *)dataForPage:(NSInteger)pageIndex pageType:(BOOL)fromLoginPage;

@property (retain, nonatomic) NSArray *imageNames;
@property (retain, nonatomic) NSArray *imageUrls;

@end
