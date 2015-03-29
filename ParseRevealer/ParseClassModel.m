//
//  ParseClassModel.m
//  ParseRevealer
//
//  Model for a Parse Custom Class.
//
//  Created by Egor Tolstoy on 16.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ParseClassModel.h"

static NSString *const ParseClassStructureFieldNameKey = @"fieldName";
static NSString *const ParseClassStructureFieldTypeKey = @"fieldType";

@interface ParseClassModel()

@property (strong, nonatomic, readwrite) NSString *className;
@property (strong, nonatomic, readwrite) NSArray *classStructure;
@property (strong, nonatomic, readwrite) NSDictionary *permissions;

@end

@implementation ParseClassModel

#pragma mark - Initialization

- (instancetype)initWithClassName:(NSString *)className {
    if (self = [super init]) {
        self.className = className;
        
        self.classStructure = @[];
        self.permissions = [self defaultPermissionDictionary];
    }
    return self;
}

+ (instancetype)objectWithClassName:(NSString *)className {
    return [[[self class] alloc] initWithClassName:className];
}

#pragma mark - Public Methods

- (NSArray *)allFields {
    NSMutableArray *mutableFields = [@[] mutableCopy];
    for (NSDictionary *fieldDictionary in self.classStructure) {
        [mutableFields addObject:fieldDictionary[ParseClassStructureFieldNameKey]];
    }
    return [mutableFields copy];
}

- (void)updatePermission:(NSString *)permissionKey withValue:(ParseACLPermissionCode)permissionCode {
    NSMutableDictionary *mutablePermissions = [self.permissions mutableCopy];
    if ([[mutablePermissions allKeys] containsObject:permissionKey]) {
        [mutablePermissions setObject:@(permissionCode) forKey:permissionKey];
    }
    self.permissions = [mutablePermissions copy];
}

- (void)updateStructureWithFieldName:(NSString *)fieldName fieldType:(NSString *)fieldType {
    NSDictionary *fieldDictionary = @{
                                      ParseClassStructureFieldNameKey : fieldName,
                                      ParseClassStructureFieldTypeKey : fieldType
                                      };
    self.classStructure = [self.classStructure arrayByAddingObject:fieldDictionary];
}

- (void)updateClassStructure:(NSArray *)classStructure {
    self.classStructure = classStructure;
}

#pragma mark - Private Methods

- (NSDictionary *)defaultPermissionDictionary {
    return @{
             ParseGetPermissionKey : @(ParseACLPermissionUnknown),
             ParseFindPermissionKey : @(ParseACLPermissionUnknown),
             ParseUpdatePermissionKey : @(ParseACLPermissionUnknown),
             ParseCreatePermissionKey : @(ParseACLPermissionUnknown),
             ParseDeletePermissionKey : @(ParseACLPermissionUnknown),
             ParseAddFieldsPermissionKey : @(ParseACLPermissionUnknown)
             };
}

@end
