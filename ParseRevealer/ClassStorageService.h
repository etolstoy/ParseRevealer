//
//  ClassStorageService.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 18.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassStorageService : NSObject

/**
 *  This method adds a new Parse Custom Class to the storage.
 *
 *  @param className                  The name of Parse Custom Class
 *  @param shouldReplaceExistingClass The flag indicating if the existing class should be replaced by the new one
 */
- (void)addClassWithName:(NSString *)className shouldReplaceExistingClass:(BOOL)shouldReplaceExistingClass;

/**
 *  The array of all Parse Custom Classes stored in the service
 */
@property (strong, nonatomic, readonly) NSSet *parseClasses;

@end
