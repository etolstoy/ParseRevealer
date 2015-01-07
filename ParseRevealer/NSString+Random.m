//
//  NSString+Random.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 07.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "NSString+Random.h"

@implementation NSString (Random)

+ (NSString *)randomString {
    NSInteger const kStringCapacity = 10;
    NSString *const kLetters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

    NSMutableString *randomString = [NSMutableString stringWithCapacity:kStringCapacity];
    
    for (NSInteger i = 0; i < kStringCapacity; i++) {
        [randomString appendFormat: @"%C", [kLetters characterAtIndex:arc4random_uniform([kLetters length])]];
    }
    
    return randomString;
}

@end
