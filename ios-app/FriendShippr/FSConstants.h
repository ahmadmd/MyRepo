//
//  FSConstants.h
//  FriendShippr
//
//  Created by Pravin on 8/27/13.
//

//Side Menu selection index..
typedef enum {
	FSFeedsViewControllerIndex = 0,
	FSHubViewControllerIndex = 1,
	FSShipmentsViewControllerIndex = 2,
    FSRoutesViewControllerIndex = 3,
    FSStoreViewControllerIndex = 4,
    FSProfileViewControllerIndex = 99
} FSSideMenuViewControllerIndex;


#pragma mark - NSUserDefaults
extern NSString *const kFSNoProductImageUrlKey;


#pragma mark - NSNotification
extern NSString *const FSFriendsUpdatedNotification;
extern NSString *const FSShippingRequestRepostCellNotification;
extern NSString *const FSShippingRquestClickedNotification;
extern NSString *const FSTravelRouteClickedNotification;
extern NSString *const FSNotifSettingSwitchValueChangedNotification;
extern NSString *const FSProductScrollCellContentChangedNotification;

#pragma mark - PFObject Activity Class
// Class key
extern NSString *const kFSActivityClassKey;

// Field keys
extern NSString *const kFSActivityTypeKey;
extern NSString *const kFSActivityFromUserKey;
extern NSString *const kFSActivityRequestKey;
extern NSString *const kFSActivityRouteKey;

// Type values
extern NSString *const kFSActivityTypeNewShippingRequest;
extern NSString *const kFSActivityNewTravelRoute;
extern NSString *const kFSActivityUSerJoined;


#pragma mark - PFObject User Class
// Field keys
extern NSString *const kFSUserUserNameKey;
extern NSString *const kFSUserFacebookIDKey;
extern NSString *const kFSUserEmailKey;
extern NSString *const kFSUserDisplayNameKey;
extern NSString *const kFSUserProfilePicMediumKey;
extern NSString *const kFSUserProfilePicSmallKey;
extern NSString *const kFSUserRoleKey;

#pragma mark - PFObject Request Class

// Class key
extern NSString *const kFSRequestClassKey;

// Field keys
extern NSString *const kFSRequestDeliveryTypeKey;
extern NSString *const kFSRequestDeliveryDateKey;
extern NSString *const kFSRequestFromCoordinateKey;
extern NSString *const kFSRequestFromStreetKey;
extern NSString *const kFSRequestToCoordinateKey;
extern NSString *const kFSRequestToStreetKey;
extern NSString *const kFSRequestItemsKey;
extern NSString *const kFSRequestKarmaKey;
extern NSString *const kFSRequestFromUserKey;
extern NSString *const kFSRequestOffersCountKey;

#pragma mark - PFObject Route Class

// Class key
extern NSString *const kFSRouteClassKey;

// Field keys
extern NSString *const kFSRouteDepartureDateKey;
extern NSString *const kFSRouteFromCoordinateKey;
extern NSString *const kFSRouteFromStreetKey;
extern NSString *const kFSRouteToCoordinateKey;
extern NSString *const kFSRouteToStreetKey;
extern NSString *const kFSRouteFromUserKey;

#pragma mark - PFObject Offer Class

// Class key
extern NSString *const kFSOfferClassKey;

// Field keys
extern NSString *const kFSOfferRequestKey;
extern NSString *const kFSOfferFromUserKey;







