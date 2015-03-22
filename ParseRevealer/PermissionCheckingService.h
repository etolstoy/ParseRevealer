//
//  PermissionCheckingService.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 07.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

typedef void (^ParsePermissionCheckBlock)(ParseACLPermissionCode permission, NSError *error);

@interface PermissionCheckingService : NSObject

/**
 *  The method checks GET permission for the given Parse Custom Class
 *
 *  @param customClassName Parse Custom Class name
 *  @param completion      Completion block
 */
- (void)checkGetPermissionForCustomClass:(NSString *)customClassName
                         completionBlock:(ParsePermissionCheckBlock)completion;

/**
 *  The method checks FIND permission for the given Parse Custom Class
 *
 *  @param customClassName Parse Custom Class name
 *  @param completion      Completion block
 */
- (void)checkFindPermissionForCustomClass:(NSString *)customClassName
                          completionBlock:(ParsePermissionCheckBlock)completion;

/**
 *  The method checks UPDATE permission for the given Parse Custom Class
 *
 *  @param customClassName Parse Custom Class name
 *  @param completion      Completion block
 */
- (void)checkUpdatePermissionForCustomClass:(NSString *)customClassName
                            completionBlock:(ParsePermissionCheckBlock)completion;

/**
 *  The method checks CREATE permission for the given Parse Custom Class
 *
 *  @param customClassName Parse Custom Class name
 *  @param completion      Completion block
 */
- (void)checkCreatePermissionForCustomClass:(NSString *)customClassName
                            completionBlock:(ParsePermissionCheckBlock)completion;

/**
 *  The method checks DELETE permission for the given Parse Custom Class
 *
 *  @param customClassName Parse Custom Class name
 *  @param completion      Completion block
 */
- (void)checkDeletePermissionForCustomClass:(NSString *)customClassName
                            completionBlock:(ParsePermissionCheckBlock)completion;

/**
 *  The method checks ADD FIELDS permission for the given Parse Custom Class
 *
 *  @param customClassName Parse Custom Class name
 *  @param completion      Completion block
 */
- (void)checkAddFieldsPermissionForCustomClass:(NSString *)customClassName
                               completionBlock:(ParsePermissionCheckBlock)completion;

@end
