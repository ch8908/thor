//
// Created by Huang ChienShuo on 2/22/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "ThorUis.h"
#import "I18N.h"


@implementation ThorUis

+ (NSString *) searchDistanceString:(NSNumber *) number
{
    return [NSString stringWithFormat:@"%@ %@", number, [I18N key:@"distance_unit"]];
}

+ (NSString *) currentVersion
{
    NSString *versionCode = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *) kCFBundleVersionKey];
    return versionCode;
}

+ (NSString *) bundleDisplayName
{
    NSString *versionCode = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *) kCFBundleNameKey];
    return versionCode;
}

@end