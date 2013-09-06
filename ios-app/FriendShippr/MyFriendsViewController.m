//
//  MyFriendsViewController.m
//  FriendShippr
//
//  Created by Zoondia on 13/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "MyFriendsViewController.h"

@interface MyFriendsViewController ()

@end

@implementation MyFriendsViewController
@synthesize lblFirstCount,lblSecondCount,lblTotalCount,tblFriendsList,headerView,friendsListArray,lblErrorMsg,isFromMyProfile;

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

//close modal..
-(void)bttnActionClose:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//navigate to invite friends page..
- (IBAction)bttnActionInviteFriends:(id)sender {
    InviteFriendsViewController *inviteFriends=[[InviteFriendsViewController alloc] initWithNibName:@"InviteFriendsViewController" bundle:[NSBundle mainBundle]];
    inviteFriends.friendshipprFriends=self.friendsListArray;
    [self.navigationController pushViewController:inviteFriends animated:YES];
    [inviteFriends release];
}

#pragma mark UIViewController Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"My Friends";
    
    if(isFromMyProfile){
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
    }
    else{
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
    
    self.tblFriendsList.tableHeaderView=self.headerView;
    self.friendsListArray=[Common sharedInstance].parseFriends;
    self.lblFirstCount.text=[NSString stringWithFormat:@"%d",[self.friendsListArray count]];
    self.lblSecondCount.text=@"0";
    self.lblTotalCount.text=[NSString stringWithFormat:@"%d",[self.friendsListArray count]];
    
    if([self.friendsListArray count]==0){
        self.lblErrorMsg.hidden=NO;
        self.tblFriendsList.hidden=YES;
        [self.tblFriendsList reloadData];
    }
    else{
        self.lblErrorMsg.hidden=YES;
        self.tblFriendsList.hidden=NO;
        [self.tblFriendsList reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendsUpdatedNotifRecieved:) name:FSFriendsUpdatedNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FSFriendsUpdatedNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [lblFirstCount release];
    [lblSecondCount release];
    [lblTotalCount release];
    [tblFriendsList release];
    [headerView release];
    [friendsListArray release];
    [lblErrorMsg release];
    [super dealloc];
}

#pragma mark NSNotification Functions

- (void) friendsUpdatedNotifRecieved:(NSNotification*) notification {
    self.friendsListArray=[Common sharedInstance].parseFriends;
    self.lblFirstCount.text=[NSString stringWithFormat:@"%d",[self.friendsListArray count]];
    self.lblSecondCount.text=@"0";
    self.lblTotalCount.text=[NSString stringWithFormat:@"%d",[self.friendsListArray count]];
    if([self.friendsListArray count]==0){
        self.lblErrorMsg.hidden=NO;
        self.tblFriendsList.hidden=YES;
        [self.tblFriendsList reloadData];
    }
    else{
        self.lblErrorMsg.hidden=YES;
        self.tblFriendsList.hidden=NO;
        [self.tblFriendsList reloadData];
    }
}



#pragma mark TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.friendsListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyFriendsCell *cell = (MyFriendsCell *) [tableView dequeueReusableCellWithIdentifier:[MyFriendsCell reuseIdentifier]];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyFriendsCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (MyFriendsCell *)currentObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                break;
            }
        }
    }
    NSDictionary *dict=[self.friendsListArray objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
