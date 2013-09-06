//
//  FeedsTableController.m
//  FriendShippr
//
//  Created by Zoondia on 23/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "FeedsTableController.h"

@interface FeedsTableController ()

@end

@implementation FeedsTableController
@synthesize friendsArray;

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productScrollChangedNotifRecieved:) name:FSProductScrollCellContentChangedNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FSProductScrollCellContentChangedNotification object:nil];
}

- (void) productScrollChangedNotifRecieved:(NSNotification*) notification {
    NSDictionary *notifDict=notification.object;
    RequestFeedsCustomCell *requestCell=[notifDict objectForKey:@"cell"];
    int pageNum=[[notifDict objectForKey:@"pageNum"] intValue];
    
    PFObject *activityObj=[self.objects objectAtIndex:((NSIndexPath*)[self.tableView indexPathForCell:requestCell]).row];
    if([[activityObj objectForKey:self.textKey] isEqualToString:kFSActivityTypeNewShippingRequest]){
        PFObject *ShipReq=[activityObj objectForKey:kFSActivityRequestKey];
        [ShipReq fetchIfNeededInBackgroundWithBlock:^(PFObject *shippingReq,NSError *error){
            NSArray *productsArray=[shippingReq objectForKey:@"items"];
            requestCell.lblProductShippingName.text=[NSString stringWithFormat:@"Would like to ship %@",[[productsArray objectAtIndex:pageNum] objectForKey:@"name"]];
        }];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // The className to query on
        self.parseClassName =kFSActivityClassKey;
        
        self.textKey = kFSActivityTypeKey;
        
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
-(BOOL)shippingRequestIsExpired:(NSString*)deliveryType createdDate:(NSDate*)createdAt{
    NSDate *currentDate=[NSDate date];
    NSDate *expireDate;
    if([deliveryType isEqualToString:@"rush"]){
        expireDate= [Common addDays:2 toDate:createdAt];
    }
    else if ([deliveryType isEqualToString:@"week"]){
        expireDate= [Common addDays:7 toDate:createdAt];
    }
    else{
        expireDate= [Common addDays:30 toDate:createdAt];
    }
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor=[UIColor clearColor];
    self.view.backgroundColor=[UIColor clearColor];
    
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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)dealloc{
    [super dealloc];
    [friendsArray release];
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
    PFQuery *activityQuery = [PFQuery queryWithClassName:self.parseClassName];
    [activityQuery whereKey:kFSActivityFromUserKey containedIn:self.friendsArray];
    [activityQuery includeKey:kFSActivityRouteKey];
    [activityQuery includeKey:kFSActivityRequestKey];
    [activityQuery includeKey:kFSActivityFromUserKey];
    //[activityQuery whereKey:@"requestId.deliveryDate" greaterThan:[NSDate date]];
    PFQuery *shippingExpireQuery = [PFQuery queryWithClassName:kFSRequestClassKey];
    [shippingExpireQuery whereKey:kFSActivityFromUserKey containedIn:self.friendsArray];
    [shippingExpireQuery whereKey:kFSRequestDeliveryDateKey lessThan:[NSDate date]];
    
    PFQuery *travelExpireQuery = [PFQuery queryWithClassName:kFSRouteClassKey];
    [travelExpireQuery whereKey:kFSActivityFromUserKey containedIn:self.friendsArray];
    [travelExpireQuery whereKey:kFSRouteDepartureDateKey lessThan:[NSDate date]];
    
    [activityQuery whereKey:kFSActivityRequestKey doesNotMatchQuery:shippingExpireQuery];
    [activityQuery whereKey:kFSActivityRouteKey doesNotMatchQuery:travelExpireQuery];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        activityQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        activityQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [activityQuery orderByDescending:@"createdAt"];
    
    return activityQuery;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)activityObject {
    if([[activityObject objectForKey:self.textKey] isEqualToString:kFSActivityTypeNewShippingRequest]){
        RequestFeedsCustomCell *requestCell = (RequestFeedsCustomCell *) [tableView dequeueReusableCellWithIdentifier:[RequestFeedsCustomCell reuseIdentifierFeed]];
        
        if(requestCell==nil){
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RequestFeedsCustomCell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    requestCell = (RequestFeedsCustomCell *)currentObject;
                    requestCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    requestCell.repostViewHolder.hidden=YES;
                    
                    requestCell.tableImageHolder.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
                    [requestCell.tableImageHolder setFrame:CGRectMake(4, 32, requestCell.contentView.frame.size.width-8, 135)];
                    
                    PFImageView *productImg=[[PFImageView alloc] initWithFrame:CGRectMake(13, 10, 45, 45)];
                    productImg.tag=3;
                    productImg.image=[UIImage imageNamed:@"placeholder.png"];
                    [requestCell.contentView addSubview:productImg];
                    [productImg release];
                    break;
                }
            }
        }
        
        
        PFObject *ShipReq=[activityObject objectForKey:kFSActivityRequestKey];
        [ShipReq fetchIfNeededInBackgroundWithBlock:^(PFObject *shippingReq,NSError *error){
            TTTTimeIntervalFormatter *timeIntervalFormatter=[[TTTTimeIntervalFormatter alloc] init];
            NSTimeInterval timeInterval = [[shippingReq createdAt] timeIntervalSinceNow];
            requestCell.lblTimeDisplay.text = [timeIntervalFormatter stringForTimeInterval:timeInterval];
            [timeIntervalFormatter release];
            
            NSArray *productsArray=[shippingReq objectForKey:@"items"];
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
            requestCell.imageUrls=imageUrls;
            [imageUrls release];
            [requestCell reloadTableData];
            
            //user image..
            PFUser *user=[activityObject objectForKey:kFSActivityFromUserKey];
            [user fetchIfNeededInBackgroundWithBlock:^(PFObject *joinedUser,NSError *error){
                requestCell.lblCurrentUser.text=[joinedUser objectForKey:kFSUserDisplayNameKey];
                ((PFImageView*)[requestCell.contentView viewWithTag:3]).file = [joinedUser objectForKey:kFSUserProfilePicSmallKey];
                [((PFImageView*)[requestCell.contentView viewWithTag:3]) loadInBackground];
            }];
            
            
            requestCell.lblKarmaPoints.text=[NSString stringWithFormat:@"%d points",[[shippingReq objectForKey:kFSRequestKarmaKey] intValue]];
            requestCell.lblShippingLocation.text=[NSString stringWithFormat:@"%@ -> %@",[shippingReq objectForKey:kFSRequestFromStreetKey],[shippingReq objectForKey:kFSRequestToStreetKey]];
            requestCell.lblProductShippingName.text=[NSString stringWithFormat:@"Would like to ship %@",[[productsArray objectAtIndex:0] objectForKey:@"name"]];
            
        }];
        
        return requestCell;
    }
    else if ([[activityObject objectForKey:self.textKey] isEqualToString:kFSActivityNewTravelRoute]){
        TravelRouteCell *routeCell = (TravelRouteCell *) [tableView dequeueReusableCellWithIdentifier:[TravelRouteCell reuseIdentifier]];
        if(routeCell==nil){
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TravelRouteCell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    routeCell = (TravelRouteCell *)currentObject;
                    routeCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    PFImageView *productImg=[[PFImageView alloc] initWithFrame:CGRectMake(13, 10, 45, 45)];
                    productImg.tag=3;
                    productImg.image=[UIImage imageNamed:@"placeholder.png"];
                    [routeCell.contentView addSubview:productImg];
                    [productImg release];
                    break;
                }
            }
        }
        
        //user image..
        PFUser *user=[activityObject objectForKey:kFSActivityFromUserKey];
        [user fetchIfNeededInBackgroundWithBlock:^(PFObject *joinedUser,NSError *error){
            routeCell.lblUserName.text=[joinedUser objectForKey:kFSUserDisplayNameKey];
            ((PFImageView*)[routeCell.contentView viewWithTag:3]).file = [joinedUser objectForKey:kFSUserProfilePicSmallKey];
            [((PFImageView*)[routeCell.contentView viewWithTag:3]) loadInBackground];
        }];
        
        //Populate Travel Request details...
        PFObject *travelReq=[activityObject objectForKey:kFSActivityRouteKey];
        [travelReq fetchIfNeededInBackgroundWithBlock:^(PFObject *routeReq,NSError *error){
            routeCell.lblTravelLocations.text=[NSString stringWithFormat:@"%@ -> %@",[routeReq objectForKey:kFSRouteFromStreetKey],[routeReq objectForKey:kFSRouteToStreetKey]];
            
            NSDictionary *fromLocDict=[routeReq objectForKey:kFSRouteFromCoordinateKey];
            NSDictionary *toLocDict=[routeReq objectForKey:kFSRouteToCoordinateKey];
            NSString *fromLocFormatted=[NSString stringWithFormat:@"%@,%@",[fromLocDict objectForKey:@"latt"],[fromLocDict objectForKey:@"long"]];
            NSString *toLocFormatted=[NSString stringWithFormat:@"%@,%@",[toLocDict objectForKey:@"latt"],[toLocDict objectForKey:@"long"]];
            
            //static map image from google..
            NSString *mapUrlString =[[NSString alloc] initWithFormat:@"%@?key=%@&size=320x140&scale=2&maptype=roadmap&sensor=true&markers=color:0x7FC94E|label:D|%@&markers=color:0xF84750|label:A|%@&path=color:orange|weight:2|%@|%@",Google_StaticMapsAPI_url,Google_API_Key,fromLocFormatted,toLocFormatted,fromLocFormatted,toLocFormatted];
            NSString *encodedMapUrlString=[mapUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [mapUrlString release];
            [routeCell.mapImageView setImageWithURL:[NSURL URLWithString:encodedMapUrlString] placeholderImage:[UIImage imageNamed:@"NoProduct.png"]];
            
            TTTTimeIntervalFormatter *timeIntervalFormatter=[[TTTTimeIntervalFormatter alloc] init];
            NSTimeInterval timeInterval = [[routeReq createdAt] timeIntervalSinceNow];
            routeCell.lblTravelPostTime.text = [timeIntervalFormatter stringForTimeInterval:timeInterval];
            [timeIntervalFormatter release];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMMM dd,yyyy"];
            NSString *selectedDate=[dateFormatter stringFromDate:[routeReq objectForKey:kFSRouteDepartureDateKey]];
            [dateFormatter release];
            routeCell.lblTravelDate.text=[NSString stringWithFormat:@"%@",selectedDate];
            
        }];
        
        return routeCell;
    }
    else if ([[activityObject objectForKey:self.textKey] isEqualToString:kFSActivityUSerJoined]){
        UserJoinedCell *userJoinedCell = (UserJoinedCell *) [tableView dequeueReusableCellWithIdentifier:[UserJoinedCell reuseIdentifier]];
        
        if(userJoinedCell==nil){
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UserJoinedCell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    userJoinedCell = (UserJoinedCell *)currentObject;
                    userJoinedCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    PFImageView *userImg=[[PFImageView alloc] initWithFrame:CGRectMake(13, 10, 45, 45)];
                    userImg.tag=4;
                    userImg.image=[UIImage imageNamed:@"placeholder.png"];
                    [userJoinedCell.contentView addSubview:userImg];
                    [userImg release];
                    break;
                }
            }
        }

        
        PFUser *user=[activityObject objectForKey:kFSActivityFromUserKey];
        [user fetchIfNeededInBackgroundWithBlock:^(PFObject *joinedUser,NSError *error){
            //user name
            userJoinedCell.lblUserName.text = [joinedUser objectForKey:kFSUserDisplayNameKey];
            
            //time display..
            TTTTimeIntervalFormatter *timeIntervalFormatter=[[TTTTimeIntervalFormatter alloc] init];
            NSTimeInterval timeInterval = [[joinedUser createdAt] timeIntervalSinceNow];
            userJoinedCell.lblTimeDisplay.text = [timeIntervalFormatter stringForTimeInterval:timeInterval];
            [timeIntervalFormatter release];
            
            //user image..
            ((PFImageView*)[userJoinedCell.contentView viewWithTag:4]).file = [joinedUser objectForKey:kFSUserProfilePicSmallKey];
            [((PFImageView*)[userJoinedCell.contentView viewWithTag:4]) loadInBackground];
        }];
        
        return userJoinedCell;
    }
    else{
        static NSString *otherCellIdentifier = @"otherCellIdentifier";
        
        PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:otherCellIdentifier];
        if (cell == nil) {
            cell = [[[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherCellIdentifier] autorelease];
        }
        
        // Configure the cell
        cell.textLabel.text = [activityObject objectForKey:self.textKey];
        return cell;
    } 
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


// Override if you need to change the ordering of objects in the table.
/*- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"(PFObject *)objectAtIndex");
    return [self.objects objectAtIndex:indexPath.row];
}*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (indexPath.row != self.objects.count){
    PFObject *activityObject=[self.objects objectAtIndex:indexPath.row];
    if([[activityObject objectForKey:self.textKey] isEqualToString:kFSActivityTypeNewShippingRequest]){
        PFObject *ShipReq=[activityObject objectForKey:kFSActivityRequestKey];
        [ShipReq fetchIfNeededInBackgroundWithBlock:^(PFObject *shippingReq,NSError *error){
            RequestDetailViewController *reqDetail=[[RequestDetailViewController alloc] initWithNibName:@"RequestDetailViewController" bundle:nil];
            reqDetail.shippingReqObj=shippingReq;
            PFUser *user=[activityObject objectForKey:kFSActivityFromUserKey];
            [user fetchIfNeededInBackgroundWithBlock:^(PFObject *joinedUser,NSError *error){
                reqDetail.userObj=(PFUser*)joinedUser;
            }];
            [self.navigationController pushViewController:reqDetail animated:YES];
            [reqDetail release];
        }];
    }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.objects.count)
    {
        cell.backgroundColor=[UIColor colorWithRed:0.94509 green:0.956862 blue:0.984313 alpha:1];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.objects.count)
    {
        return 44;
    }
    else{
        PFObject *activityObject=[self.objects objectAtIndex:indexPath.row];
        if([[activityObject objectForKey:self.textKey] isEqualToString:kFSActivityTypeNewShippingRequest]){
         return 270;
        }
        else if ([[activityObject objectForKey:self.textKey] isEqualToString:kFSActivityUSerJoined]){
            return 73;
        }
        else if ([[activityObject objectForKey:self.textKey] isEqualToString:kFSActivityNewTravelRoute]){
            return 270;
        }
        else{
            return 70;
        }
        
       /* PFObject *shippingReqObj=[self.objects objectAtIndex:indexPath.row];
        if ([self shippingRequestIsExpired:[shippingReqObj objectForKey:@"delivery"] createdDate:[shippingReqObj createdAt]]) {
            return 308;
        }
        else{
            return 270;
        }*/
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

@end
