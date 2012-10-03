//
//  MapPoint.h
//  Traveller
//
//  Created by Will Gallia on 05/09/2012.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapPoint : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id) initWithCoordinate: (CLLocationCoordinate2D) coordinate;


@end
