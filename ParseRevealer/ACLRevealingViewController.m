//
//  ACLRevealingViewController.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 23.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ACLRevealingViewController.h"
#import "ParseRevealService.h"
#import "ACLFormatter.h"
#import "ParseClassModel.h"
#import "ClassStorageService.h"

@interface ACLRevealingViewController ()

@property (strong, nonatomic) ParseRevealService *parseRevealService;
@property (strong, nonatomic) ClassStorageService *classStorageService;

@property (unsafe_unretained) IBOutlet NSTextView *aclTextView;
@property (weak) IBOutlet NSButton *revealButton;
@property (weak) IBOutlet NSProgressIndicator *revealActivityIndicator;

@end

@implementation ACLRevealingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.parseRevealService = [ParseRevealService new];
}

- (IBAction)revealButtonClicked:(id)sender {
    [self.revealActivityIndicator startAnimation:self];
//    [self revealParseClassesFromUserInput:self.customClassesTextView.string];
}

- (void)revealParseClassesFromUserInput:(NSString *)userInput {
//    NSArray *customClassesNamesArray = [userInput componentsSeparatedByString:@"\n"];
//    [self filterAndStoreClassesWithNames:customClassesNamesArray];
    
//    [self.parseRevealService getAclForCustomClasses:self.classStorageService.parseClasses completionBlock:^(NSArray *customClasses, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            [self.aclTextView setString:[ACLFormatter stringFromCustomClassesACLs:customClasses]];
//            
//            [self enableCustomClassesInterfaceArea:YES];
//            [self.revealActivityIndicator stopAnimation:self];
//        });
//    }];
}


@end
