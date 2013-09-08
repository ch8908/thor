//
// Created by Huang ChienShuo on 8/22/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class FacebookDaemon;


@interface Beans : NSObject
@property (nonatomic, readonly, strong) FacebookDaemon* facebookDaemon;

+ (id) sharedInstance;

- (void) configure;
@end