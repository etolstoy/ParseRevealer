//
//  ParseRevealService.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 06.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ParseAccountCheckBlock)(NSError *error);

typedef void (^ParseCustomClassesACLBlock)(NSDictionary *customClassesACLs, NSError *error);

@interface ParseRevealService : NSObject

/**
 *  Method checks, if the provided application keys are valid. If they are, application logs into Parse.
 *
 *  @param applicationId Parse Application ID key
 *  @param clientKey     Parse Client key
 *  @param completion    Completion block
 */
- (void)checkParseForApplicationId:(NSString *)applicationId
                         clientKey:(NSString *)clientKey
                   completionBlock:(ParseAccountCheckBlock)completion;

/**
 *  Method performs a set of permissions checks on a provided array of Parse classes
 *
 *  @param customClasses Array of Parse custom classes. Installation and User should not be included
 *  @param completion    Completion block
 */
- (void)getAclForCustomClasses:(NSArray *)customClasses
               completionBlock:(ParseCustomClassesACLBlock)completion;

@end
