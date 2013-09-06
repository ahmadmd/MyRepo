//
//  KarmaPointsViewController.h
//  FriendShippr
//
//  Created by Zoondia on 29/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "ShippingRequestObject.h"
#import "RequestConfirmViewController.h"

@interface KarmaPointsViewController : UIViewController

- (IBAction)bttnActionDecreaseKarma:(id)sender;
- (IBAction)bttnActionIncreaseKarma:(id)sender;
- (IBAction)bttnActionBuyMoreKarma:(id)sender;
- (IBAction)bttnActionForward:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblAvailableKarma;
@property (retain, nonatomic) IBOutlet UITextField *txtSelectKarma;
@end
