//
//  ParseRevealService.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 06.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ParseRevealService.h"
#import "NSString+Random.h"

#import <ParseOSX/ParseOSX.h>

typedef void (^ParseCustomClassACLBlock)(NSDictionary *aclDictionary, NSError *error);
typedef void (^ParsePermissionCheckBlock)(ParseACLPermission permission, NSError *error);
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
    [self checkGetPermissionForCustomClass:customClassName completionBlock:^(ParseACLPermission permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:@"GET"];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self checkFindPermissionForCustomClass:customClassName completionBlock:^(ParseACLPermission permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:@"FIND"];
        dispatch_group_leave(group);
    }];

    dispatch_group_enter(group);
    [self checkUpdatePermissionForCustomClass:customClassName completionBlock:^(ParseACLPermission permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:@"UPDATE"];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self checkCreatePermissionForCustomClass:customClassName completionBlock:^(ParseACLPermission permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:@"CREATE"];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self checkDeletePermissionForCustomClass:customClassName completionBlock:^(ParseACLPermission permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:@"DELETE"];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self checkAddFieldsPermissionForCustomClass:customClassName completionBlock:^(ParseACLPermission permission, NSError *error) {
        [aclDictionary setObject:@(permission) forKey:@"ADD FIELDS"];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        completion(aclDictionary, nil);
    });
}

#pragma mark - Private Methods

- (void)checkGetPermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    [self firstObjectInQueryForCustomClassName:customClassName completionBlock:^(PFObject *firstObject, NSError *error) {
        if (!firstObject && !error) {
            completion(ParseACLPermissionUnknown, nil);
            return;
        }
        
        if (firstObject && !error) {
            NSString *firstObjectId = firstObject.objectId;
            
            PFObject *testObject = [PFQuery getObjectOfClass:customClassName
                                                    objectId:firstObjectId
                                                       error:&error];
            if (testObject && !error) {
                completion(ParseACLPermissionTrue, nil);
            } else if (error.code == 119) {
                completion(ParseACLPermissionFalse, error);
            } else {
                completion(ParseACLPermissionUnknown, error);
            }
        } else {
            completion(ParseACLPermissionUnknown, nil);
        }
    }];
}

- (void)checkFindPermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    [self firstObjectInQueryForCustomClassName:customClassName completionBlock:^(PFObject *firstObject, NSError *error) {
        if (!error) {
            completion(ParseACLPermissionTrue, nil);
        } else if (error.code == 119) {
            completion(ParseACLPermissionFalse, error);
        } else {
            completion(ParseACLPermissionUnknown, error);
        }
    }];
}

- (void)checkUpdatePermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    [self firstObjectInQueryForCustomClassName:customClassName completionBlock:^(PFObject *firstObject, NSError *error) {
        NSArray *allKeys = [firstObject allKeys];
        NSString *firstKey = [allKeys firstObject];
        
        if (!firstObject || !firstKey) {
            completion(ParseACLPermissionUnknown, nil);
            return;
        }
        
        [firstObject setValue:@"" forKey:firstKey];
        
        [firstObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded || error.code == 111) {
                completion(ParseACLPermissionTrue, nil);
            } else if (error.code == 119) {
                completion(ParseACLPermissionFalse, error);
            } else {
                completion(ParseACLPermissionUnknown, error);
            }
        }];
    }];
}

- (void)checkCreatePermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    PFObject *object = [PFObject objectWithClassName:customClassName];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            completion(ParseACLPermissionTrue, nil);
        } else if (error.code == 119) {
            completion(ParseACLPermissionFalse, error);
        } else {
            completion(ParseACLPermissionUnknown, error);
        }
    }];
}

- (void)checkDeletePermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    PFObject *object = [PFObject objectWithClassName:customClassName];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    completion(ParseACLPermissionTrue, nil);
                } else if (error.code == 119) {
                    completion(ParseACLPermissionFalse, error);
                } else {
                    completion(ParseACLPermissionUnknown, error);
                }
            }];
        } else {
            [self firstObjectInQueryForCustomClassName:customClassName completionBlock:^(PFObject *firstObject, NSError *error) {
                if (!firstObject && !error) {
                    completion(ParseACLPermissionUnknown, nil);
                    return;
                }
                if (!error) {
                    [firstObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            completion(ParseACLPermissionTrue, nil);
                        } else if (error.code == 119) {
                            completion(ParseACLPermissionFalse, error);
                        } else {
                            completion(ParseACLPermissionUnknown, error);
                        }
                    }];
                }  else {
                    completion(ParseACLPermissionUnknown, error);
                }
            }];
        }
    }];
}

- (void)checkAddFieldsPermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    
    PFObject *object = [PFObject objectWithClassName:customClassName];
    NSString *newFieldName = [NSString randomString];
    [object setValue:customClassName forKey:newFieldName];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            completion(ParseACLPermissionTrue, nil);
        } else {
            [self firstObjectInQueryForCustomClassName:customClassName completionBlock:^(PFObject *firstObject, NSError *error) {
                if (!firstObject && !error) {
                    completion(ParseACLPermissionUnknown, nil);
                    return;
                }
                
                if (!error) {
                    [firstObject setValue:customClassName forKey:newFieldName];
                    [firstObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            completion(ParseACLPermissionTrue, nil);
                        } else if (error.code == 119) {
                            completion(ParseACLPermissionFalse, error);
                        } else {
                            completion(ParseACLPermissionUnknown, error);
                        }
                    }];
                } else {
                    completion(ParseACLPermissionUnknown, error);
                }
            }];
        }
    }];
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
