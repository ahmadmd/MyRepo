//
//  ProductSelectViewController.h
//  FriendShippr
//
//  Created by Zoondia on 23/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedProductCell.h"
#import "PickUpPointViewController.h"
#import "ShippingRequestObject.h"
#import "SBJson.h"
#import "OAuthConsumer.h"
#import "ZBarSDK.h"

@interface ProductSelectViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ZBarReaderDelegate>{
    BOOL isBarcodeSearch;
}

@property(nonatomic,retain)NSMutableArray *productNameArray;
@property(nonatomic,retain)NSMutableArray *productImgUrlArray;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *productLoadActivity;
@property (retain, nonatomic) IBOutlet UIToolbar *keyBoardDoneView;
@property(nonatomic,retain)NSString *selectedProduct;
@property(nonatomic,retain)NSString *selectedProductImageUrl;
@property(nonatomic,retain)NSMutableArray *selectedProductArray;
@property (retain, nonatomic) IBOutlet UITableView *selectedProductTable;
@property (retain, nonatomic) IBOutlet UITextField *txtProductSearch;
@property (retain, nonatomic) IBOutlet UITableView *listProductsTable;
@property(nonatomic,retain)OADataFetcher *fetcher;
@property (retain, nonatomic) ZBarReaderViewController *reader;
@property (retain, nonatomic) IBOutlet UIView *scannerOverlay;
- (IBAction)bttnActionDone:(id)sender;
- (IBAction)bttnActionForward:(id)sender;
- (IBAction)bttnActionScanningDone:(id)sender;
- (IBAction)bttnActionScanningTapped:(id)sender;
@end
