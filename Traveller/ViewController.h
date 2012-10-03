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
@property (nonatomic, weak) IBOutlet UIButton *countdownButton;


- (void) updateMapWithLocation: (CLLocation*) location;

@end
