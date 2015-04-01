//
//  ExportFormatter.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 01.04.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ExportFormatter.h"
#import "ParseClassModel.h"
#import "ACLFormatter.h"

static NSString *const ParseClassStructureFieldNameKey = @"fieldName";
static NSString *const ParseClassStructureFieldTypeKey = @"fieldType";

@implementation ExportFormatter

+ (NSString *)stringFromCustomClasses:(NSArray *)customClasses applicationId:(NSString *)applicationId clientKey:(NSString *)clientKey {
    NSMutableString *outputString = [NSMutableString new];
    [outputString appendString:@"Parse Revealer v.0.2\n\n"];
    [outputString appendString:[NSString stringWithFormat:@"applicationId: %@\n", applicationId]];
    [outputString appendString:[NSString stringWithFormat:@"clientKey: %@\n\n", clientKey]];
    
    for (ParseClassModel *classModel in customClasses) {
        [outputString appendString:[NSString stringWithFormat:@"========== %@ ==========\n\n", classModel.className]];
        [outputString appendString:@"Class Access Permissions:\n"];
        NSString *permissionsString = [ACLFormatter stringFromACLDictionary:classModel.permissions];
        [outputString appendString:permissionsString];
        [outputString appendString:@"\n"];
        [outputString appendString:@"Class Structure:\n"];
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
