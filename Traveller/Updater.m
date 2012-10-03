//
//  Updater.m
//  Traveller
//
//  Created by Will Gallia on 06/09/2012.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Updater.h"

static BOOL _doLiveUpdates = TRUE;

@implementation Updater

+ (void) setLiveUpdates:(BOOL)doLive {
	_doLiveUpdates = doLive;
}

+ (NSURL*) urlWithLocation: (CLLocation*) location {

	CLLocationCoordinate2D coord = [location coordinate];
	NSString *params = [@"" stringByAppendingFormat:@"long=%f&latt=%f&timestamp=%f", 
											coord.longitude, coord.latitude,
											[location.timestamp timeIntervalSince1970]];
	NSString *urlString = [@"http://where.is.wgallia.com/update.py?" stringByAppendingString:params];
	return [NSURL URLWithString:urlString];
}

+ (NSURL*) urlWithState: (TravellerState) state {
	switch (state) {
		case ON_STATE:
			return [NSURL URLWithString:@"http://where.is.wgallia.com/update.py?status=CYCLING"];
		case OFF_STATE:
			return [NSURL URLWithString:@"http://where.is.wgallia.com/update.py?status=resting"];
	}
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
	
	NSURL *url = [NSURL URLWithString:@"http://where.is.wgallia.com/upload.php"];
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
	NSString *boundary = [NSString stringWithString:@"--AA"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"file\"; filename=\"filename\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	return [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
}

@end