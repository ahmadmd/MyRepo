//
//  PaymentTermsViewController.m
//  FriendShippr
//
//  Created by Zoondia on 25/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "PaymentTermsViewController.h"

@interface PaymentTermsViewController ()

@end

@implementation PaymentTermsViewController
@synthesize paymentTermsTable;

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

-(void)goToKarmaViewController:(DeliveryDateCell*)cell{
    KarmaPointsViewController *paymentView=[[KarmaPointsViewController alloc] initWithNibName:@"KarmaPointsViewController" bundle:[NSBundle mainBundle]];
    if([cell.lblHeadingText.text isEqualToString:@"Will transfer money"]){
        [ShippingRequestObject sharedInstance].paymentTerms=@"skrill";
    }
    else if ([cell.lblHeadingText.text isEqualToString:@"Pick up only"]){
        [ShippingRequestObject sharedInstance].paymentTerms=@"noPay";
    }
    else{
        [ShippingRequestObject sharedInstance].paymentTerms=@"cod";
    }
    [self.paymentTermsTable setUserInteractionEnabled:YES];
    [self.navigationController pushViewController:paymentView animated:YES];
    [paymentView release];
    
}

#pragma mark UIViewController Delegates

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
}

-(void)viewWillAppear:(BOOL)animated{
    //[self.paymentTermsTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [paymentTermsTable release];
    [super dealloc];
}


#pragma mark TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeliveryDateCell *cell =nil;
    //(DeliveryDateCell *) [tableView dequeueReusableCellWithIdentifier:[DeliveryDateCell reuseIdentifier]];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DeliveryDateCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (DeliveryDateCell *)currentObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                break;
            }
        }
    }
    if(indexPath.row%2==0){
        cell.contentView.backgroundColor=[UIColor colorWithRed:0.94509 green:0.956862 blue:0.984313 alpha:1];
    }
    else{
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    if(indexPath.row==0){
        cell.lblHeadingText.text=@"Will transfer money";
        cell.lblSubHeadingText.text=@"send money with skrill";
    }
    else if (indexPath.row==1){
        cell.lblHeadingText.text=@"Pick up only";
        cell.lblSubHeadingText.text=@"item is paid for";
    }
    else{
        cell.lblHeadingText.text=@"Cash on delivery";
        cell.lblSubHeadingText.text=@"shipper will be reimbursed";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.paymentTermsTable setUserInteractionEnabled:NO];
    [self.paymentTermsTable reloadData];
    DeliveryDateCell *cell =(DeliveryDateCell*) [tableView cellForRowAtIndexPath:indexPath];
    cell.tickImageView.image=[UIImage imageNamed:@"transfered@2x.png"];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(goToKarmaViewController:) object:cell];
	[self performSelector:@selector(goToKarmaViewController:) withObject:cell afterDelay:0.5];
}


@end
