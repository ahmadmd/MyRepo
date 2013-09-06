//
//  NotificationSettingViewController.m
//  FriendShippr
//
//  Created by Zoondia on 29/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "NotificationSettingViewController.h"

#define kNotificationSettingsCount 5;

@implementation NotificationSettingViewController
@synthesize notifSettMenuArray,tableNotifSetting,sectionHeaderView,headerSwitch,isHeaderSwitchOn;

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
    
    notifSettMenuArray=[[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Announcements",@"name",@"notification_icon.png",@"imageName", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Permissions",@"name",@"notification_icon.png",@"imageName", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Comments",@"name",@"notification_icon.png",@"imageName", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Feed",@"name",@"notification_icon.png",@"imageName", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"New Product",@"name",@"notification_icon.png",@"imageName", nil], nil];
    
    self.navigationItem.title=@"Notification Settings";
    
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
    
    self.isHeaderSwitchOn=YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingSwitchChangedNotifRecieved:) name:FSNotifSettingSwitchValueChangedNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FSNotifSettingSwitchValueChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [tableNotifSetting release];
    [notifSettMenuArray release];
    [sectionHeaderView release];
    [headerSwitch release];
    [super dealloc];
}

#pragma mark NSNotifications

- (void) settingSwitchChangedNotifRecieved:(NSNotification*) notification {
    NotificationSettCustomCell *cell=(NotificationSettCustomCell*)notification.object;
    NSIndexPath *indexPath=[self.tableNotifSetting indexPathForCell:cell];
    if(indexPath.row==AnnouncementsSettingIndex){
        NSLog(@"AnnouncementsSettingIndex");
    }
    else if (indexPath.row==PermissionsSettingIndex){
        NSLog(@"PermissionsSettingIndex");
    }
    else if(indexPath.row==CommentsSettingIndex){
        NSLog(@"CommentsSettingIndex");
    }
    else if(indexPath.row==FeedsSettingIndex){
        NSLog(@"FeedsSettingIndex");
    }
    else if(indexPath.row==NewProductSettingIndex){
        NSLog(@"NewProductSettingIndex");
    }
}


#pragma mark IBActions

-(void)bttnActionGoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)headerSwitchValueChanged:(id)sender {
    UISwitch *headrSwitch=(UISwitch*)sender;
    if(headrSwitch.on){
        self.isHeaderSwitchOn=YES;
    }
    else{
        self.isHeaderSwitchOn=NO;
    }
    [self.tableNotifSetting reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark UITableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isHeaderSwitchOn){
        return kNotificationSettingsCount;
    }
    else{
        return 0;
    }
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationSettCustomCell *cell = nil;
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NotificationSettCustomCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (NotificationSettCustomCell *)currentObject;
                cell.selectionStyle=UITableViewCellSelectionStyleGray;
                break;
            }
        }
    }
    
    cell.lblNotifSettName.text=[[self.notifSettMenuArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.notifSettIcon.image=[UIImage imageNamed:[[self.notifSettMenuArray objectAtIndex:indexPath.row] objectForKey:@"imageName"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row%2==0){
        cell.backgroundColor=[UIColor whiteColor];
    }
    else{
        cell.backgroundColor=[UIColor colorWithRed:0.9450 green:0.9568 blue:0.984313 alpha:1];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 75.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}


@end
