//
//  ParseRevealService.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 06.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ParseRevealService.h"

#import <ParseOSX/ParseOSX.h>

typedef void (^ParsePermissionCheckBlock)(BOOL enabled, NSError *error);
typedef void (^ParseFirstObjectBlock)(PFObject *firstObject, NSError *error);

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

- (void)getAclForCustomClass:(NSString *)customClassName
             completionBlock:(ParseCustomClassACLBlock)completion
{
    NSMutableDictionary *aclDictionary = [@{} mutableCopy];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [self checkGetPermissionForCustomClass:customClassName completionBlock:^(BOOL enabled, NSError *error) {
        [aclDictionary setObject:@(enabled) forKey:@"GET"];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self checkFindPermissionForCustomClass:customClassName completionBlock:^(BOOL enabled, NSError *error) {
        [aclDictionary setObject:@(enabled) forKey:@"FIND"];
        dispatch_group_leave(group);
    }];

    
    dispatch_group_notify(group, queue,^{
        NSLog(@"group begin");
        completion(aclDictionary, nil);
        NSLog(@"group end");
    });
}

#pragma mark - Private Methods

- (void)checkGetPermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    [self firstObjectInQueryForCustomClassName:customClassName completionBlock:^(PFObject *firstObject, NSError *error) {
        if (firstObject && !error) {
            NSString *firstObjectId = firstObject.objectId;
            
            PFObject *testObject = [PFQuery getObjectOfClass:customClassName
                                                    objectId:firstObjectId
                                                       error:&error];
            if (testObject && !error) {
                completion(YES, nil);
            } else {
                completion(NO, error);
            }
        } else {
            completion(NO, error);
        }
    }];
}

- (void)checkFindPermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    [self firstObjectInQueryForCustomClassName:customClassName completionBlock:^(PFObject *firstObject, NSError *error) {
        if (!error) {
            completion(YES, nil);
        } else {
            completion(NO, error);
        }
    }];
}

- (BOOL)checkUpdatePermissionForCustomClass:(NSString *)customClassName {

    
    return NO;
}

- (BOOL)checkCreatePermissionForCustomClass:(NSString *)customClassName {
    return NO;
}

- (BOOL)checkDeletePermissionForCustomClass:(NSString *)customClassName {
    return NO;
}

- (BOOL)checkAddFieldsPermissionForCustomClass:(NSString *)customClassName {
    return NO;
}

- (void)firstObjectInQueryForCustomClassName:(NSString *)customClassName completionBlock:(ParseFirstObjectBlock)completion {
    PFQuery *query = [PFQuery queryWithClassName:customClassName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && !error) {
            PFObject *firstObject = [objects firstObject];
            
            completion(firstObject, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
