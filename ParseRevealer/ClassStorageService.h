//
//  ClassStorageService.h
//  ParseRevealer
//
//  Created by Egor Tolstoy on 18.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ParseClassModel;

@interface ClassStorageService : NSObject

/**
 *  This class is represented as a singleton as it should be accessed from different controllers and hold the same instances of Parse Custom Classes everywhere.
 *
 *  @return ClassStorageService
 */
+ (instancetype)sharedInstance;

/**
 *  This method saves inputted keys to the storage
 *
 *  @param applicationId  The ApplicationId key
 *  @param clientKey      The ClientKey
 */
- (void)setApplicationId:(NSString *)applicationId clientKey:(NSString *)clientKey;

/**
 *  This method adds a new Parse Custom Class to the storage.
 *
 *  @param className                  The name of Parse Custom Class
 *  @param shouldReplaceExistingClass The flag indicating if the existing class should be replaced by the new one
 */
- (void)addClassWithName:(NSString *)className shouldReplaceExistingClass:(BOOL)shouldReplaceExistingClass;

/**
 *  This method updates a specified Parse Custom Class.
 *
 *  @param parseClass                 The Parse Custom Class
 */
- (void)updateClass:(ParseClassModel *)parseClass;

/**
 *  This method removes a specified Parse Custom Class from the storage.
 *
 *  @param parseClass                 The Parse Custom Class
 */
- (void)removeClass:(ParseClassModel *)parseClass;

/**
 *  The array of all Parse Custom Classes stored in the service
 */
@property (strong, nonatomic, readonly) NSSet *parseClasses;
@property (strong, nonatomic, readonly) NSSet *structuredParseClasses;

@property (strong, nonatomic, readonly) NSString *applicationId;
@property (strong, nonatomic, readonly) NSString *clientKey;

@end
