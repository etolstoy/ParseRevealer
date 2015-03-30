//
//  StructureRevealingVIewController.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 23.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "StructureRevealingViewController.h"
#import "StructureRevealService.h"
#import "ClassStorageService.h"
#import "ParseClassModel.h"
#import "StructureFormatter.h"

@interface StructureRevealingViewController ()

@property (weak) IBOutlet NSButton *revealButton;
@property (weak) IBOutlet NSProgressIndicator *activityIndicator;
@property (unsafe_unretained) IBOutlet NSTextView *classNamesTextView;

@property (strong, nonatomic) StructureRevealService *structureRevealService;
@property (strong, nonatomic) ClassStorageService *classStorageService;

@end

@implementation StructureRevealingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.structureRevealService = [[StructureRevealService alloc] init];
    self.classStorageService = [ClassStorageService sharedInstance];
}

- (void)viewWillAppear {
    if (self.classStorageService.parseClasses.count > 0) {
        self.revealButton.enabled = YES;
        self.classNamesTextView.string = @"";
        if (self.classStorageService.structuredParseClasses.count == 0) {
            self.revealButton.enabled = NO;
            self.classNamesTextView.string = @"It seems that either you haven't revealed the permissions of your classes, or none of them has the turned on FIND permission. Go to the previous tab and check it.";
        }
    } else {
        self.revealButton.enabled = NO;
        self.classNamesTextView.string = @"It seems that you haven't added any of the Parse Custom Classes on the Basic Setup tab. Add them, press 'Save' and then proceed to the current tab.";
    }
    
    
}

- (IBAction)revealButtonTapped:(id)sender {
    NSArray *parseClassesArray = [self.classStorageService.parseClasses allObjects];
    [self.structureRevealService startRevealingStructureForCustomClasses:parseClassesArray updateBlock:^(ParseClassModel *model, NSError *error) {
        [self.classStorageService updateClass:model];
        
        NSString *structureString = [StructureFormatter stringFromCustomClasses:self.classStorageService.parseClasses.allObjects];
        self.classNamesTextView.string = structureString;
    }];
}

@end
