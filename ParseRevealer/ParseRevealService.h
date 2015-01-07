//
//  ParseRevealService.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 06.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ParseACLPermission) {
    ParseACLPermissionFalse = 0,
    ParseACLPermissionTrue = 1,
    ParseACLPermissionUnknown = 2
};

typedef void (^ParseAccountCheckBlock)(NSError *error);

typedef void (^ParseCustomClassesACLBlock)(NSDictionary *customClassesACLs, NSError *error);

@interface ParseRevealService : NSObject

- (void)checkParseForApplicationId:(NSString *)applicationId
                         clientKey:(NSString *)clientKey
                   completionBlock:(ParseAccountCheckBlock)completion;

- (void)getAclForCustomClasses:(NSArray *)customClasses
               completionBlock:(ParseCustomClassesACLBlock)completion;

@end
