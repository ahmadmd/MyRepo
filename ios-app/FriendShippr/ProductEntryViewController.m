//
//  ProductEntryViewController.m
//  FriendShippr
//
//  Created by Zoondia on 22/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "ProductEntryViewController.h"
#import "SBJson.h"

@interface ProductEntryViewController ()

@end

@implementation ProductEntryViewController
@synthesize productNameArray,productListTable,productSearchBar,productLoadActivity,fetcher,textFieldHolder,reader,scannerOverlay,bttnScan,bgTextField,bgImageHolder,productImageUrlArray;//,shouldCloseModal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)bttnActionScanButtonTapped:(id)sender{
    if(self.textFieldHolder.frame.origin.y!=0){
        [UIView animateWithDuration:0.3 animations:^{
            [self.bgTextField setFrame:CGRectMake(0, 0, 320, 47)];
            [self.bttnScan setFrame:CGRectMake(263, 7, 46, 35)];
            [self.textFieldHolder setFrame:CGRectMake(self.textFieldHolder.frame.origin.x, 0, self.textFieldHolder.frame.size.width, self.textFieldHolder.frame.size.height)];
            [self.productSearchBar setFrame:CGRectMake(17, 6, 292, 36)];
            self.bgImageHolder.alpha=0;
        }completion:^(BOOL finished){
            [self.productListTable setHidden:NO];
            self.bgTextField.image=[UIImage imageNamed:@"barcode_search.png"];
            self.bgImageHolder.image=nil;
        }];
    }
    
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

//Performs a simple and fixed query to products endpoint.
-(void)performQueryWithKeyword:(NSString*)searchKey isBarcodeSearch:(BOOL)isBarcode
{
    isBarcodeSearch=isBarcode;
    [self.productLoadActivity startAnimating];
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

-(void)bttnActionClose:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissBarcodeScanner:(ZBarSymbol*) symbol{
    [self.reader dismissViewControllerAnimated:YES completion:^{
        [self performQueryWithKeyword:symbol.data isBarcodeSearch:YES];
    }];
}

- (IBAction)btttnActionScanningDone:(id)sender {
    [self.reader dismissModalViewControllerAnimated:YES];
}

#pragma mark UIViewController Delegates

-(void)dealloc{
    [productSearchBar release];
    [productListTable release];
    [productLoadActivity release];
    [productNameArray release];
    [productImageUrlArray release];
    [textFieldHolder release];
    [scannerOverlay release];
    [reader release];
    [bgTextField release];
    [bttnScan release];
    [bgImageHolder release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=@"Shipping Request";
    
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
    
    productNameArray=[[NSMutableArray alloc] init];
    productImageUrlArray=[[NSMutableArray alloc] init];
    [self.productNameArray addObject:@"Search for products..."];
    [self.productListTable reloadData];
    
    [self.productListTable setHidden:YES];
    self.textFieldHolder.frame=CGRectMake(self.textFieldHolder.frame.origin.x, self.view.frame.size.height/2-35, self.textFieldHolder.frame.size.width, self.textFieldHolder.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated{
        fetcher=[[OADataFetcher alloc] init];
}

-(void)viewWillDisappear:(BOOL)animated{
        [fetcher release];
}

#pragma mark OAuth Delegate

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data{
    if (ticket.didSucceed)
    {
        NSString *response = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        //NSLog(@"responseBody=%@",response);
        NSDictionary *topDict=(NSDictionary*)[response JSONValue];
        if([self.productNameArray count]>0){
            [self.productNameArray removeAllObjects];
            [self.productImageUrlArray removeAllObjects];
        }
        if([[topDict objectForKey:@"results_count"] intValue]>0){
            
            NSArray *productsArray=(NSArray *)[topDict objectForKey:@"results"];
            NSDictionary *productDict;
            for (int i=0; i<[productsArray count]; i++) {
                productDict=(NSDictionary*)[productsArray objectAtIndex:i];
                [self.productNameArray addObject:[productDict objectForKey:@"name"]];
                if([[productDict objectForKey:@"images_total"] intValue]>0){
                    NSArray *imageArray=[productDict objectForKey:@"images"];
                    if(imageArray.count>0)
                        [self.productImageUrlArray addObject:[imageArray objectAtIndex:0]];
                }
                else{
                    //[self.productImageUrlArray addObject:No_product_url];
                    if([[NSUserDefaults standardUserDefaults] objectForKey:kFSNoProductImageUrlKey]!=nil){
                        [self.productImageUrlArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:kFSNoProductImageUrlKey]];
                    }
                    else{
                        [self.productImageUrlArray addObject:No_product_url];
                    }
                }
            }
            [self.productListTable reloadData];
        }
        else{
            if(self.productSearchBar.text.length>0){
                [self.productNameArray addObject:self.productSearchBar.text];
                //[self.productImageUrlArray addObject:No_product_url];
                if([[NSUserDefaults standardUserDefaults] objectForKey:kFSNoProductImageUrlKey]!=nil){
                    [self.productImageUrlArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:kFSNoProductImageUrlKey]];
                }
                else{
                    [self.productImageUrlArray addObject:No_product_url];
                }
            }
            else{
                [self.productNameArray addObject:@"Search for products..."];
            }
            [self.productListTable reloadData];
            if(isBarcodeSearch){
                [Common showAlertwithTitle:nil alertString:@"No product matches for the barcode scanned" cancelbuttonName:@"OK"];
            }
            NSLog(@"No products found");
        }
        
        [response release];
    }
    else{
        NSLog(@"did not succeed");
    }
    [self.productLoadActivity stopAnimating];
    self.navigationItem.rightBarButtonItem.enabled=YES;
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error{
   // NSLog(@"Request did fail with error: %@", [error localizedDescription]);
    [Common showAlertwithTitle:@"Network Error" alertString:[error localizedDescription] cancelbuttonName:@"OK"];
    [self.productLoadActivity stopAnimating];
    self.navigationItem.rightBarButtonItem.enabled=YES;
}


#pragma mark zBar delegates

- (void) imagePickerController: (UIImagePickerController*) barcodeReader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    NSLog(@"####symbol.data=%@",symbol.data);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissBarcodeScanner:) object:symbol];
	[self performSelector:@selector(dismissBarcodeScanner:) withObject:symbol afterDelay:0.5];
    
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    
    
    // EXAMPLE: do something useful with the barcode image
   // resultImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    
}


#pragma mark UITextField Delegates

- (IBAction)textFieldTextChanged:(id)sender {
    [self performQueryWithKeyword:((UITextField*)sender).text isBarcodeSearch:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   // textField.text=@"";
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(self.textFieldHolder.frame.origin.y!=0){
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgTextField setFrame:CGRectMake(0, 0, 320, 47)];
        [self.bttnScan setFrame:CGRectMake(263, 7, 46, 35)];
        [self.textFieldHolder setFrame:CGRectMake(self.textFieldHolder.frame.origin.x, 0, self.textFieldHolder.frame.size.width, self.textFieldHolder.frame.size.height)];
        [self.productSearchBar setFrame:CGRectMake(17, 6, 292, 36)];
        self.bgImageHolder.alpha=0;
    }completion:^(BOOL finished){
        [self.productListTable setHidden:NO];
        self.bgTextField.image=[UIImage imageNamed:@"barcode_search.png"];
        self.bgImageHolder.image=nil;
        //self.bgImageHolder.hidden=YES;
    }];
    }
}

#pragma mark TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.productNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"productListCell";
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row%2==0){
        cell.backgroundColor=[UIColor colorWithRed:0.94509 green:0.956862 blue:0.984313 alpha:1];
    }
    else{
        cell.backgroundColor=[UIColor whiteColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        if(![[self.productNameArray objectAtIndex:indexPath.row] isEqualToString:@"Search for products..."]){
            self.productSearchBar.text=@"";
            [self.productSearchBar resignFirstResponder];
            
            ProductSelectViewController *productSel=[[ProductSelectViewController alloc] initWithNibName:@"ProductSelectViewController" bundle:[NSBundle mainBundle]];
            productSel.selectedProduct=(NSString*)[self.productNameArray objectAtIndex:indexPath.row];
            productSel.selectedProductImageUrl=(NSString*)[self.productImageUrlArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:productSel animated:YES];
            [productSel release];
        }
    }
    else{
        self.productSearchBar.text=@"";
        [self.productSearchBar resignFirstResponder];
        
        ProductSelectViewController *productSel=[[ProductSelectViewController alloc] initWithNibName:@"ProductSelectViewController" bundle:[NSBundle mainBundle]];
        productSel.selectedProduct=(NSString*)[self.productNameArray objectAtIndex:indexPath.row];
        productSel.selectedProductImageUrl=(NSString*)[self.productImageUrlArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:productSel animated:YES];
        [productSel release];
    }
}

@end
