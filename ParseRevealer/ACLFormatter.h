//
//  ACLFormatter.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 07.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACLFormatter : NSObject

+ (NSString *)stringFromCustomClassesACLs:(NSDictionary *)customClassesACLs;
+ (NSString *)stringFromACLDictionary:(NSDictionary *)dictionary;

@end
