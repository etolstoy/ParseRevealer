//
//  ParseRevealService.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 06.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ParseRevealService.h"
#import "PermissionCheckingService.h"
#import "ParseClassModel.h"
#import "Constants.h"

#import <ParseOSX/ParseOSX.h>

typedef void (^ParseCustomClassACLBlock)(NSError *error);

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
    
    for (ParseClassModel *classModel in customClasses) {
        dispatch_group_enter(group);
        [self getAclForCustomClass:classModel completionBlock:^(NSError *error) {
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        completion(customClasses, nil);
    });
}

- (void)getAclForCustomClass:(ParseClassModel *)customClass
             completionBlock:(ParseCustomClassACLBlock)completion
{
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkGetPermissionForCustomClass:customClass.className completionBlock:^(ParseACLPermissionCode permission, NSError *error) {
        [customClass updatePermission:ParseGetPermissionKey withValue:permission];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkFindPermissionForCustomClass:customClass.className completionBlock:^(ParseACLPermissionCode permission, NSError *error) {
        [customClass updatePermission:ParseFindPermissionKey withValue:permission];
        dispatch_group_leave(group);
    }];

    dispatch_group_enter(group);
    [PermissionCheckingService checkUpdatePermissionForCustomClass:customClass.className completionBlock:^(ParseACLPermissionCode permission, NSError *error) {
        [customClass updatePermission:ParseUpdatePermissionKey withValue:permission];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkCreatePermissionForCustomClass:customClass.className completionBlock:^(ParseACLPermissionCode permission, NSError *error) {
        [customClass updatePermission:ParseCreatePermissionKey withValue:permission];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkDeletePermissionForCustomClass:customClass.className completionBlock:^(ParseACLPermissionCode permission, NSError *error) {
        [customClass updatePermission:ParseDeletePermissionKey withValue:permission];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkAddFieldsPermissionForCustomClass:customClass.className completionBlock:^(ParseACLPermissionCode permission, NSError *error) {
        [customClass updatePermission:ParseAddFieldsPermissionKey withValue:permission];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(nil);
    });
}

#pragma mark - Private Methods


@end
