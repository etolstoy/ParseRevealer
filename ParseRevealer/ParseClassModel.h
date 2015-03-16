//
//  ParseClassModel.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 16.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ParseClassModel : NSObject

+ (instancetype)objectWithClassName:(NSString *)className;

@property (strong, nonatomic, readonly) NSString *className;
@property (strong, nonatomic, readonly) NSArray *classStructure;
@property (strong, nonatomic, readonly) NSDictionary *permissions;

@end
