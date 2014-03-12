//
// Created by Huang ChienShuo on 2/16/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import "AbstractPref.h"


@interface BOOLPref()
@property BOOL defaultValue;
@property (copy) NSString *key;
@end

@implementation BOOLPref

+ (instancetype) prefWithKey:(NSString *) key
{
    return [[self alloc] initWithKey:key defaultValue:NO];
}

+ (instancetype) prefWithKey:(NSString *) key defaultValue:(BOOL) defaultValue
{
    return [[self alloc] initWithKey:key defaultValue:defaultValue];
}

- (id) initWithKey:(NSString *) key defaultValue:(BOOL) defaultValue
{
    self = [super init];
    if (self)
    {
        _key = key;
        _defaultValue = defaultValue;
    }

    return self;
}

- (void) setBool:(BOOL) boolValue
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:boolValue] forKey:self.key];
}

- (BOOL) getBool
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:self.key] boolValue];
}

@end

@interface NSStringPref()
@property (copy) NSString *defaultValue;
@property (copy) NSString *key;
@end

@implementation NSStringPref

+ (instancetype) prefWithKey:(NSString *) key
{
    return [[self alloc] initWithKey:key defaultString:nil];
}

+ (instancetype) prefWithKey:(NSString *) key defaultString:(NSString *) defaultString
{
    return [[self alloc] initWithKey:key defaultString:defaultString];
}

- (instancetype) initWithKey:(NSString *) key defaultString:(NSString *) defaultString
{
    self = [super init];
    if (self)
    {
        _key = [key copy];
        _defaultValue = [defaultString copy];
        if (defaultString)
        {
            [self setString:defaultString];
        }
    }

    return self;
}

- (void) setString:(NSString *) defaultString
{
    [[NSUserDefaults standardUserDefaults] setObject:defaultString forKey:self.key];
}

- (NSString *) getString
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.key];
}

- (void) removeString
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.key];
}

@end

@interface NSNumberPref()
@property NSNumber *defaultNumber;
@property (copy) NSString *key;
@end

@implementation NSNumberPref

+ (instancetype) prefWithKey:(NSString *) key
{
    return [[self alloc] initWithKey:key defaultNumber:nil];
}

+ (instancetype) prefWithKey:(NSString *) key defaultNumber:(NSNumber *) defaultNumber
{
    return [[self alloc] initWithKey:key defaultNumber:defaultNumber];
}

- (instancetype) initWithKey:(NSString *) key defaultNumber:(NSNumber *) defaultNumber
{
    self = [super init];
    if (self)
    {
        _key = [key copy];
        _defaultNumber = defaultNumber;
        if (defaultNumber)
        {
            [self setNumber:defaultNumber];
        }
    }

    return self;
}

- (void) setNumber:(NSNumber *) defaultNumber
{
    [[NSUserDefaults standardUserDefaults] setObject:defaultNumber forKey:self.key];
}

- (NSNumber *) getNumber
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.key];
}

- (void) removeNumber
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.key];
}

@end

@implementation AbstractPref
@end