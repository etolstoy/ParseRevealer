//
//  ACLFormatter.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 07.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACLFormatter : NSObject

/**
 *  Method generates a proper output string for multiple classes' ACLs
 *
 *  @param customClassesACLs NSDictionary with format {CustomClassName : CustomClassACLDictionary}
 *
 *  @return Output string
 */
+ (NSString *)stringFromCustomClassesACLs:(NSDictionary *)customClassesACLs;

/**
 *  Method generates a proper output string for single ACL
 *
 *  @param dictionary NSDictionary with ACL
 *
 *  @return Output string
 */
+ (NSString *)stringFromACLDictionary:(NSDictionary *)dictionary;

@end
