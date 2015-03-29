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

@interface StructureRevealingViewController ()

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

- (IBAction)revealButtonTapped:(id)sender {
    NSArray *parseClassesArray = [self.classStorageService.parseClasses allObjects];
    [self.structureRevealService startRevealingStructureForCustomClasses:parseClassesArray updateBlock:^(ParseClassModel *model, NSError *error) {
        [self.classStorageService updateClass:model];
    }];
}

@end
