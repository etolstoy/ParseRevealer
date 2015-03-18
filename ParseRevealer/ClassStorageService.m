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

@property (strong, nonatomic, readwrite) NSArray *parseClasses;

@end

@implementation ClassStorageService

#pragma mark - Public Methods

- (void)addClassWithName:(NSString *)className shouldReplaceExistingClass:(BOOL)shouldReplaceExistingClass {
    BOOL classExists = [self checkExistanceOfClassWithName:className];
    
    if (shouldReplaceExistingClass || (!shouldReplaceExistingClass && !classExists)) {
        ParseClassModel *classModel = [ParseClassModel objectWithClassName:className];
        NSArray *parseClasses = [self.parseClasses arrayByAddingObject:classModel];
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
