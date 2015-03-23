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

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.parseRevealService = [ParseRevealService new];
    self.classStorageService = [ClassStorageService sharedInstance];
}

#pragma mark - IBActions

- (IBAction)revealButtonClicked:(id)sender {
    [self.revealActivityIndicator startAnimation:self];
    [self revealParseClasses:[self.classStorageService.parseClasses allObjects]];
}

#pragma mark - Private Methods

- (void)revealParseClasses:(NSArray *)parseClasses {
    [self.parseRevealService getAclForCustomClasses:parseClasses completionBlock:^(NSArray *customClasses, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.aclTextView setString:[ACLFormatter stringFromCustomClassesACLs:customClasses]];
            [self.revealActivityIndicator stopAnimation:self];
        });
    }];
}


@end
