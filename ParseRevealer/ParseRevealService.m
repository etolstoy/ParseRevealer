//
//  ParseRevealService.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 06.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ParseRevealService.h"

#import <ParseOSX/ParseOSX.h>

@implementation ParseRevealService

- (void)checkParseForApplicationId:(NSString *)applicationId
                         clientKey:(NSString *)clientKey
                   completionBlock:(ParseAccountCheckBlock)completion
{
    [Parse setApplicationId:applicationId clientKey:clientKey];
    
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completion(error);
    }];
}

@end
