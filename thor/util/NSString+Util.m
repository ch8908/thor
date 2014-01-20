//
// Created by Huang ChienShuo on 9/15/13.
// Copyright (c) 2013 ThousandSquare. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSString+Util.h"


@implementation NSString(Util)
/**
* trim white space and new line
*/
- (NSString*) stringByTrim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL) isEmpty:(NSString*) string
{
    return !string || string.length == 0;
}

+ (BOOL) isEmptyAfterTrim:(NSString*) string
{
    return [NSString isEmpty:[string stringByTrim]];
}
@end