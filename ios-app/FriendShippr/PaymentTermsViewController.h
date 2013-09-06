//
//  PaymentTermsViewController.h
//  FriendShippr
//
//  Created by Zoondia on 25/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryDateCell.h"
#import "Common.h"
#import "ShippingRequestObject.h"
#import "KarmaPointsViewController.h"

@interface PaymentTermsViewController : UIViewController<UITableViewDataSource,UITabBarDelegate>

@property (retain, nonatomic) IBOutlet UITableView *paymentTermsTable;
@end
