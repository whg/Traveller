//
//  Updater.h
//  Traveller
//
//  Created by Will Gallia on 06/09/2012.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


#define DOCUMENTS_DIRECTORY ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0])

#define FILENAME @"locations"

typedef enum { ON_STATE, OFF_STATE } TravellerState;


@interface Updater : NSObject

+ (void) updateLocation: (CLLocation*) location;
+ (void) updateState: (TravellerState) state;

+ (void) updateFile: (CLLocation*) location;
+ (NSString*) uploadFile;

+ (void) setLiveUpdates: (BOOL) doLive;

@end
