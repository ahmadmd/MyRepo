//
//  IntroPageDesign.h
//  scrollDynamicLoadingTest
//
//  Created by Zoondia on 01/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroDataSource.h"

@interface IntroPageDesign : UIViewController

@property(nonatomic,assign) NSInteger pageIndex;
@property (retain, nonatomic) IBOutlet UIImageView *introImageView;

@end
