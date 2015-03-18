//
//  ClassStorageService.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 18.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassStorageService : NSObject

- (void)addClassWithName:(NSString *)className shouldReplaceExistingClass:(BOOL)shouldReplaceExistingClass;

@property (strong, nonatomic, readonly) NSArray *parseClasses;

@end
