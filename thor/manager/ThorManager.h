//
// Created by Huang ChienShuo on 1/14/14.
// Copyright (c) 2014 ThousandSquare. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* LoadShopFailedNotification;
extern NSString* LoadShopSuccessNotification;

@interface ThorManager : NSObject
+ (id) sharedInstance;

- (void) fetchFromServer;
@end