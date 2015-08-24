//
//  ViewController.m
//  Traveller
//
//  Created by Will Gallia on 05/09/2012.
//  Copyright (c) 2012 . All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapPoint.h"
#import "LocationManager.h"
#import "Updater.h"

@interface ViewController () {
	
	LocationManager *_locationManager;
	
	MapPoint *_mapPoint;
	
	__weak IBOutlet MKMapView *_mapView;
	__weak IBOutlet UISwitch *_switch;
	__weak IBOutlet UILabel *_restTimeLabel;
	__weak IBOutlet UILabel *_distanceThresholdLabel;
	__weak IBOutlet UILabel *_backupResultLabel;
}


- (IBAction)restIntervalChanged:(id)sender;
- (IBAction)distanceThresholdChanged:(id)sender;
- (IBAction)backupPressed:(id)sender;
- (IBAction)backupSwitchChanged:(id)sender;
- (IBAction)startButtonPressed:(id)sender;


@end

@implementation ViewController

@synthesize lastUpdateLabel = _lastUpdateLabel;
@synthesize countdownLabel = _countdownLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	//	[self.locationManager startUpdatingLocation];
	
	_locationManager = [LocationManager manager];
    
    _distanceThresholdLabel.text = [@"" stringByAppendingFormat:@"%.1fm", _locationManager.locationAccuracy];
    _restTimeLabel.text = [@"" stringByAppendingFormat:@"%is", _locationManager.restInterval];
    
    

    
	
	CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(0, 0);
	_mapPoint = [[MapPoint alloc] initWithCoordinate:loc];
	[_mapView addAnnotation:_mapPoint];
	
	if (_switch.isOn) {
		[_locationManager startUpdating:YES];
	}
	
}

- (void)viewDidUnload {
	_mapView = nil;
	[super viewDidUnload];
	// Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated {
	
//	NSLog(@"%@", NSStringFromSelector(_cmd));
	
	[[LocationManager manager] setViewController:self];
}

- (void) viewWillDisappear:(BOOL)animated {
//	NSLog(@"%@", NSStringFromSelector(_cmd));

	[[LocationManager manager] setViewController:nil];
}

- (void) updateMapWithLocation:(CLLocation *)location {

	[_mapPoint setCoordinate:location.coordinate];
	
	MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, 
                                                       MKCoordinateSpanMake(0.1, 0.1));
	
	_mapView.region = region;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)switchPressed:(id)sender {

	[[LocationManager manager] startUpdating:[sender isOn]];
//	NSLog(@"started %i", [sender isOn]);
}

- (IBAction)buttonPressed:(id)sender {

//		[UIView animateWithDuration:0.3
//										 animations:^{
//											 _mapView.frame = CGRectMake(0, 0, 320, 400);
//										 }];

}

- (IBAction)distanceThresholdChanged:(id)sender {
	UISlider *slider = (UISlider*) sender;
	float threshold = slider.value;
	_distanceThresholdLabel.text = [@"" stringByAppendingFormat:@"%.1fm", threshold];
	
	[[LocationManager manager] setLocationAccuracy:threshold];
}

- (IBAction)restIntervalChanged:(id)sender {
	
	UISlider *slider = (UISlider*) sender;
	NSUInteger restInterval = roundf(slider.value);
	_restTimeLabel.text = [@"" stringByAppendingFormat:@"%is", restInterval];
	
	[[LocationManager manager] setRestInterval:restInterval];
}

- (IBAction)backupPressed:(id)sender {
	
	_backupResultLabel.text = @"";
	_backupResultLabel.text = [Updater uploadFile];
	
}

- (IBAction)startButtonPressed:(id)sender {
	
	[Updater resetFile];
	
	[_switch setOn:YES];
	[self switchPressed:_switch]; //this kicks everything off
	
}


- (IBAction)backupSwitchChanged:(id)sender {
	
	[Updater setLiveUpdates:[sender isOn]];
}

- (void) dealloc {
	
//	NSLog(@"%@", NSStringFromSelector(_cmd));
	
}
@end
