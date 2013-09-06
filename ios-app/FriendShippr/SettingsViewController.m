//
//  SettingsViewController.m
//  FriendShippr
//
//  Created by Zoondia on 29/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "SettingsViewController.h"

#define kSettingsCount 4;

@implementation SettingsViewController
@synthesize tableSettings,settingsMenuArray;

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
    
    settingsMenuArray=[[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Notifications",@"name",@"notification_icon.png",@"imageName", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Feedback",@"name",@"notification_icon.png",@"imageName", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Terms & Conditions",@"name",@"notification_icon.png",@"imageName", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Logout",@"name",@"notification_icon.png",@"imageName", nil], nil];
    
    self.navigationItem.title=@"Account Settings";
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [tableSettings release];
    [settingsMenuArray release];
    [super dealloc];
}

#pragma mark IBActions

-(void)bttnActionGoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return kSettingsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsCustomCell *cell = nil;
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SettingsCustomCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (SettingsCustomCell *)currentObject;
                cell.selectionStyle=UITableViewCellSelectionStyleGray;
                break;
            }
        }
    }
    
    cell.lblSettingsName.text=[[self.settingsMenuArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.settingsIcon.image=[UIImage imageNamed:[[self.settingsMenuArray objectAtIndex:indexPath.row] objectForKey:@"imageName"]];
    if(indexPath.row==[self.settingsMenuArray count]-1){
        cell.accessoryImage.hidden=YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row%2==0){
        cell.backgroundColor=[UIColor colorWithRed:0.9450 green:0.9568 blue:0.984313 alpha:1];
    }
    else{
        cell.backgroundColor=[UIColor whiteColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==NotificationSettingsIndex){
        NotificationSettingViewController *notifSettView=[[NotificationSettingViewController alloc] initWithNibName:@"NotificationSettingViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:notifSettView animated:YES];
        [notifSettView release];
    }
    else if (indexPath.row==FeedbackSettingsIndex){
        NSLog(@"FeedbackSettingsIndex");
    }
    else if(indexPath.row==TermsSettingsIndex){
        NSLog(@"TermsSettingsIndex");
    }
    else if(indexPath.row==LogoutIndex){
        NSLog(@"LogoutIndex");
    }
}


@end
