//
//  StructureFormatter.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 30.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "StructureFormatter.h"
#import "ParseClassModel.h"

static NSString *const ParseClassStructureFieldNameKey = @"fieldName";
static NSString *const ParseClassStructureFieldTypeKey = @"fieldType";

@implementation StructureFormatter

+ (NSString *)stringFromCustomClasses:(NSArray *)customClasses {
    NSMutableString *outputString = [NSMutableString new];
    
    for (ParseClassModel *classModel in customClasses) {
        [outputString appendString:[NSString stringWithFormat:@"%@:\n", classModel.className]];
        NSArray *structure = classModel.classStructure;
        for (NSDictionary *fieldDictionary in structure) {
            NSString *fieldInfo = [NSString stringWithFormat:@"%@ : %@\n", fieldDictionary[ParseClassStructureFieldNameKey], fieldDictionary[ParseClassStructureFieldTypeKey]];
            [outputString appendString:fieldInfo];
        }
        [outputString appendString:@"\n"];
    }
    
    return outputString;
}

@end
