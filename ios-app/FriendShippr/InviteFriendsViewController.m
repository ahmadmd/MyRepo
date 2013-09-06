//
//  InviteFriendsViewController.m
//  FriendShippr
//
//  Created by Zoondia on 13/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface InviteFriendsViewController ()

@end

@implementation InviteFriendsViewController
@synthesize tblInviteFriends,facebookFriends,invitedFriends,friendshipprFriends,lblErrorMsg,loadingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)bttnActionGoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bttnActionSearchFriend:(id)sender {
    
}


//post invite to FB as requests..
- (IBAction)bttnActionPostInvite:(id)sender {
    if([self.invitedFriends count]>0){
        NSMutableArray *fbInviteIds=[[NSMutableArray alloc] init];
        for(int i=0;i<[self.invitedFriends count];i++){
            NSDictionary *dict=[self.invitedFriends objectAtIndex:i];
            [fbInviteIds addObject:[dict objectForKey:@"id"]];
        }
        [self postToWallOfFacebookId:fbInviteIds];
        [fbInviteIds release];
    }
    else{
        [Common showAlertwithTitle:nil alertString:@"Select friends to post invite" cancelbuttonName:@"OK"];
    }
}

-(void)postToWallOfFacebookId:(NSArray*)facebookId{
    if (FBSession.activeSession.isOpen){
        [self publishFeeds:facebookId];
    }
    else{
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             if (FBSession.activeSession.isOpen && !error) {
                                                 NSLog(@"entered publish feeds");
                                                 // Publish the story if permission was granted
                                                 [self publishFeeds:facebookId];
                                             }
                                             else{
                                                 NSLog(@"entered publish feeds error=%@",error.localizedDescription);
                                                 [Common showAlertwithTitle:@"Error" alertString:@"Unknown Error Occurred" cancelbuttonName:@"OK"];
                                             }
                                         }];
    }
}

-(void)publishFeeds:(NSArray*)facebookIds{
    //send invites as app requests...
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"https://itunes.apple.com/in/app/id529479190", @"link",
                                   [facebookIds componentsJoinedByString:@","],@"to",
                                   nil];
    
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:FBSession.activeSession
                                                  message:@"Hey there!! I'm using friendshippr. Checkout this cool app!"
                                                    title:@"FriendShippr"
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Error launching the dialog or sending the request.
                                                          NSLog(@"Error sending request.");
                                                          [Common showAlertwithTitle:@"Error" alertString:error.localizedDescription cancelbuttonName:@"OK"];
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User clicked the "x" icon
                                                              NSLog(@"User canceled request.");
                                                          } else {
                                                              // Handle the send request callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              if (![urlParams valueForKey:@"request"]) {
                                                                  // User clicked the Cancel button
                                                                  NSLog(@"User canceled request.");
                                                              } else {
                                                                  // User clicked the Send button
                                                                  NSString *requestID = [urlParams valueForKey:@"request"];
                                                                  NSLog(@"Request ID: %@", requestID);
                                                                  //[Common showAlertwithTitle:@"Success" alertString:@"Invite posted" cancelbuttonName:@"OK"];
                                                                  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Invite Posted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                  alert.tag=1;
                                                                  [alert show];
                                                                  [alert release];
                                                              }
                                                          }
                                                      }
                                                  }];
    
    
    /* NSMutableDictionary *params =
     [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"FriendShippr", @"name",
     //@" ", @"caption",
     @"Hey there!! I'm using friendshippr. Checkout this cool app!", @"description",
     @"https://itunes.apple.com/in/app/id529479190", @"link",
     [facebookIds objectAtIndex:0],@"to",
     //@"", @"picture",
     nil];
     
     //to post to feeds..(not able to send to multiple users!!)
     [FBWebDialogs presentFeedDialogModallyWithSession:nil
     parameters:params
     handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
     if (error) {
     // Error launching the dialog or publishing a story.
     NSLog(@"Error publishing story.");
     [Common showAlertwithTitle:@"Error" alertString:error.localizedDescription cancelbuttonName:@"OK"];
     } else {
     if (result == FBWebDialogResultDialogNotCompleted) {
     // User clicked the "x" icon
     NSLog(@"User canceled story publishing.");
     } else {
     // Handle the publish feed callback
     NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
     if (![urlParams valueForKey:@"post_id"]) {
     // User clicked the Cancel button
     NSLog(@"User canceled story publishing.");
     } else {
     // User clicked the Share button
     NSString *msg = [NSString stringWithFormat:
     @"Posted story, id: %@",
     [urlParams valueForKey:@"post_id"]];
     NSLog(@"%@", msg);
     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Invite Posted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     alert.tag=1;
     [alert show];
     [alert release];
     }
     }
     }
     }];*/
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

//select the friends to sent request to..
-(IBAction)bttnActionSelectFriend:(id)sender{
    UIButton *bttn=(UIButton*)sender;
    if([bttn.superview.superview isKindOfClass:[MyFriendsCell class]]){
        MyFriendsCell *cell = (MyFriendsCell *)bttn.superview.superview;
        NSIndexPath *indexPath = [self.tblInviteFriends indexPathForCell:cell];
        if(bttn.selected){
            [bttn setSelected:false];
            [self.invitedFriends removeObject:[self.facebookFriends objectAtIndex:indexPath.row]];
        }
        else{
            [bttn setSelected:true];
            [self.invitedFriends addObject:[self.facebookFriends objectAtIndex:indexPath.row]];
        }
    }
}

#pragma mark UIViewController Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    invitedFriends=[[NSMutableArray alloc] init];
    
    self.navigationItem.title=@"Invite Friends";
    
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
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    [self.loadingView startAnimating];
    FBRequest *request = [FBRequest requestForMyFriends];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [[NSMutableArray alloc] initWithCapacity:friendObjects.count];
            
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[NSDictionary dictionaryWithObjectsAndKeys:[friendObject objectForKey:@"id"],@"id",[friendObject objectForKey:@"name"],@"name", nil]];
            }
            for (int i=0; i<[Common sharedInstance].parseFriends.count; i++) {
                NSDictionary *parseFriend=[[Common sharedInstance].parseFriends objectAtIndex:i];
                if([friendIds containsObject:parseFriend]){
                    [friendIds removeObject:parseFriend];
                }
            }
            self.facebookFriends=friendIds;
            [friendIds release];
            if(self.facebookFriends.count>0){
                self.lblErrorMsg.hidden=YES;
                self.tblInviteFriends.hidden=NO;
            }
            else{
                self.lblErrorMsg.hidden=NO;
                self.tblInviteFriends.hidden=YES;
            }
            [self.tblInviteFriends reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [self.loadingView stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [tblInviteFriends release];
    [facebookFriends release];
    [invitedFriends release];
    [friendshipprFriends release];
    [lblErrorMsg release];
    [loadingView release];
    [super dealloc];
}

#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1){
        if(buttonIndex==0){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark Tableview Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.facebookFriends count];
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
    if([self.invitedFriends containsObject:[self.facebookFriends objectAtIndex:indexPath.row]]){
        [((UIButton*)[cell.contentView viewWithTag:5]) setSelected:TRUE];
    }
    else{
         [((UIButton*)[cell.contentView viewWithTag:5]) setSelected:FALSE];
    }
    
    NSDictionary *dict=[self.facebookFriends objectAtIndex:indexPath.row];
    cell.friendName.text=[dict objectForKey:@"name"];
    cell.friendProfileImage.image=[UIImage imageNamed:@"placeholder.png"];
    /*[[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:FB_profilepic_url,[dict objectForKey:@"id"]]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image,NSData *data, NSError *error,BOOL finished){
        if (image)
        {
            cell.friendProfileImage.image=[image thumbnailImage:90 transparentBorder:0 cornerRadius:45 interpolationQuality:kCGInterpolationLow];
        }
    }];*/
    
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:[NSString stringWithFormat:FB_profilepic_url,[dict objectForKey:@"id"]]] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error,SDImageCacheType cacheType, BOOL finished){
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

@end
