//
// Created by Huang ChienShuo on 9/12/13.
// Copyright (c) 2013 oSolve. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "I18N.h"


@implementation I18N

+ (NSString *) key:(NSString *) localizedKey, ...
{
    NSString *format = [[NSBundle mainBundle] localizedStringForKey:localizedKey
                                                              value:[NSString stringWithFormat:@"!%@!", localizedKey]
                                                              table:nil];

    va_list vl;
    va_start(vl, localizedKey);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:vl];
    va_end(vl);

    return str;
}

@end