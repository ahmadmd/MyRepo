//
//  MapViewAnnotation.m
//  TileMap
//
//  Created by Zoondia on 06/12/12.
//
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title, coordinate,subtitle;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d subtitle:(NSString *)subttl{
	if (self = [super init]) {
        self.title = ttl;
        self.coordinate = c2d;
        self.subtitle=subttl;
    }
	return self;
}

- (void)dealloc {
	[title release];
    [subtitle release];
	[super dealloc];
}

@end
