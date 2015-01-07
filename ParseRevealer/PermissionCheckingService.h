//
//  PermissionCheckingService.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 07.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

typedef void (^ParsePermissionCheckBlock)(ParseACLPermission permission, NSError *error);

@interface PermissionCheckingService : NSObject

+ (void)checkGetPermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion;
+ (void)checkFindPermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion;
+ (void)checkUpdatePermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion;
+ (void)checkCreatePermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion;
+ (void)checkDeletePermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion;
+ (void)checkAddFieldsPermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion;

@end
