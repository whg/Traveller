//
//  LocationManager.h
//  Traveller
//
//  Created by Will Gallia on 06/09/2012.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ViewController;

@interface LocationManager : NSObject

@property (nonatomic, weak) ViewController *viewController;

@property (nonatomic, assign) CLLocationAccuracy locationAccuracy;
@property (nonatomic, assign) NSUInteger restInterval;

+ (id) manager;

- (void) update: (BOOL) update;

@end
