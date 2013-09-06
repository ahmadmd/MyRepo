//
//  ForwardFriendSelectViewController.m
//  FriendShippr
//
//  Created by Zoondia on 28/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "ForwardFriendSelectViewController.h"

@interface ForwardFriendSelectViewController ()

@end

@implementation ForwardFriendSelectViewController
@synthesize tableFriendSelect,friendsArray,invitedFriends,shippingReqObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark UIViewController Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    invitedFriends=[[NSMutableArray alloc] init];
    
    self.navigationItem.title=@"Forward Request";
    
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
    
    
    progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    progressHud.delegate = self;
    progressHud.labelText=@"Loading...";
    [self.view addSubview:progressHud];
    [progressHud show:YES];
    PFRole *role=[[PFUser currentUser] objectForKey:kFSUserRoleKey];
    PFRelation *friendsRelation=role.users;
    PFQuery *query = [friendsRelation query];
    //to get the parse friends from Role..
    [query findObjectsInBackgroundWithBlock:^(NSArray *friends,NSError *error){
        [progressHud hide:YES];
        if(!error){
            if([friends count]<=0){
                self.tableFriendSelect.hidden=YES;
                self.lblErrMsg.hidden=NO;
            }
            else{
                self.friendsArray=friends;
                self.tableFriendSelect.hidden=NO;
                self.lblErrMsg.hidden=YES;
                [self.tableFriendSelect reloadData];
            }
        }
        else{
            [Common showAlertwithTitle:@"Error" alertString:error.localizedDescription cancelbuttonName:@"OK"];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [tableFriendSelect release];
    [friendsArray release];
    [_lblErrMsg release];
    [invitedFriends release];
    [shippingReqObj release];
    [super dealloc];
}

#pragma mark TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyFriendsCell *cell = (MyFriendsCell *) [tableView dequeueReusableCellWithIdentifier:[MyFriendsCell reuseIdentifier]];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyFriendsCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (MyFriendsCell *)currentObject;
                cell.friendAccesoryImage.hidden=YES;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                UIButton *bttnSelectFriend=[[UIButton alloc] init];
                bttnSelectFriend.frame=CGRectMake(265, 17, 44, 44);
                bttnSelectFriend.autoresizingMask=UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
                bttnSelectFriend.tag=5;
                [bttnSelectFriend addTarget:self action:@selector(bttnActionSelectFriend:) forControlEvents:UIControlEventTouchUpInside];
                [bttnSelectFriend setTitle:@"" forState:UIControlStateNormal];
                [bttnSelectFriend setBackgroundImage:[UIImage imageNamed:@"non_transfered@2x.png"] forState:UIControlStateNormal];
                [bttnSelectFriend setBackgroundImage:[UIImage imageNamed:@"transfered@2x.png"] forState:UIControlStateSelected];
                [cell.contentView addSubview:bttnSelectFriend];
                [bttnSelectFriend release];
                
                break;
            }
        }
    }
    
    if([self.invitedFriends containsObject:[self.friendsArray objectAtIndex:indexPath.row]]){
        [((UIButton*)[cell.contentView viewWithTag:5]) setSelected:TRUE];
    }
    else{
        [((UIButton*)[cell.contentView viewWithTag:5]) setSelected:FALSE];
    }
    
    PFUser *friend=[self.friendsArray objectAtIndex:indexPath.row];
    cell.friendName.text=[friend objectForKey:kFSUserDisplayNameKey];
    cell.friendProfileImage.image=[UIImage imageNamed:@"placeholder.png"];
    /*[[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:FB_profilepic_url,[friend objectForKey:kFSUserFacebookIDKey]]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image,NSData *data, NSError *error,BOOL finished){
     if (image)
     {
     cell.friendProfileImage.image=[image thumbnailImage:90 transparentBorder:0 cornerRadius:45 interpolationQuality:kCGInterpolationLow];
     }
     }];*/
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:[NSString stringWithFormat:FB_profilepic_url,[friend objectForKey:kFSUserFacebookIDKey]]] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error,SDImageCacheType cacheType, BOOL finished){
        if (image)
        {
            cell.friendProfileImage.image=[image thumbnailImage:90 transparentBorder:0 cornerRadius:45 interpolationQuality:kCGInterpolationLow];
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row%2==0){
        cell.backgroundColor=[UIColor colorWithRed:0.9529 green:0.9647 blue:0.984313 alpha:1];
    }
    else{
        cell.backgroundColor=[UIColor whiteColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark IBActions

//select the friends to sent request to..
-(IBAction)bttnActionSelectFriend:(id)sender{
    UIButton *bttn=(UIButton*)sender;
    if([bttn.superview.superview isKindOfClass:[MyFriendsCell class]]){
        MyFriendsCell *cell = (MyFriendsCell *)bttn.superview.superview;
        NSIndexPath *indexPath = [self.tableFriendSelect indexPathForCell:cell];
        if(bttn.selected){
            [bttn setSelected:false];
            [self.invitedFriends removeObject:[self.friendsArray objectAtIndex:indexPath.row]];
        }
        else{
            [bttn setSelected:true];
            [self.invitedFriends addObject:[self.friendsArray objectAtIndex:indexPath.row]];
        }
    }
}

//to forward request, cloud code is called..
- (IBAction)bttnActionForwardShippingRequest:(id)sender {
    if([self.invitedFriends count]>0){
        [PFCloud callFunctionInBackground:@"forwardRequest"
                           withParameters:@{@"requestId":[self.shippingReqObj objectId],@"userId":((PFObject*)[self.invitedFriends objectAtIndex:0]).objectId}
                                    block:^(NSString *result, NSError *error) {
                                        if (!error) {
                                            NSLog(@"result=%@",result);
                                        }
                                    }];
    }
    else{
        [Common showAlertwithTitle:nil alertString:@"Select friends to forward request" cancelbuttonName:@"OK"];
    }
    
}

-(void)bttnActionGoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark MBProgressHUD Delegates

// Remove HUD from screen when the HUD was hidded
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[progressHud removeFromSuperview];
	[progressHud release];
	progressHud = nil;
}


@end
