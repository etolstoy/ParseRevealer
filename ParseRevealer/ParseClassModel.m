//
//  ParseClassModel.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 16.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ParseClassModel.h"

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
    }
    return self;
}

+ (instancetype)objectWithClassName:(NSString *)className {
    return [[[self class] alloc] initWithClassName:className];
}

@end
