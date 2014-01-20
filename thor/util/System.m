//
// Created by Huang ChienShuo on 12/28/13.
// Copyright (c) 2013 Liq. All rights reserved.
//

#import <CoreTelephony/CTCarrier.h>
#import "System.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation System

+ (BOOL) isMinimumiOS7
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
}

+ (BOOL) isMinimumiOS6
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0");
}

+ (NSString*) systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString*) UUIDString
{
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}

+ (NSString*) deviceModel
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return @"iPad";
    }
    return @"iPhone";
}

+ (NSString*) country
{
    NSLocale* currentLocale = [NSLocale currentLocale];
    return [currentLocale objectForKey:NSLocaleCountryCode];
}

+ (NSString*) mcc
{
    CTCarrier* carrier = [[CTCarrier alloc] init];
    return [carrier mobileCountryCode] ? [carrier mobileCountryCode] : @"";
}

+ (NSString*) mnc
{
    CTCarrier* carrier = [[CTCarrier alloc] init];
    return [carrier mobileNetworkCode] ? [carrier mobileNetworkCode] : @"";
}

+ (NSString*) icc
{
    CTCarrier* carrier = [[CTCarrier alloc] init];
    return [carrier isoCountryCode] ? [carrier isoCountryCode] : @"";
}

+ (NSString*) currency
{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    return [formatter currencyCode];
}
@end