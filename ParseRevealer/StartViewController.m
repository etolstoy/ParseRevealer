//
//  ViewController.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 06.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "StartViewController.h"
#import "ParseRevealService.h"
#import "ACLFormatter.h"
#import "ParseClassModel.h"
#import "ClassStorageService.h"

@interface StartViewController()

@property (strong, nonatomic) ClassStorageService *classStorageService;

@property (strong, nonatomic) ParseRevealService *parseRevealService;

@property (weak) IBOutlet NSTextField *applicationIdTextField;
@property (weak) IBOutlet NSTextField *clientKeyTextField;
@property (unsafe_unretained) IBOutlet NSTextView *customClassesTextView;
@property (weak) IBOutlet NSButton *connectButton;
@property (weak) IBOutlet NSProgressIndicator *connectActivityIndicator;

@end

@implementation StartViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.parseRevealService = [ParseRevealService new];
    self.classStorageService = [ClassStorageService sharedInstance];
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

- (IBAction)saveButtonClicked:(id)sender {
    [self saveParseClassesFromUserInput:self.customClassesTextView.string];
}

#pragma mark - Private Methods

- (void)enableAccountInterfaceArea:(BOOL)enabled {
    self.connectButton.enabled = enabled;
    self.applicationIdTextField.editable = enabled;
    self.clientKeyTextField.editable = enabled;
}

- (void)enableCustomClassesInterfaceArea:(BOOL)enabled {
    self.customClassesTextView.editable = enabled;
    self.customClassesTextView.selectable = enabled;
}

- (void)saveParseClassesFromUserInput:(NSString *)userInput {
    NSArray *customClassesNamesArray = [userInput componentsSeparatedByString:@"\n"];
    [self filterAndStoreClassesWithNames:customClassesNamesArray];

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
