//
//  DateEntryViewController.m
//  FriendShippr
//
//  Created by Zoondia on 06/08/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "DateEntryViewController.h"

@interface DateEntryViewController ()

@end

@implementation DateEntryViewController
@synthesize calendar,headingHolder,minimumDate;

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

-(void)goToRouteConfirmController:(NSDate*)date{
    RouteConfirmViewController *routeView=[[RouteConfirmViewController alloc] initWithNibName:@"RouteConfirmViewController" bundle:[NSBundle mainBundle]];
    [ShippingRequestObject sharedInstance].travelDate=date;
    self.calendar.userInteractionEnabled=YES;
    self.navigationItem.rightBarButtonItem.enabled=YES;
    self.navigationItem.leftBarButtonItem.enabled=YES;
    [self.navigationController pushViewController:routeView animated:YES];
    [routeView release];
}

#pragma mark UIViewController Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"Travel Route";
    
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
    
    calendar = [[CKCalendarView alloc] init];
    [self.calendar setCalendarStartDay:startMonday];
    self.calendar.delegate = self;
    self.calendar.onlyShowCurrentMonth = NO;
    self.calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    self.calendar.dateFont=[UIFont systemFontOfSize:13];
    self.calendar.backgroundColor=[UIColor clearColor];
    self.calendar.titleColor=[UIColor colorWithRed:0.313725 green:0.313725 blue:0.313725 alpha:1];
    self.calendar.dayOfWeekTextColor=[UIColor whiteColor];
    if([UIScreen mainScreen].bounds.size.height==480){
        self.calendar.frame = CGRectMake(25,self.headingHolder.frame.origin.y+ self.headingHolder.frame.size.height, 270, 303);
    }
    else{
        self.calendar.frame = CGRectMake(15,self.headingHolder.frame.origin.y+ self.headingHolder.frame.size.height, 290, 335);
    }
    [self.view addSubview:calendar];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [minimumDate release];
    [headingHolder release];
    [calendar release];
    [super dealloc];
}

#pragma mark CKCalendar Delegates

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    NSDate *now = [NSDate date];
    NSDate *oneDaysAgo = [now dateByAddingTimeInterval:-1*24*60*60];
    if ([date compare:oneDaysAgo]==NSOrderedAscending) {
        //dateItem.backgroundColor = [UIColor colorWithRed:0.9803 green:0.9803 blue:0.9803 alpha:1];
        dateItem.textColor = [UIColor lightGrayColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    NSDate *now = [NSDate date];
    NSDate *oneDaysAgo = [now dateByAddingTimeInterval:-1*24*60*60];
    
    return ([date compare:oneDaysAgo]==NSOrderedDescending);
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    NSDate *now = [NSDate date];
    NSDate *thirtyDaysAgo = [now dateByAddingTimeInterval:-30*24*60*60];
    if ([date compare:thirtyDaysAgo]==NSOrderedDescending) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    self.calendar.userInteractionEnabled=NO;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    self.navigationItem.leftBarButtonItem.enabled=NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(goToRouteConfirmController:) object:date];
	[self performSelector:@selector(goToRouteConfirmController:) withObject:date afterDelay:0.5];
}

@end
