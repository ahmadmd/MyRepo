//
//  PopoverViewController.h
//  FriendShippr
//
//  Created by Zoondia on 19/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *bttnShipReq;
@property (retain, nonatomic) IBOutlet UIButton *bttnTravelRoute;

- (IBAction)bttnActionShippingRequest:(id)sender;
- (IBAction)bttnActionTravelRoute:(id)sender;
@end
