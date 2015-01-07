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

@interface ViewController()

@property (strong, nonatomic) ParseRevealService *parseRevealService;

@property (weak) IBOutlet NSTextField *applicationIdTextField;
@property (weak) IBOutlet NSTextField *clientKeyTextField;
@property (unsafe_unretained) IBOutlet NSTextView *customClassesTextView;
@property (unsafe_unretained) IBOutlet NSTextView *aclTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.parseRevealService = [ParseRevealService new];
}

- (IBAction)testConnectionButtonClicked:(id)sender {
    [self.parseRevealService checkParseForApplicationId:self.applicationIdTextField.stringValue
                                              clientKey:self.clientKeyTextField.stringValue
                                        completionBlock:^(NSError *error) {
                                            if (!error) {
                                                NSLog(@"success!");
                                            } else {
                                                NSLog(@"error");
                                            }
                                        }];
}

- (IBAction)revealButtonClicked:(id)sender {
    NSArray *customClassesArray = [self.customClassesTextView.string componentsSeparatedByString:@"\n"];
    
    [self.parseRevealService getAclForCustomClasses:customClassesArray completionBlock:^(NSDictionary *customClassesACLs, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.aclTextView setString:[ACLFormatter stringFromCustomClassesACLs:customClassesACLs]];
        });
    }];
}

@end
