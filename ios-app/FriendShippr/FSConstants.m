//
//  FSConstants.m
//  FriendShippr
//
//  Created by Pravin on 8/27/13.
//

#import "FSConstants.h"

#pragma mark - NSUserDefaults
NSString *const kFSNoProductImageUrlKey         =@"noProductImageUrl";


#pragma mark - NSNotification

NSString *const FSFriendsUpdatedNotification            = @"friendsUpdatedNotification";
NSString *const FSShippingRequestRepostCellNotification = @"ShippingRequestRepostNotif";
NSString *const FSShippingRquestClickedNotification     = @"shippingRequestNotification";
NSString *const FSTravelRouteClickedNotification        = @"travelRouteNotification";
NSString *const FSNotifSettingSwitchValueChangedNotification =@"notifSettCustomCellSwitchValueChangedNotif";
NSString *const FSProductScrollCellContentChangedNotification=@"productScrollCellContentChangedNotification";


#pragma mark - Activity Class
// Class key
NSString *const kFSActivityClassKey = @"Activity";

// Field keys
NSString *const kFSActivityTypeKey        = @"type";
NSString *const kFSActivityFromUserKey    = @"userId";
NSString *const kFSActivityRequestKey     = @"requestId";
NSString *const kFSActivityRouteKey       = @"routeId";

// Type values
NSString *const kFSActivityTypeNewShippingRequest       = @"New Shipping Request";
NSString *const kFSActivityNewTravelRoute               = @"New Travel Route";
NSString *const kFSActivityUSerJoined                   = @"User Joined";

#pragma mark - User Class

// Field keys
NSString *const kFSUserUserNameKey          = @"username";
NSString *const kFSUserFacebookIDKey        = @"facebookId";
NSString *const kFSUserEmailKey             = @"fbEmail";
NSString *const kFSUserDisplayNameKey       = @"name";
NSString *const kFSUserProfilePicMediumKey  = @"profilePictureMedium";
NSString *const kFSUserProfilePicSmallKey   = @"profilePictureSmall";
NSString *const kFSUserRoleKey              = @"role";

#pragma mark - PFObject Request Class

// Class key
 NSString *const kFSRequestClassKey             = @"Request";

// Field keys
 NSString *const kFSRequestDeliveryTypeKey      = @"delivery";
 NSString *const kFSRequestDeliveryDateKey      = @"deliveryDate";
 NSString *const kFSRequestFromCoordinateKey    = @"fromCoord";
 NSString *const kFSRequestFromStreetKey        = @"fromStreet";
 NSString *const kFSRequestToCoordinateKey      = @"toCoord";
 NSString *const kFSRequestToStreetKey          = @"toStreet";
 NSString *const kFSRequestItemsKey             = @"items";
 NSString *const kFSRequestKarmaKey             = @"karma";
 NSString *const kFSRequestFromUserKey          = @"userId";
 NSString *const kFSRequestOffersCountKey       = @"offers";


#pragma mark - PFObject Route Class

// Class key
 NSString *const kFSRouteClassKey               = @"Route";

// Field keys
 NSString *const kFSRouteDepartureDateKey       = @"departDate";
 NSString *const kFSRouteFromCoordinateKey      = @"fromCoord";
 NSString *const kFSRouteFromStreetKey          = @"fromStreet";
 NSString *const kFSRouteToCoordinateKey        = @"toCoord";
 NSString *const kFSRouteToStreetKey            = @"toStreet";
 NSString *const kFSRouteFromUserKey            = @"userId";

#pragma mark - PFObject Offer Class

// Class key
 NSString *const kFSOfferClassKey               =@"Offer";

// Field keys
 NSString *const kFSOfferRequestKey             =@"requestId";
 NSString *const kFSOfferFromUserKey            =@"userId";







