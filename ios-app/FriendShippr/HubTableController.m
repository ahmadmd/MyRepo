#import <UIKit/UIKit.h>
#import "HubTableController.h"
#import "Parse/Parse.h"
#import "RequestFeedsCustomCell.h"

@implementation HubTableController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = kFSRequestClassKey;
        
        // Whether the built-in pull-to-refresh is enabled
        if (NSClassFromString(@"UIRefreshControl")) {
            self.pullToRefreshEnabled = NO;
        } else {
            self.pullToRefreshEnabled = YES;
        }
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 4;
        
    }
    return self;
}

//to check whether shipping request is expired..
-(BOOL)shippingRequestIsExpired:(NSDate*)expireDate{
    NSDate *currentDate=[NSDate date];
    /*NSDate *expireDate;
    if([deliveryType isEqualToString:@"rush"]){
        expireDate= [Common addDays:2 toDate:createdAt];
    }
    else if ([deliveryType isEqualToString:@"week"]){
        expireDate= [Common addDays:7 toDate:createdAt];
    }
    else{
        expireDate= [Common addDays:30 toDate:createdAt];
    }*/
    
    if([currentDate compare:expireDate]==NSOrderedAscending){
        return NO;
    }
    else if([currentDate compare:expireDate]==NSOrderedDescending){
        return YES;
    }
    else{
        return YES;
    }
}


- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    [self loadObjects];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor=[UIColor clearColor];
    
    if (NSClassFromString(@"UIRefreshControl")) {
        // Use the new iOS 6 refresh control.
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl = refreshControl;
        [refreshControl release];
        self.refreshControl.tintColor = [UIColor lightGrayColor];
        [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.pullToRefreshEnabled = NO;
    }
    
    if(self.pullToRefreshEnabled){
        for(UIView *view in self.view.subviews){
            if([view isKindOfClass:[PF_EGORefreshTableHeaderView class]]){
                PF_EGORefreshTableHeaderView *refreshView=(PF_EGORefreshTableHeaderView*)view;
                refreshView.backgroundColor=[UIColor clearColor];
                refreshView.statusLabel.textColor=[UIColor blackColor];
                refreshView.lastUpdatedLabel.textColor=[UIColor blackColor];
                refreshView.activityView.color=[UIColor blackColor];
            }
        }
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestRepostNotifRecieved:) name:FSShippingRequestRepostCellNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productScrollChangedNotifRecieved:) name:FSProductScrollCellContentChangedNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FSShippingRequestRepostCellNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FSProductScrollCellContentChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark NSSNotification function

- (void) requestRepostNotifRecieved:(NSNotification*) notification {
    // HubCustomCell *cell=(HubCustomCell *)notification.object;
    // NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ProductEntryViewController *productEntry=[[ProductEntryViewController alloc] initWithNibName:@"ProductEntryViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *shippingFlowNav=[[UINavigationController alloc] initWithRootViewController:productEntry];
    [self presentModalViewController:shippingFlowNav animated:YES];
    [productEntry release];
    [shippingFlowNav release];
}

- (void) productScrollChangedNotifRecieved:(NSNotification*) notification {
    NSDictionary *notifDict=notification.object;
    RequestFeedsCustomCell *requestCell=[notifDict objectForKey:@"cell"];
    int pageNum=[[notifDict objectForKey:@"pageNum"] intValue];
    
    
    PFObject *ShipReq=[self.objects objectAtIndex:((NSIndexPath*)[self.tableView indexPathForCell:requestCell]).row];
    NSArray *productsArray=[ShipReq objectForKey:@"items"];
    requestCell.lblProductShippingName.text=[NSString stringWithFormat:@"Would like to ship %@",[[productsArray objectAtIndex:pageNum] objectForKey:@"name"]];
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    // This method is called every time objects are loaded from Parse via the PFQuery
    if (NSClassFromString(@"UIRefreshControl")) {
        [self.refreshControl endRefreshing];
    }
}


// Query to perform on the class..
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kFSRequestFromUserKey equalTo:[PFUser currentUser]];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)shippingObject {
    
    RequestFeedsCustomCell *cell = (RequestFeedsCustomCell *) [tableView dequeueReusableCellWithIdentifier:[RequestFeedsCustomCell reuseIdentifierHub]];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RequestFeedsCustomCellHub" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (RequestFeedsCustomCell *)currentObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.lblTimeDisplay.hidden=YES;
                
                cell.tableImageHolder.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
                [cell.tableImageHolder setFrame:CGRectMake(4, 32, cell.contentView.frame.size.width-8, 135)];
                
                PFImageView *productImg=[[PFImageView alloc] initWithFrame:CGRectMake(13, 10, 45, 45)];
                productImg.tag=3;
                productImg.image=[UIImage imageNamed:@"placeholder.png"];
                [cell.contentView addSubview:productImg];
                [productImg release];
                
                UIImageView *expiredImg=[[UIImageView alloc] initWithFrame:CGRectMake(190, 110, 119, 37)];
                expiredImg.image=[UIImage imageNamed:@"expired.png"];
                expiredImg.tag=4;
                [cell.contentView addSubview:expiredImg];
                
                UILabel *lblExpImg=[[UILabel alloc] initWithFrame:CGRectMake(43, 8, 73, 21)];
                lblExpImg.text=@"Expired";
                lblExpImg.textAlignment=UITextAlignmentLeft;
                lblExpImg.textColor=[UIColor blackColor];
                lblExpImg.font=[UIFont systemFontOfSize:18];
                lblExpImg.backgroundColor=[UIColor clearColor];
                [expiredImg addSubview:lblExpImg];
                
                expiredImg.hidden=YES;
                [lblExpImg release];
                [expiredImg release];
                
                UIImageView *verifiedImg=[[UIImageView alloc] initWithFrame:CGRectMake(185, 110, 124, 37)];
                verifiedImg.image=[UIImage imageNamed:@"verified.png"];
                verifiedImg.tag=5;
                [cell.contentView addSubview:verifiedImg];
                
                UILabel *lblVerified=[[UILabel alloc] initWithFrame:CGRectMake(43, 8, 73, 21)];
                lblVerified.text=@"Verified";
                lblVerified.textAlignment=UITextAlignmentLeft;
                lblVerified.textColor=[UIColor blackColor];
                lblVerified.font=[UIFont systemFontOfSize:18];
                lblVerified.backgroundColor=[UIColor clearColor];
                [verifiedImg addSubview:lblVerified];
                
                verifiedImg.hidden=YES;
                [lblVerified release];
                [verifiedImg release];
                
                UIImageView *deliveredImg=[[UIImageView alloc] initWithFrame:CGRectMake(173, 70, 137, 37)];
                deliveredImg.image=[UIImage imageNamed:@"delivered.png"];
                deliveredImg.tag=6;
                [cell.contentView addSubview:deliveredImg];
                
                UILabel *lbldelivered=[[UILabel alloc] initWithFrame:CGRectMake(43, 8, 83, 21)];
                lbldelivered.text=@"Delivered";
                lbldelivered.textAlignment=UITextAlignmentLeft;
                lbldelivered.textColor=[UIColor blackColor];
                lbldelivered.font=[UIFont systemFontOfSize:18];
                lbldelivered.backgroundColor=[UIColor clearColor];
                [deliveredImg addSubview:lbldelivered];
                
                deliveredImg.hidden=YES;
                [lbldelivered release];
                [deliveredImg release];
                
                break;
            }
        }
    }
    
    //get an image url array and set it to the cell to display the images..
    NSArray *productsArray=[shippingObject objectForKey:kFSRequestItemsKey];
    NSMutableArray *imageUrls=[[NSMutableArray alloc] initWithCapacity:[productsArray count]];
    NSDictionary *productDict;
    for(int i=0;i<[productsArray count];i++){
        productDict=[productsArray objectAtIndex:i];
        if([productDict objectForKey:@"imageUrl"]==nil){
            if([[NSUserDefaults standardUserDefaults] objectForKey:kFSNoProductImageUrlKey]!=nil){
                [imageUrls addObject:[[NSUserDefaults standardUserDefaults] objectForKey:kFSNoProductImageUrlKey]];
            }
            else{
                [imageUrls addObject:No_product_url];
            }
        }
        else{
            [imageUrls addObject:[productDict objectForKey:@"imageUrl"]];
        }
    }
    cell.imageUrls=imageUrls;
    [imageUrls release];
    [cell reloadTableData];
    
    //Ascertain whether shipping expired and show or hide repost button..
    if([self shippingRequestIsExpired:[shippingObject objectForKey:kFSRequestDeliveryDateKey]]){
        ((UIImageView*)[cell.contentView viewWithTag:4]).hidden=NO;
        cell.repostViewHolder.hidden=NO;
    }
    else{
        ((UIImageView*)[cell.contentView viewWithTag:4]).hidden=YES;
        cell.repostViewHolder.hidden=YES;
    }
    
    //user image..
    ((PFImageView*)[cell.contentView viewWithTag:3]).file = [[PFUser currentUser] objectForKey:kFSUserProfilePicSmallKey];
    [((PFImageView*)[cell.contentView viewWithTag:3]) loadInBackground];
    
    cell.lblKarmaPoints.text=[NSString stringWithFormat:@"%d points",[[shippingObject objectForKey:kFSRequestKarmaKey] intValue]];
    cell.lblShippingLocation.text=[NSString stringWithFormat:@"%@ -> %@",[shippingObject objectForKey:kFSRequestFromStreetKey],[shippingObject objectForKey:kFSRequestToStreetKey]];
    cell.lblCurrentUser.text=[[PFUser currentUser] objectForKey:kFSUserDisplayNameKey];
    cell.lblProductShippingName.text=[NSString stringWithFormat:@"Would like to ship %@",[[productsArray objectAtIndex:0] objectForKey:@"name"]];
    
    return cell;
}

//Load more cell customization
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPage";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.textAlignment=UITextAlignmentCenter;
        cell.textLabel.font=[UIFont systemFontOfSize:14];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = @"Load more...";
    
    return cell;
}

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Hub table didSelectRowAtIndexPath");
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.objects.count)
    {
        cell.backgroundColor=[UIColor colorWithRed:0.94509 green:0.956862 blue:0.984313 alpha:1];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //for load more cell height is less..
    if (indexPath.row == self.objects.count)
    {
        return 44;
    }
    else{
        PFObject *shippingReqObj=[self.objects objectAtIndex:indexPath.row];
        //if request expired height changes due to repost button..
        if ([self shippingRequestIsExpired:[shippingReqObj objectForKey:kFSRequestDeliveryDateKey]]) {
            return 308;
        }
        else{
            return 270;
        }
    }
}

#pragma mark UIScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    [super scrollViewDidScroll:sender];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)newScrollView
{
    if(self.pullToRefreshEnabled){
        [super scrollViewDidEndScrollingAnimation:newScrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView
{
    [super scrollViewDidEndDecelerating:newScrollView];
}

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */



@end