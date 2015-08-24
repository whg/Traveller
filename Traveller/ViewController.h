//
//  ViewController.h
//  Traveller
//
//  Created by Will Gallia on 05/09/2012.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocation;

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *lastUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;


- (void) updateMapWithLocation: (CLLocation*) location;

@end
