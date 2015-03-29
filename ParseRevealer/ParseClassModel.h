//
//  ParseClassModel.h
//  ParseRevealer
//
//  Model for a Parse Custom Class.
//
//  Created by Egor Tolstoy on 16.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ParseClassModel : NSObject

/**
 *  Factory method, which returns a preconfigured ParseClassModel object
 *
 *  @param className The name of Parse Custom Class
 *
 *  @return Preconfigured ParseClassModel object
 */
+ (instancetype)objectWithClassName:(NSString *)className;

/**
 *  Method for updating the specific ACL permission of the current ParseClassModelObject. Please note that we initialize the object with predefined set of permissions, all of which are set to Undefined.
 *
 *  @param permissionKey  The name of current permission (see the full list of them in Constants.h)
 *  @param permissionCode The value of current permission (True/False/Unknown)
 */
- (void)updatePermission:(NSString *)permissionKey withValue:(ParseACLPermissionCode)permissionCode;

- (void)updateStructureWithFieldName:(NSString *)fieldName fieldType:(NSString *)fieldType;

- (void)updateClassStructure:(NSArray *)classStructure;

- (NSArray *)allFields;

/**
 *  The name of Parse Custom Class
 */
@property (strong, nonatomic, readonly) NSString *className;

/**
 *  The structure of Parse Custom Class
 */
@property (strong, nonatomic, readonly) NSArray *classStructure;

/**
 *  The list of access permissions (GET/FIND/etc) of Parse Custom Class
 */
@property (strong, nonatomic, readonly) NSDictionary *permissions;

@end
