//
//  SlideViewController.h
//  FriendShippr
//
//  Created by Zoondia on 20/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HubCustomCell.h"
#import <Parse/Parse.h>

@class HubCustomCell;

@interface SlideViewController : UIViewController

@property(nonatomic,assign) NSInteger pageIndex;
@property (retain, nonatomic) IBOutlet UIImageView *productImgView;
@property (retain, nonatomic) HubCustomCell *currentCell;

@end
