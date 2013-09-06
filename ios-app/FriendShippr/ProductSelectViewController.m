//
//  ProductSelectViewController.m
//  FriendShippr
//
//  Created by Zoondia on 23/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "ProductSelectViewController.h"

@interface ProductSelectViewController ()

@end

@implementation ProductSelectViewController
@synthesize selectedProduct,selectedProductArray,selectedProductTable,keyBoardDoneView,listProductsTable,txtProductSearch,fetcher,productLoadActivity,productNameArray,productImgUrlArray,scannerOverlay,reader,selectedProductImageUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)bttnActionClose:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)bttnActionGoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//Performs a simple and fixed query to products endpoint.
-(void)performQueryWithKeyword:(NSString*)searchKey isBarcodeSearch:(BOOL)isBarcode
{
    isBarcodeSearch=isBarcode;
    [self.productLoadActivity startAnimating];
    self.navigationItem.leftBarButtonItem.enabled=NO;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:Semantic_OAUTH_KEY
                                                    secret:Semantic_OAUTH_SECRET];
    
    NSURL *url = [NSURL URLWithString:Semantic_API_Endpoint];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil
                                                                      realm:nil
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    
    [request setHTTPMethod:@"GET"];
    [consumer release];
    
    NSDictionary *dict=nil;
    if(isBarcode){
        dict=[[NSDictionary alloc] initWithObjectsAndKeys:searchKey,@"upc", nil];
    }
    else{
        dict=[[NSDictionary alloc] initWithObjectsAndKeys:searchKey,@"search", nil];
    }
    
    OARequestParameter * qParam = [[OARequestParameter alloc] initWithName:@"q" value:[dict JSONRepresentation]];
    [dict release];
    
    NSArray *params = [NSArray arrayWithObjects:qParam, nil];
    [qParam release];
    
    [request setParameters:params];
    
    
    [self.fetcher.connection cancel];
    [self.fetcher fetchDataWithRequest:request delegate:self didFinishSelector:@selector(requestTokenTicket:didFinishWithData:) didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
    [request release];
    
}

- (IBAction)bttnActionDone:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)bttnActionForward:(id)sender {
    if([self.selectedProductArray count]>0){
        PickUpPointViewController *pickUp=[[PickUpPointViewController alloc] initWithNibName:@"PickUpPointViewController" bundle:[NSBundle mainBundle]];
        [ShippingRequestObject sharedInstance].productsArray=self.selectedProductArray;
        pickUp.isFromShippingReq=YES;
        [self.navigationController pushViewController:pickUp animated:YES];
        [pickUp release];
    }
    else{
        [Common showAlertwithTitle:nil alertString:@"Please select a product!" cancelbuttonName:@"OK"];
    }
    
}

- (IBAction)bttnActionScanningDone:(id)sender {
    self.listProductsTable.hidden=YES;
    [self.reader dismissModalViewControllerAnimated:YES];
}

- (IBAction)bttnActionScanningTapped:(id)sender {
    //self.listProductsTable.hidden=NO;
    // self.productLoadActivity.hidden=YES;
    self.reader = [ZBarReaderViewController new];
    self.reader.tracksSymbols=YES;
    self.reader.showsZBarControls=NO;
    self.reader.readerDelegate = self;
    self.reader.supportedOrientationsMask = ZBarOrientationMask(1) ;
    self.reader.cameraOverlayView=self.scannerOverlay;
    
    //ZBarImageScanner *scanner = reader.scanner;
    // additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    //[scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    
    // present and release the controller
    [self presentModalViewController:self.reader animated: YES];
    [reader release];
}

#pragma mark UIViewController Delegates

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}


-(void)dealloc{
    [selectedProductArray release];
    [selectedProductTable release];
    [keyBoardDoneView release];
    [listProductsTable release];
    [txtProductSearch release];
    [productLoadActivity release];
    [productNameArray release];
    [productImgUrlArray release];
    [scannerOverlay release];
    [selectedProduct release];
    [selectedProductImageUrl release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"Shipping Request";
    
    UIImage *leftimage = [UIImage imageNamed:navBarBackBttn];
    CGRect frameimg = CGRectMake(0, 0, leftimage.size.width, leftimage.size.height);
    UIButton *leftButton = [[UIButton alloc] initWithFrame:frameimg];
    [leftButton setBackgroundImage:leftimage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(bttnActionGoBack:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarbutton =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=leftBarbutton;
    [leftButton release];
    [leftBarbutton release];
    
    UIImage* rightImage = [UIImage imageNamed:navBarRightCloseBttn];
    CGRect rightImageframe = CGRectMake(0, 0, 16, 16);
    UIButton *rightButton = [[UIButton alloc] initWithFrame:rightImageframe];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(bttnActionClose:)
          forControlEvents:UIControlEventTouchUpInside];
    [rightButton setShowsTouchWhenHighlighted:NO];
    
    UIBarButtonItem *rightBarbutton =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightBarbutton;
    [rightButton release];
    [rightBarbutton release];
   // NSLog(@"********self.selectedProductImageUrl=%@",self.selectedProductImageUrl);
    selectedProductArray=[[NSMutableArray alloc] init];
    [self.selectedProductArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:self.selectedProduct,@"name",[NSNumber numberWithInt:1],@"quantity",self.selectedProductImageUrl,@"imageUrl", nil]];
    
    self.listProductsTable.hidden=YES;
    self.productLoadActivity.hidden=YES;
    productNameArray=[[NSMutableArray alloc] init];
    productImgUrlArray=[[NSMutableArray alloc] init];
    [self.productNameArray addObject:@"Search for products..."];
    [self.listProductsTable reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quantityChangedNotifRecieved:) name:@"quantityChangedNotif" object:nil];
    [self.selectedProductTable reloadData];
    fetcher=[[OADataFetcher alloc] init];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"quantityChangedNotif" object:nil];
    [fetcher release];
}

#pragma mark OAuth Delegate

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data{
    if (ticket.didSucceed)
    {
        NSString *response = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
        // NSLog(@"responseBody=%@",response);
        NSDictionary *topDict=(NSDictionary*)[response JSONValue];
        if([self.productNameArray count]>0){
            [self.productNameArray removeAllObjects];
            [self.productImgUrlArray removeAllObjects];
        }
        if([[topDict objectForKey:@"results_count"] intValue]>0){
            if(isBarcodeSearch){
                self.txtProductSearch.text=@"";
                [self.txtProductSearch resignFirstResponder];
                self.listProductsTable.hidden=YES;
                self.productLoadActivity.hidden=YES;
                NSArray *productsArray=(NSArray *)[topDict objectForKey:@"results"];
                NSDictionary *productDict;
                NSString *imgUrl=nil;
                for (int i=0; i<[productsArray count]; i++) {
                    productDict=(NSDictionary*)[productsArray objectAtIndex:i];
                    
                    if([[productDict objectForKey:@"images_total"] intValue]>0){
                        NSArray *imageArray=[productDict objectForKey:@"images"];
                        if(imageArray.count>0)
                            imgUrl=[imageArray objectAtIndex:0];
                    }
                    else{
                        imgUrl=No_product_url;
                    }
                    
                    [self.selectedProductArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[productDict objectForKey:@"name"],@"name",[NSNumber numberWithInt:1],@"quantity",imgUrl,@"imageUrl", nil]];
                    [self updateTableSectionsAdd:[self.selectedProductArray count]-1];
                }
                [self.selectedProductTable reloadData];
            }
            else{
                NSArray *productsArray=(NSArray *)[topDict objectForKey:@"results"];
                NSDictionary *productDict;
                for (int i=0; i<[productsArray count]; i++) {
                    productDict=(NSDictionary*)[productsArray objectAtIndex:i];
                    [self.productNameArray addObject:[productDict objectForKey:@"name"]];
                    if([[productDict objectForKey:@"images_total"] intValue]>0){
                        NSArray *imageArray=[productDict objectForKey:@"images"];
                        if(imageArray.count>0)
                            [self.productImgUrlArray addObject:[imageArray objectAtIndex:0]];
                    }
                    else{
                       // [self.productImgUrlArray addObject:No_product_url];
                        if([[NSUserDefaults standardUserDefaults] objectForKey:kFSNoProductImageUrlKey]!=nil){
                            [self.productImgUrlArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:kFSNoProductImageUrlKey]];
                        }
                        else{
                            [self.productImgUrlArray addObject:No_product_url];
                        }
                    }
                }
                [self.listProductsTable reloadData];
            }
        }
        else{
            if(self.txtProductSearch.text.length>0){
                [self.productNameArray addObject:self.txtProductSearch.text];
                //[self.productImgUrlArray addObject:No_product_url];
                if([[NSUserDefaults standardUserDefaults] objectForKey:kFSNoProductImageUrlKey]!=nil){
                    [self.productImgUrlArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:kFSNoProductImageUrlKey]];
                }
                else{
                    [self.productImgUrlArray addObject:No_product_url];
                }
            }
            else{
                [self.productNameArray addObject:@"Search for products..."];
            }
            [self.listProductsTable reloadData];
            if(isBarcodeSearch){
                [Common showAlertwithTitle:nil alertString:@"No product matches for the barcode scanned" cancelbuttonName:@"OK"];
            }
            
            //[self.productNameArray addObject:self.txtProductSearch.text];
            //[self.listProductsTable reloadData];
            NSLog(@"No products found");
        }
        
        [response release];
    }
    else{
        NSLog(@"did not succeed");
    }
    [self.productLoadActivity stopAnimating];
    self.navigationItem.leftBarButtonItem.enabled=YES;
    self.navigationItem.rightBarButtonItem.enabled=YES;
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error{
    // NSLog(@"Request did fail with error: %@", [error localizedDescription]);
    [Common showAlertwithTitle:@"Network Error" alertString:[error localizedDescription] cancelbuttonName:@"OK"];
    [self.productLoadActivity stopAnimating];
    self.navigationItem.leftBarButtonItem.enabled=YES;
    self.navigationItem.rightBarButtonItem.enabled=YES;
}

#pragma mark zBar delegates

- (void) imagePickerController: (UIImagePickerController*) barcodeReader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    //self.listProductsTable.hidden=NO;
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    NSLog(@"####symbol.data=%@",symbol.data);
    [barcodeReader dismissModalViewControllerAnimated: YES];
    [self performQueryWithKeyword:symbol.data isBarcodeSearch:YES];
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    
    
    // EXAMPLE: do something useful with the barcode image
    // resultImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    
}

#pragma mark TextField Delegates

- (IBAction)textFieldDidChangeText:(UITextField *)sender {
    [self performQueryWithKeyword:self.txtProductSearch.text isBarcodeSearch:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.text=@"";
    [textField resignFirstResponder];
    self.listProductsTable.hidden=YES;
    self.productLoadActivity.hidden=YES;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //if([self.productNameArray count]>0){
      //  NSLog(@"entered");
        [self.productNameArray removeAllObjects];
    [self.productImgUrlArray removeAllObjects];
        [self.productNameArray addObject:@"Search for products..."];
   // }
    [self.listProductsTable reloadData];
    self.listProductsTable.hidden=NO;
    self.productLoadActivity.hidden=YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //self.listProductsTable.hidden=YES;
    //self.productLoadActivity.hidden=YES;
}

#pragma mark TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView.tag==1){
        return [self.selectedProductArray count];
    }
    else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==1){
        return 1;
    }
    else{
        return [self.productNameArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag==1){
    SelectedProductCell *cell = (SelectedProductCell *) [tableView dequeueReusableCellWithIdentifier:[SelectedProductCell reuseIdentifier]];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SelectedProductCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (SelectedProductCell *)currentObject;
                cell.txtQuantity.inputAccessoryView=self.keyBoardDoneView;
                
                UIButton *bttnUnFav=[[UIButton alloc] init];
                bttnUnFav.frame=CGRectMake(265, 8, 30, 30);
                bttnUnFav.autoresizingMask=UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
                [bttnUnFav addTarget:self action:@selector(bttnActionDeleteSelectedProduct:) forControlEvents:UIControlEventTouchUpInside];
                [bttnUnFav setTitle:@"" forState:UIControlStateNormal];
                [bttnUnFav setBackgroundImage:[UIImage imageNamed:@"closebtn.png"] forState:UIControlStateNormal];
                [cell.contentView addSubview:bttnUnFav];
                [bttnUnFav release];
                
                break;
            }
        }
    }
        
    
    NSMutableDictionary *productDict=[self.selectedProductArray objectAtIndex:indexPath.section];
    cell.lblProductName.text=[productDict objectForKey:@"name"];
    cell.txtQuantity.text=[NSString stringWithFormat:@"%d",[[productDict objectForKey:@"quantity"] intValue]];
    return cell;
    }
    else{
        static NSString *cellIdentifier=@"productListingCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell==nil){
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.textLabel.font=[UIFont systemFontOfSize:12];
            cell.textLabel.numberOfLines=0;
            cell.textLabel.lineBreakMode=UILineBreakModeWordWrap;
        }
        cell.textLabel.text=[self.productNameArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag==2){
        if(indexPath.row%2==0){
            cell.backgroundColor=[UIColor colorWithRed:0.94509 green:0.956862 blue:0.984313 alpha:1];
        }
        else{
            cell.backgroundColor=[UIColor whiteColor];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag==1){
        NSString *str=nil;
        str=[[self.selectedProductArray objectAtIndex:indexPath.section] objectForKey:@"name"];
        CGSize size = [str sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(205, 999) lineBreakMode:UILineBreakModeWordWrap];
        if((size.height+10)>44){
            return size.height+10;
        }
        else{
            return 44;
        }
    }
    else{
        NSString *str=nil;
        str=[self.productNameArray objectAtIndex:indexPath.row];
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 999) lineBreakMode:UILineBreakModeWordWrap];
        if((size.height+10)>44){
            return size.height+10;
        }
        else{
            return 44;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==2){
        self.txtProductSearch.text=@"";
        [self.txtProductSearch resignFirstResponder];
        self.listProductsTable.hidden=YES;
        self.productLoadActivity.hidden=YES;
        [self.selectedProductArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[self.productNameArray objectAtIndex:indexPath.row],@"name",[NSNumber numberWithInt:1],@"quantity",[self.productImgUrlArray objectAtIndex:indexPath.row],@"imageUrl", nil]];
        [self updateTableSectionsAdd:[self.selectedProductArray count]-1];
    }
}

-(void)bttnActionDeleteSelectedProduct:(id)sender{
    UIButton *bttn=(UIButton*)sender;
    if([bttn.superview.superview isKindOfClass:[SelectedProductCell class]]){
        SelectedProductCell *cell = (SelectedProductCell *)bttn.superview.superview;
        NSIndexPath *indexPath = [self.selectedProductTable indexPathForCell:cell];
        
        [self.selectedProductArray removeObjectAtIndex:indexPath.section];
        [self updateTableSectionsDel:indexPath.section];
    }
}

-(void) updateTableSectionsDel:(NSInteger)sec{
    [self.selectedProductTable beginUpdates];
    [self.selectedProductTable deleteSections:[NSIndexSet indexSetWithIndex:sec] withRowAnimation:UITableViewRowAnimationFade];
    [self.selectedProductTable endUpdates];
    
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadTableView) object:nil];
    //[self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.3];
    
}

-(void) updateTableSectionsAdd:(NSInteger)sec{
    [self.selectedProductTable beginUpdates];
    [self.selectedProductTable insertSections:[NSIndexSet indexSetWithIndex:sec] withRowAnimation:UITableViewRowAnimationFade];
    [self.selectedProductTable endUpdates];
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadTableView) object:nil];
    //[self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.3];
    
}

-(void)reloadTableView{
    [self.selectedProductTable reloadData];
}

#pragma mark NSSNotification function

- (void) quantityChangedNotifRecieved:(NSNotification*) notification {
    SelectedProductCell *cell=(SelectedProductCell *)notification.object;
    NSIndexPath *indexPath = [self.selectedProductTable indexPathForCell:cell];
    [((NSMutableDictionary*)[self.selectedProductArray objectAtIndex:indexPath.section]) setObject:[NSNumber numberWithInt:[cell.txtQuantity.text intValue]] forKey:@"quantity"];
}

@end
