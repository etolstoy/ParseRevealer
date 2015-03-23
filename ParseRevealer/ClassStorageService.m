//
//  ClassStorageService.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 18.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ClassStorageService.h"
#import "ParseClassModel.h"

@interface ClassStorageService()

@property (strong, nonatomic, readwrite) NSSet *parseClasses;

@end

@implementation ClassStorageService

#pragma mark - Initialization

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static id sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.parseClasses = [NSSet new];
    }
    return self;
}

#pragma mark - Public Methods

- (void)addClassWithName:(NSString *)className shouldReplaceExistingClass:(BOOL)shouldReplaceExistingClass {
    BOOL classExists = [self checkExistanceOfClassWithName:className];
    
    if (shouldReplaceExistingClass || (!shouldReplaceExistingClass && !classExists)) {
        ParseClassModel *classModel = [ParseClassModel objectWithClassName:className];
        NSSet *parseClasses = [self.parseClasses setByAddingObject:classModel];
        self.parseClasses = parseClasses;
    }
}

#pragma mark - Private Methods

- (BOOL)checkExistanceOfClassWithName:(NSString *)className {
    for (ParseClassModel *classModel in self.parseClasses) {
        if ([classModel.className isEqualToString:className]) {
            return YES;
        }
    }
    return NO;
}

@end