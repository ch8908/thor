//
// Created by liq on 12/24/13.
// Copyright (c) 2013 Liq. All rights reserved.
//

#import "Pref.h"

@interface Pref()
@property (nonatomic, strong) NSUserDefaults* userDefaults;
@end

@implementation Pref
@synthesize userDefaults = _userDefaults;

+ (id) sharedInstance
{
    static Pref* sharedMyInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });

    return sharedMyInstance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }

    return self;
}

- (void) setDeviceToken:(NSString*) token
{
    [self.userDefaults setObject:token forKey:@"DEVICE_TOKEN"];
}

- (NSString*) deviceToken
{
    return [self.userDefaults objectForKey:@"DEVICE_TOKEN"];
}

- (void) setAuthenticationToken:(NSString*) token
{
    [self.userDefaults setObject:token forKey:@"AUTHENTICATION_TOKEN"];
}

- (NSString*) authenticationToken
{
    return [self.userDefaults objectForKey:@"AUTHENTICATION_TOKEN"];
}

@end