//
//  ExportFormatter.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 01.04.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExportFormatter : NSObject

/**
 *  Method generates a proper output string for multiple classes
 *
 *  @param customClasses NSArray of ParseClassModels
 *  @param applicationId Current applicationId
 *  @param clientKey     Current clientKey
 *
 *  @return Output string
 */
+ (NSString *)stringFromCustomClasses:(NSArray *)customClasses applicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;

@end
