//
//  PermissionCheckingService.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 07.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "PermissionCheckingService.h"
#import "NSString+Random.h"

#import <ParseOSX/ParseOSX.h>

static NSInteger const ParseOperationNotAllowedErrorCode = 119;
static NSInteger const ParseWrongDataFormatErrorCode = 111;

typedef void (^ParseFirstObjectBlock)(PFObject *firstObject, NSError *error);

@implementation PermissionCheckingService

#pragma mark - Permissions Checking Methods

+ (void)checkGetPermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
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
            } else if (error.code == ParseOperationNotAllowedErrorCode) {
                completion(ParseACLPermissionFalse, error);
            } else {
                completion(ParseACLPermissionUnknown, error);
            }
        } else {
            completion(ParseACLPermissionUnknown, nil);
        }
    }];
}

+ (void)checkFindPermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    [self firstObjectInQueryForCustomClassName:customClassName completionBlock:^(PFObject *firstObject, NSError *error) {
        if (!error) {
            completion(ParseACLPermissionTrue, nil);
        } else if (error.code == ParseOperationNotAllowedErrorCode) {
            completion(ParseACLPermissionFalse, error);
        } else {
            completion(ParseACLPermissionUnknown, error);
        }
    }];
}

+ (void)checkUpdatePermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    [self firstObjectInQueryForCustomClassName:customClassName completionBlock:^(PFObject *firstObject, NSError *error) {
        NSArray *allKeys = [firstObject allKeys];
        NSString *firstKey = [allKeys firstObject];
        
        if (!firstObject || !firstKey) {
            completion(ParseACLPermissionUnknown, nil);
            return;
        }
        
        [firstObject setValue:@"" forKey:firstKey];
        
        [firstObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded || error.code == ParseWrongDataFormatErrorCode) {
                completion(ParseACLPermissionTrue, nil);
            } else if (error.code == ParseOperationNotAllowedErrorCode) {
                completion(ParseACLPermissionFalse, error);
            } else {
                completion(ParseACLPermissionUnknown, error);
            }
        }];
    }];
}

+ (void)checkCreatePermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    PFObject *object = [PFObject objectWithClassName:customClassName];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            completion(ParseACLPermissionTrue, nil);
        } else if (error.code == ParseOperationNotAllowedErrorCode) {
            completion(ParseACLPermissionFalse, error);
        } else {
            completion(ParseACLPermissionUnknown, error);
        }
    }];
}

+ (void)checkDeletePermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    PFObject *object = [PFObject objectWithClassName:customClassName];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    completion(ParseACLPermissionTrue, nil);
                } else if (error.code == ParseOperationNotAllowedErrorCode) {
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
                        } else if (error.code == ParseOperationNotAllowedErrorCode) {
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

+ (void)checkAddFieldsPermissionForCustomClass:(NSString *)customClassName completionBlock:(ParsePermissionCheckBlock)completion {
    
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
                        } else if (error.code == ParseOperationNotAllowedErrorCode) {
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

#pragma mark - Private Methods

+ (void)firstObjectInQueryForCustomClassName:(NSString *)customClassName completionBlock:(ParseFirstObjectBlock)completion {
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
