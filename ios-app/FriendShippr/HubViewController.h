//
//  HubViewController.h
//  FriendShippr
//
//  Created by Zoondia on 30/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HubTableController.h"

@class HubTableController;

@interface HubViewController : UIViewController

@property(nonatomic,retain)HubTableController *hubTableController;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentSelect;

@end
