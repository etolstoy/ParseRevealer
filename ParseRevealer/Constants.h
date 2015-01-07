//
//  Constants.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 07.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ParseACLPermissionCode) {
    ParseACLPermissionFalse = 0,
    ParseACLPermissionTrue = 1,
    ParseACLPermissionUnknown = 2
};

extern NSString *const ParseGetPermissionKey;
extern NSString *const ParseFindPermissionKey;
extern NSString *const ParseUpdatePermissionKey;
extern NSString *const ParseCreatePermissionKey;
extern NSString *const ParseDeletePermissionKey;
extern NSString *const ParseAddFieldsPermissionKey;