//
//  LocationManager.m
//  Traveller
//
//  Created by Will Gallia on 06/09/2012.
//  Copyright (c) 2012 . All rights reserved.
//

#import "LocationManager.h"
#import "Updater.h"
#import "ViewController.h"

@interface LocationManager () <CLLocationManagerDelegate> {
	NSUInteger _counter;
	NSTimer *_timer;
	BOOL _doneUpdate;
}

@property (nonatomic, strong) CLLocationManager *locationManager;


@end

@implementation LocationManager

@synthesize viewController = _viewController;
@synthesize locationManager = _locationManager;
@synthesize locationAccuracy = _locationAccuracy;
@synthesize restInterval = _restInterval;

+ (id) manager {
	
	static LocationManager *instance = nil;
	
	if (!instance) {
		instance = [[super allocWithZone:nil] init];
	}
	
	return instance;
}

+ (id) allocWithZone:(NSZone *)zone {
	return [self manager];
}

- (id) init {
	
	if (self = [super init]) {
		
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		self.locationManager.delegate = self;

        [self.locationManager requestAlwaysAuthorization];
		
        NSLog(@"inited location manager!");
        
        self.restInterval = 5;
        self.locationAccuracy = 1000;
	}
	return self;
}

//CLLocationManagerDelegate
- (void) locationManager:(CLLocationManager *)manager 
		 didUpdateToLocation:(CLLocation *)newLocation 
						fromLocation:(CLLocation *)oldLocation	{

	if (_doneUpdate) {
		return;
	}
    
    NSLog(@"accuracy = %f", newLocation.horizontalAccuracy);
	
	if (newLocation.horizontalAccuracy <= self.locationAccuracy) {
		
		[Updater updateLocation:newLocation];
		[Updater updateFile:newLocation];
		
		[self.locationManager stopUpdatingLocation];
		
		NSString *updateTime = [NSDateFormatter localizedStringFromDate:newLocation.timestamp 
																													dateStyle:NSDateFormatterNoStyle 
																													timeStyle:NSDateFormatterMediumStyle];
		[self.viewController.lastUpdateLabel setText:[@"Last startUpdating: " stringByAppendingString:updateTime]];
		[self.viewController updateMapWithLocation:newLocation];
		
		[self startUpdating:YES];
		_doneUpdate = YES;
//		NSLog(@"done, accuracy = %f", newLocation.horizontalAccuracy);
	}
	
	else {
//		NSLog(@"no good location, accuracy = %f", newLocation.horizontalAccuracy);
	}
	
}

- (void) mainUpdate {
	
	if (_counter >= self.restInterval) {
		
		[self.locationManager startUpdatingLocation];
		
		[self startUpdating:NO];
        self.viewController.countdownLabel.text = @"";
		self.viewController.lastUpdateLabel.text = @"looking";
		_counter = 0;
		NSLog(@"started looking");
		_doneUpdate = NO;
		
	}
	
	self.viewController.countdownLabel.text = [@"" stringByAppendingFormat:@"%i", self.restInterval - _counter];
	NSLog(@"waiting: %i", self.restInterval - _counter);
	
	_counter++;
}

- (void) startUpdating:(BOOL)update {

    [_timer invalidate];
    _timer = nil;
    
	if (update) {
				
		_timer = [NSTimer timerWithTimeInterval:1 
                                         target:self
                                       selector:@selector(mainUpdate) userInfo:nil repeats:YES];
		
		[[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
	}
}

- (void) dealloc {
	self.locationManager.delegate = nil;
}


@end
