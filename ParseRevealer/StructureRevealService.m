//
//  StructureRevealService.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 29.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "StructureRevealService.h"
#import "ParseClassModel.h"

#import <ParseOSX/ParseOSX.h>

static NSInteger const ParsePagingLimit = 1000;

@implementation StructureRevealService

#pragma mark - Public Methods

- (void)startRevealingStructureForCustomClasses:(NSArray *)customClassesArray updateBlock:(ParseStructureUpdateBlock)updateBlock
{
    for (ParseClassModel *class in customClassesArray) {
        [self revealStructureForCustomClass:class withUpdateBlock:updateBlock];
    }
}

#pragma mark - Private Classes

- (void)revealStructureForCustomClass:(ParseClassModel *)class withUpdateBlock:(ParseStructureUpdateBlock)updateBlock
{
    PFQuery *query = [PFQuery queryWithClassName:class.className];
    [query orderByDescending:@"createdAt"];
    query.limit = ParsePagingLimit;
    __block NSInteger currentPagesNumber = 0;
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        while (number > currentPagesNumber) {
            NSArray *objects = [query findObjects];
            [self processObjects:objects forCustomClass:class withUpdateBlock:updateBlock];
            currentPagesNumber += ParsePagingLimit;
        }
    }];
}

- (void)processObjects:(NSArray *)objects forCustomClass:(ParseClassModel *)class withUpdateBlock:(ParseStructureUpdateBlock)updateBlock
{
    for (PFObject *object in objects) {
        NSArray *objectKeys = object.allKeys;
        for (NSString *fieldName in objectKeys) {
            if (![[class allFields] containsObject:fieldName]) {
                NSString *fieldType = NSStringFromClass([object[fieldName] class]);
                [class updateStructureWithFieldName:fieldName fieldType:fieldType];
                updateBlock(class, nil);
            }
        }
    }
}

@end
