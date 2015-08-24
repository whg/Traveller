//
//  AppDelegate.m
//  Traveller
//
//  Created by Will Gallia on 05/09/2012.
//  Copyright (c) 2012 . All rights reserved.
//

#import "AppDelegate.h"
#import "LocationManager.h"
#import "Updater.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"makefile"]) {

		NSString *filepath = [DOCUMENTS_DIRECTORY stringByAppendingPathComponent:FILENAME];
		[[NSFileManager defaultManager] createFileAtPath:filepath contents:nil attributes:nil];
		
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"makefile"];
		
		NSLog(@"created");
	}
	
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	NSLog(@"%@", NSStringFromSelector(_cmd));
	
	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
    if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
			UIApplication *application = [UIApplication sharedApplication]; //Get the shared application instance
			
			__block UIBackgroundTaskIdentifier background_task; //Create a task object
			
			background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
				[application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
				background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
				
                NSLog(@"background task has ended");
                
				//System will be shutting down the app at any point in time now
			}];
			
			//Background tasks require you to use asyncrous tasks
			
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				//Perform your tasks that your application requires
				
				NSLog(@"\n\nRunning in the background!\n\n");
				
				[[LocationManager manager] startUpdating:YES];
				
//				[application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
//				background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
			});
    }
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	NSLog(@"%@", NSStringFromSelector(_cmd));
	
//	[[LocationManager manager] startUpdating:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
