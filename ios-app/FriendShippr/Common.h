//
//  Common.h
//  FriendShippr
//
//  Created by Zoondia on 17/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "UIImage+ResizeAdditions.h"

@interface Common : NSObject

+ (Common*)sharedInstance;
+(void)showAlertwithTitle:(NSString *)title alertString:(NSString*)alertStr cancelbuttonName:(NSString*)cancel; //show alerts..
+ (BOOL)userHasValidFacebookData:(PFUser *)user;
+(NSString*)getDateAfterDays:(int)days;
-(void)loadDB;  //To load the DB into documents folder.
+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData;
+ (BOOL)userHasProfilePictures:(PFUser *)user;
+ (NSDate *)addDays:(NSInteger)days toDate:(NSDate *)originalDate;

@property(nonatomic,assign)FSSideMenuViewControllerIndex slideMenuSelected;
@property(nonatomic,retain)NSMutableArray *parseFriends;
@property(nonatomic,retain)NSString *dbPath;    //Holds the path of database.

@end
