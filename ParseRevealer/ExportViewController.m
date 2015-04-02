//
//  ExportViewController.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 31.03.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ExportViewController.h"
#import "ClassStorageService.h"
#import "ExportFormatter.h"

@interface ExportViewController ()

@property (weak) IBOutlet NSButton *exportButton;
@property (strong, nonatomic) ClassStorageService *classStorageService;

@end

@implementation ExportViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.classStorageService = [ClassStorageService sharedInstance];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    if (self.classStorageService.parseClasses.count > 0) {
        self.exportButton.enabled = YES;
    } else {
        self.exportButton.enabled = NO;
    }
}

#pragma mark - IBActions

- (IBAction)exportButtonClicked:(id)sender {
    NSString *exportString = [self exportString];
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.nameFieldStringValue = @"parse-revealer-export.txt";
    [savePanel setAllowedFileTypes:@[@"txt"]];
    [savePanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            [savePanel orderOut:self];

            [exportString writeToFile:[savePanel.URL path] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

#pragma mark - Private Methods

- (NSString *)exportString {
    NSString *outputString = [ExportFormatter stringFromCustomClasses:self.classStorageService.parseClasses.allObjects applicationId:self.classStorageService.applicationId clientKey:self.classStorageService.clientKey];
    return outputString;
}

@end
