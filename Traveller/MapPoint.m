//
//  MapPoint.m
//  Traveller
//
//  Created by Will Gallia on 05/09/2012.
//  Copyright (c) 2012 . All rights reserved.
//

#import "MapPoint.h"

@interface MapPoint	()


@end

@implementation MapPoint 

@synthesize coordinate = _coordinate;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	
	if (self = [super init]) {
		self.coordinate = coordinate;
	}
	
	return self;
}

@end
