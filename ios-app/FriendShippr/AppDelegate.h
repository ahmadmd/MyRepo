//
//  AppDelegate.h
//  FriendShippr
//
//  Created by Zoondia on 15/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "SlideLeftViewController.h"
#import "HubViewController.h"
#import "ShipmentsViewController.h"
#import "StoreViewController.h"
#import "RoutesViewController.h"
#import "Reachability.h"
#import "MyProfileViewController.h"

@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSURLConnectionDataDelegate>{
    NSMutableData *_data;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginViewController *viewController;

@property(nonatomic,retain)IIViewDeckController* deckController;

@property(nonatomic,retain) UINavigationController *myProfileNavigation;

@property(nonatomic,retain) UINavigationController *homeNavigation;

@property(nonatomic,retain) UINavigationController *hubNavigation;

@property(nonatomic,retain) UINavigationController *shipmentsNavigation;

@property(nonatomic,retain) UINavigationController *routesNavigation;

@property(nonatomic,retain) UINavigationController *storeNavigation;

@property (nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;
- (void)logoutUser;

@end
