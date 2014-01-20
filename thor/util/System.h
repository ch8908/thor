//
// Created by Huang ChienShuo on 12/28/13.
// Copyright (c) 2013 Liq. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface System : NSObject
+ (BOOL) isMinimumiOS7;

+ (BOOL) isMinimumiOS6;

+ (NSString*) systemVersion;

+ (NSString*) UUIDString;

+ (NSString* ) deviceModel;

+ (NSString*) country;

+ (NSString*) mcc;

+ (NSString*) mnc;

+ (NSString*) icc;

+ (NSString*) currency;
@end