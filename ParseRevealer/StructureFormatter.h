//
//  StructureFormatter.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 30.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StructureFormatter : NSObject

/**
 *  Method generates a proper output string for multiple classes structure
 *
 *  @param customClasses NSArray of ParseClassModels
 *
 *  @return Output string
 */
+ (NSString *)stringFromCustomClasses:(NSArray *)customClasses;

@end
