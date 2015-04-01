//
//  StructureRevealService.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 29.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  ParseClassModel;

typedef void (^ParseStructureUpdateBlock)(ParseClassModel *model, NSError *error);
typedef void (^ParseStructureCompletionBlock)(NSError *error);

@interface StructureRevealService : NSObject

- (void)startRevealingStructureForCustomClasses:(NSArray *)customClassesArray updateBlock:(ParseStructureUpdateBlock)updateBlock completionBlock:(ParseStructureCompletionBlock)completionBlock;

@end
