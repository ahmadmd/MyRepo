//
//  ViewController.h
//  FriendShippr
//
//  Created by Zoondia on 15/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "HomeViewController.h"
#import "Common.h"
#import "AppDelegate.h"
#import "IntroPageDesign.h"
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController<UIScrollViewDelegate,MBProgressHUDDelegate>{
    IntroPageDesign *currentPage;
	IntroPageDesign *nextPage;
    MBProgressHUD *progressHud;
}
@property (retain, nonatomic) IBOutlet UIScrollView *introScroll;
@property (retain, nonatomic) IBOutlet UIPageControl *pageNumberControl;
@property (retain, nonatomic) IBOutlet UIButton *bttnFBLogin;
@property (retain, nonatomic) IntroPageDesign *currentPage;
@property (retain, nonatomic) IntroPageDesign *nextPage;

- (IBAction)bttnActionFBLogin:(id)sender;
@end
