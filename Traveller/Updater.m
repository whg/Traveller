//
//  Updater.m
//  Traveller
//
//  Created by Will Gallia on 06/09/2012.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Updater.h"

static BOOL _doLiveUpdates = TRUE;

static const NSString *UPDATE_BASE_URL = @"http://where.are.maia.and.willgallia.com/update.php?";

@implementation Updater

+ (void) setLiveUpdates:(BOOL)doLive {
	_doLiveUpdates = doLive;
}

+ (NSURL*) urlWithLocation: (CLLocation*) location {

	CLLocationCoordinate2D coord = [location coordinate];
	NSString *params = [@"" stringByAppendingFormat:@"lon=%f&lat=%f&time=%f&hacc=%f&vacc=%f",
											coord.longitude, coord.latitude,
											[location.timestamp timeIntervalSince1970],
                                            [location horizontalAccuracy], [location verticalAccuracy]];
    
	NSString *urlString = [UPDATE_BASE_URL stringByAppendingString:params];
    NSLog(@"%@", urlString);
	return [NSURL URLWithString:urlString];
}

+ (NSURL*) urlWithState: (TravellerState) state {
//	switch (state) {
//		case ON_STATE:
//            url = [UPDATE_BASE_URL stringByAppendingString:@"stat
//			return [NSURL URLWithString:@"http://where.is.wgallia.com/update.py?status=CYCLING"];
//		case OFF_STATE:
//			return [NSURL URLWithString:@"http://where.is.wgallia.com/update.py?status=resting"];
//	}
    return [[NSURL alloc] init];
}

+ (void) sendRequest: (NSURL*) url {
	
	if (_doLiveUpdates) {
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request 
																																	delegate:self];
		[connection start];
		
		NSLog(@"connection started");
	}
}

+ (void) updateLocation:(CLLocation *)location {
	
	NSURL *url = [self urlWithLocation:location];
	[self sendRequest:url];
}

+ (void) updateState:(TravellerState)state {
	
	NSURL *url = [self urlWithState:state];
	[self sendRequest:url];
}

+ (void) resetFile {

	NSString *filepath = [DOCUMENTS_DIRECTORY stringByAppendingPathComponent:FILENAME];
	[[NSFileManager defaultManager] createFileAtPath:filepath contents:nil attributes:nil];
}

+ (void) updateFile:(CLLocation *)location {
	

	NSString *filepath = [DOCUMENTS_DIRECTORY stringByAppendingPathComponent:FILENAME];
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filepath];
	[fileHandle seekToEndOfFile];
	
	CLLocationCoordinate2D coord = [location coordinate];
	NSString *line = [NSString stringWithFormat:@"%f,%f,%f\n", coord.longitude, coord.latitude, [location.timestamp timeIntervalSince1970]];
	[fileHandle writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
	
	[fileHandle closeFile];
}

+ (NSString*) uploadFile {
	
	//taken from: http://zcentric.com/2008/08/29/post-a-uiimage-to-the-web/
	
	NSURL *url = [NSURL URLWithString:@"http://where.are.maia.and.willgallia.com/upload.php"];
	NSString *filepath = [DOCUMENTS_DIRECTORY stringByAppendingPathComponent:FILENAME];
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:filepath];
	NSData *data = [file readDataToEndOfFile];
	
	
	// setting up the request object now
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same 
	 as my output from wireshark on a valid html post
	 */
	NSString *boundary = @"--AA";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	[body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"filename\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	return [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
}

@end
