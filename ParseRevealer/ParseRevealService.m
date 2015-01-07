//
//  ParseRevealService.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 06.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ParseRevealService.h"
#import "PermissionCheckingService.h"
#import "Constants.h"

#import <ParseOSX/ParseOSX.h>

typedef void (^ParseCustomClassACLBlock)(NSDictionary *aclDictionary, NSError *error);

@implementation ParseRevealService

#pragma mark - Public Methods

- (void)checkParseForApplicationId:(NSString *)applicationId
                         clientKey:(NSString *)clientKey
                   completionBlock:(ParseAccountCheckBlock)completion
{
    [Parse setApplicationId:applicationId clientKey:clientKey];
    
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completion(error);
    }];
}

- (void)getAclForCustomClasses:(NSArray *)customClasses
               completionBlock:(ParseCustomClassesACLBlock)completion
{
    dispatch_group_t group = dispatch_group_create();
    NSMutableDictionary *customClassesACLs = [@{} mutableCopy];
    
    for (NSString *customClassName in customClasses) {
        dispatch_group_enter(group);
        [self getAclForCustomClass:customClassName completionBlock:^(NSDictionary *aclDictionary, NSError *error) {
            [customClassesACLs setObject:aclDictionary forKey:customClassName];
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        completion(customClassesACLs, nil);
    });
}

- (void)getAclForCustomClass:(NSString *)customClassName
             completionBlock:(ParseCustomClassACLBlock)completion
{
    NSMutableDictionary *aclDictionary = [@{} mutableCopy];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkGetPermissionForCustomClass:customClassName completionBlock:^(ParseACLPermission permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:ParseGetPermissionKey];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkFindPermissionForCustomClass:customClassName completionBlock:^(ParseACLPermission permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:ParseFindPermissionKey];
        dispatch_group_leave(group);
    }];

    dispatch_group_enter(group);
    [PermissionCheckingService checkUpdatePermissionForCustomClass:customClassName completionBlock:^(ParseACLPermission permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:ParseUpdatePermissionKey];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkCreatePermissionForCustomClass:customClassName completionBlock:^(ParseACLPermission permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:ParseCreatePermissionKey];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkDeletePermissionForCustomClass:customClassName completionBlock:^(ParseACLPermission permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:ParseDeletePermissionKey];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkAddFieldsPermissionForCustomClass:customClassName completionBlock:^(ParseACLPermission permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:ParseAddFieldsPermissionKey];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(aclDictionary, nil);
    });
}


@end
