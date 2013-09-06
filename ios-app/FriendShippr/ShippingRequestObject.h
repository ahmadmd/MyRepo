//
//  ShippingRequestObject.h
//  FriendShippr
//
//  Created by Zoondia on 24/07/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShippingRequestObject : NSObject

+ (ShippingRequestObject*)sharedInstance;

@property(nonatomic,retain)NSMutableArray *productsArray;//array->dictionary(name,quantity,imageUrl)
@property(nonatomic,retain)NSDictionary *pickUpPlace;//dictionary(address,lat,lng)
@property(nonatomic,retain)NSDictionary *dropOffPlace;//dictionary(address,lat,lng)
@property(nonatomic,retain)NSString *deliveryDate;//either rush,week or anytime
@property(nonatomic,retain)NSString *paymentTerms;//either skrill,noPay or cod
@property(nonatomic,retain)NSString *karmaPoints;

@property(nonatomic,retain) NSDate *travelDate;

@end
