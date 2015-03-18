//
//  ACLFormatter.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 07.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ACLFormatter.h"
#import "Constants.h"
#import "ParseClassModel.h"

static NSString *const ACLPermissionTrue = @"True";
static NSString *const ACLPermissionFalse = @"False";
static NSString *const ACLPermissionUnknown = @"Unknown";

@implementation ACLFormatter

#pragma mark - Public Methods

+ (NSString *)stringFromACLDictionary:(NSDictionary *)dictionary {
    NSMutableString *outputString = [NSMutableString new];
    
    for (NSString *key in [dictionary allKeys]) {
        NSInteger permissionCode = [[dictionary objectForKey:key] integerValue];
        [outputString appendString:[NSString stringWithFormat:@"%@: %@\n", key, [self permissionNameForPermissionCode:permissionCode]]];
    }
    
    return outputString;
}

+ (NSString *)stringFromCustomClassesACLs:(NSArray *)customClasses {
    NSMutableString *outputString = [NSMutableString new];
    
    for (ParseClassModel *classModel in customClasses) {
        NSDictionary *aclDictionary = classModel.permissions;
        [outputString appendString:[NSString stringWithFormat:@"%@ ACL:\n%@\n", classModel.className, [self stringFromACLDictionary:aclDictionary]]];
    }
    
    return outputString;
}

#pragma mark - Private Methods

+ (NSString *)permissionNameForPermissionCode:(NSInteger)permissionCode {
    switch (permissionCode) {
        case ParseACLPermissionTrue:
            return ACLPermissionTrue;
        
        case ParseACLPermissionFalse:
            return ACLPermissionFalse;
            
        case ParseACLPermissionUnknown:
            return ACLPermissionUnknown;
            
        default:
            return ACLPermissionUnknown;
    }
}

@end
