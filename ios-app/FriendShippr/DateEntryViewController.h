//
//  DateEntryViewController.h
//  FriendShippr
//
//  Created by Zoondia on 06/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
#import "ShippingRequestObject.h"
#import "RouteConfirmViewController.h"

@interface DateEntryViewController : UIViewController<CKCalendarDelegate>

@property(nonatomic, retain) NSDate *minimumDate;
@property(nonatomic, retain) CKCalendarView *calendar;
@property (retain, nonatomic) IBOutlet UIView *headingHolder;
@end
