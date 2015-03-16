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
    NSArray *parseClasses = [self parseClassesArrayWithClassNames:customClasses];
    
    for (ParseClassModel *classModel in parseClasses) {
        dispatch_group_enter(group);
        [self getAclForCustomClass:classModel.className completionBlock:^(NSDictionary *aclDictionary, NSError *error) {
            [customClassesACLs setObject:aclDictionary forKey:classModel.className];
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
    [PermissionCheckingService checkGetPermissionForCustomClass:customClassName completionBlock:^(ParseACLPermissionCode permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:ParseGetPermissionKey];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkFindPermissionForCustomClass:customClassName completionBlock:^(ParseACLPermissionCode permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:ParseFindPermissionKey];
        dispatch_group_leave(group);
    }];

    dispatch_group_enter(group);
    [PermissionCheckingService checkUpdatePermissionForCustomClass:customClassName completionBlock:^(ParseACLPermissionCode permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:ParseUpdatePermissionKey];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkCreatePermissionForCustomClass:customClassName completionBlock:^(ParseACLPermissionCode permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:ParseCreatePermissionKey];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkDeletePermissionForCustomClass:customClassName completionBlock:^(ParseACLPermissionCode permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:ParseDeletePermissionKey];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [PermissionCheckingService checkAddFieldsPermissionForCustomClass:customClassName completionBlock:^(ParseACLPermissionCode permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:ParseAddFieldsPermissionKey];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(aclDictionary, nil);
    });
}

#pragma mark - Private Methods

- (NSArray *)parseClassesArrayWithClassNames:(NSArray *)classNames {
    NSSet *filteredCustomClasses = [self filterCustomClassesArray:classNames];
    NSMutableArray *parseClasses = [@[] mutableCopy];
    for (NSString *className in filteredCustomClasses) {
        ParseClassModel *classModel = [ParseClassModel objectWithClassName:className];
        [parseClasses addObject:classModel];
    }
    return [parseClasses copy];
}

- (NSSet *)filterCustomClassesArray:(NSArray *)customClassesArray {
    NSArray *prohibitedClassNames = @[
                                      @"User",
                                      @"Installation",
                                      @"_User",
                                      @"_Installation"
                                      ];
    
    NSMutableSet *customClassesSet = [NSMutableSet setWithArray:customClassesArray];
    
    for (NSString *prohibitedClassName in prohibitedClassNames) {
        [customClassesSet removeObject:prohibitedClassName];
    }
    
    return customClassesSet;
}

@end
