//
//  ProductEntryViewController.h
//  FriendShippr
//
//  Created by Zoondia on 22/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "OAuthConsumer.h"
#import "Common.h"
#import "ProductSelectViewController.h"
#import "ZBarSDK.h"

@interface ProductEntryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ZBarReaderDelegate>{
    BOOL isBarcodeSearch;
}

@property (retain, nonatomic) IBOutlet UIImageView *bgImageHolder;
@property (retain, nonatomic) IBOutlet UIButton *bttnScan;
@property (retain, nonatomic) IBOutlet UIImageView *bgTextField;
@property(nonatomic,retain)NSMutableArray *productNameArray;
@property(nonatomic,retain)NSMutableArray *productImageUrlArray;
@property (retain, nonatomic) IBOutlet UITextField *productSearchBar;
@property (retain, nonatomic) IBOutlet UITableView *productListTable;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *productLoadActivity;
//@property (assign,nonatomic) BOOL shouldCloseModal;
@property (nonatomic,retain) OADataFetcher *fetcher;
@property (retain, nonatomic) IBOutlet UIView *textFieldHolder;
@property (retain, nonatomic) IBOutlet UIView *scannerOverlay;
@property (retain, nonatomic) ZBarReaderViewController *reader;

- (IBAction)btttnActionScanningDone:(id)sender;
- (IBAction)textFieldTextChanged:(id)sender;
-(IBAction)bttnActionScanButtonTapped:(id)sender;

@end
