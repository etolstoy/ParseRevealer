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
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            
        }
    }];
}


@end
