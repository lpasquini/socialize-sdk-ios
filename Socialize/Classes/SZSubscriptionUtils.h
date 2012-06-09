//
//  SZSubscriptionUtils.h
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 6/4/12.
//  Copyright (c) 2012 Socialize, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocializeObjects.h"

typedef enum {
    SZSubscriptionTypeNewComments,
} SZSubscriptionType;

NSString *NSStringFromSZSubscriptionType(SZSubscriptionType type);

@interface SZSubscriptionUtils : NSObject

+ (void)subscribeToEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type success:(void(^)(id<SZSubscription> subscription))success failure:(void(^)(NSError *error))failure;
+ (void)unsubscribeFromEntity:(id<SZEntity>)entity subscriptionType:(SZSubscriptionType)type success:(void(^)(id<SZSubscription> subscription))success failure:(void(^)(NSError *error))failure;

@end