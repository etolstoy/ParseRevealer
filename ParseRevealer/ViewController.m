//
//  ViewController.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 06.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ViewController.h"
#import "ParseRevealService.h"
#import "ACLFormatter.h"
#import "ParseClassModel.h"
#import "ClassStorageService.h"

@interface ViewController()

@property (strong, nonatomic) ParseRevealService *parseRevealService;
@property (strong, nonatomic) ClassStorageService *classStorageService;

@property (weak) IBOutlet NSTextField *applicationIdTextField;
@property (weak) IBOutlet NSTextField *clientKeyTextField;

@property (unsafe_unretained) IBOutlet NSTextView *customClassesTextView;
@property (unsafe_unretained) IBOutlet NSTextView *aclTextView;

@property (weak) IBOutlet NSButton *connectButton;
@property (weak) IBOutlet NSButton *revealButton;

@property (weak) IBOutlet NSProgressIndicator *connectActivityIndicator;
@property (weak) IBOutlet NSProgressIndicator *revealActivityIndicator;

@end

@implementation ViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.parseRevealService = [ParseRevealService new];
    self.classStorageService = [ClassStorageService new];
    [self enableCustomClassesInterfaceArea:NO];
}

#pragma mark - IBActions

- (IBAction)testConnectionButtonClicked:(id)sender {
    [self.connectActivityIndicator startAnimation:self];
    [self enableAccountInterfaceArea:NO];
    [self enableCustomClassesInterfaceArea:NO];
    
    [self.parseRevealService checkParseForApplicationId:self.applicationIdTextField.stringValue
                                              clientKey:self.clientKeyTextField.stringValue
                                        completionBlock:^(NSError *error) {
                                            [self.connectActivityIndicator stopAnimation:self];
                                            [self enableAccountInterfaceArea:YES];
                                            
                                            if (!error) {
                                                [self enableCustomClassesInterfaceArea:YES];
                                            } else {
                                                [self enableCustomClassesInterfaceArea:NO];
                                            }
                                        }];
}

- (IBAction)revealButtonClicked:(id)sender {
    [self enableCustomClassesInterfaceArea:NO];
    [self.revealActivityIndicator startAnimation:self];
    
    [self revealParseClassesFromUserInput:self.customClassesTextView.string];
}

#pragma mark - Private Methods

- (void)enableAccountInterfaceArea:(BOOL)enabled {
    self.connectButton.enabled = enabled;
    self.applicationIdTextField.editable = enabled;
    self.clientKeyTextField.editable = enabled;
}

- (void)enableCustomClassesInterfaceArea:(BOOL)enabled {
    self.revealButton.enabled = enabled;
    self.customClassesTextView.editable = enabled;
    self.customClassesTextView.selectable = enabled;
}

- (void)revealParseClassesFromUserInput:(NSString *)userInput {
    NSArray *customClassesNamesArray = [userInput componentsSeparatedByString:@"\n"];
    [self filterAndStoreClassesWithNames:customClassesNamesArray];
    
    [self.parseRevealService getAclForCustomClasses:self.classStorageService.parseClasses completionBlock:^(NSArray *customClasses, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.aclTextView setString:[ACLFormatter stringFromCustomClassesACLs:customClasses]];
            
            [self enableCustomClassesInterfaceArea:YES];
            [self.revealActivityIndicator stopAnimation:self];
        });
    }];
}

- (void)filterAndStoreClassesWithNames:(NSArray *)classNames {
    NSSet *filteredCustomClasses = [self filterCustomClassesArray:classNames];
    for (NSString *className in filteredCustomClasses) {
        [self.classStorageService addClassWithName:className shouldReplaceExistingClass:NO];
    }
}

- (NSSet *)filterCustomClassesArray:(NSArray *)customClassesArray {
    NSArray *prohibitedClassNames = @[
                                      @"User",
                                      @"Installation",
                                      @"_User",
                                      @"_Installation"
                                      ];
    
    NSMutableSet *customClassesSet = [NSMutableSet setWithArray:customClassesArray];
    
    for (NSString *prohibitedClassName in prohibitedClassNames) {
        [customClassesSet removeObject:prohibitedClassName];
    }
    
    return customClassesSet;
}

@end
