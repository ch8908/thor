//
// Created by Huang ChienShuo on 8/21/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreLocation/CoreLocation.h>
#import "FacebookDaemon.h"
#import "JSONKit.h"
#import "Place.h"


@interface FacebookDaemon()<NSURLConnectionDataDelegate>
@property (nonatomic, readwrite) NSMutableData* receivedData;
@end

@implementation FacebookDaemon
@synthesize receivedData = _receivedData;

- (NSArray*) queryPlace
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"testJson" ofType:@"json" inDirectory:@"res"];
    NSError* error;
    NSString* json = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding
                                                        error:&error];

    NSDictionary* jsonDic = [json objectFromJSONString];

    NSArray* jsonDataList = [jsonDic objectForKey:@"data"];

    NSMutableArray* placeList = [[NSMutableArray alloc] init];
    for (NSDictionary* place in jsonDataList)
    {
        Place* newPlace = [[Place alloc] initWithName:[place objectForKey:@"name"]
                                                   id:[place objectForKey:@"id"]
                                              address:[[place objectForKey:@"location"] objectForKey:@"street"]
                                             latitude:[[place objectForKey:@"latitude"] doubleValue]
                                            longitude:[[place objectForKey:@"longitude"] doubleValue]];

        [placeList addObject:newPlace];
//        NSLog(@">>> place:%@, %@, %@, %f, %f", newPlace.name, newPlace.id, newPlace.address, newPlace.latitude, newPlace.longitude);
    }

    NSLog(@">>>>> placeList.count:%i", placeList.count);
    return [placeList copy];
}

- (void) connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse*) response
{
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _receivedData = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection*) connection didReceiveData:(NSData*) data
{
    // Append the new data to the instance variable you declared
    [self.receivedData appendData:data];
}

- (NSCachedURLResponse*) connection:(NSURLConnection*) connection
                  willCacheResponse:(NSCachedURLResponse*) cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void) connectionDidFinishLoading:(NSURLConnection*) connection
{
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@">>>>>>>>> receivedData:%@", [self.receivedData mutableObjectFromJSONData]);
}

- (void) connection:(NSURLConnection*) connection didFailWithError:(NSError*) error
{
    // The request has failed for some reason!
    // Check the error var
    NSLog(@">>>>>>>>> didFailWithError:%@", error);
}

@end