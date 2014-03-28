//
// Created by Huang ChienShuo on 1/17/14.
// Copyright (c) 2014 oSolve. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

extern NSString *const TRCoffeeServiceErrorDomain;

typedef NS_ENUM(NSInteger, TRCoffeeServiceErrorCode)
{
    TRCoffeeServiceServerReturnErrorCode = 0,
    TRCoffeeServiceNetworkIssueCode,
};

/*
* Result for search
* */
@interface AutoCompleteResult : NSObject
@property (nonatomic, strong) NSArray *candidates;
@property (nonatomic, copy) NSString *searchText;

- (id) initWithCandidates:(NSArray *) candidates searchText:(NSString *) searchText;

@end

/*
* Register Source
* */

@interface ServiceRegisterSource : NSObject
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *confirmPassword;
@end


/*
* Login Source
* */

@interface ServiceLoginSource : NSObject
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@end


@class SubmitInfo;
@class BFTask;

@interface CoffeeService : NSObject
+ (id) sharedInstance;

- (BFTask *) fetchShopsWithCenter:(CLLocationCoordinate2D) coordinate2D searchDistance:(NSNumber *) distance;

- (BFTask *) fetchDetailWithShopId:(NSNumber *) number;

- (BFTask *) resisterWithParams:(ServiceRegisterSource *) source;

- (BFTask *) loginWithSource:(ServiceLoginSource *) source;

- (BFTask *) submitShopInfo:(SubmitInfo *) info;

- (BFTask *) decodeShops:(id) object;

- (BFTask *) autoCompleteResultWithSearchText:(NSString *) searchText;

@end