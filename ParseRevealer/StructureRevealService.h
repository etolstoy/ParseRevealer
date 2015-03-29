//
//  StructureRevealService.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 29.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  ParseClassModel;

typedef void (^ParseStructureUpdateBlock)(ParseClassModel *model, NSString *fieldName, NSString *fieldType, NSError *error);

@interface StructureRevealService : NSObject

- (void)startRevealingStructureForCustomClasses:(NSArray *)customClassesArray updateBlock:(ParseStructureUpdateBlock)updateBlock;

@end
