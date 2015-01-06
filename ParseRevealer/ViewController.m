//
//  ViewController.m
//  ParseRevealer
//
//  Created by Egor Tolstoy on 06.01.15.
//  Copyright (c) 2015 Egor Tolstoy. All rights reserved.
//

#import "ViewController.h"
#import "ParseRevealService.h"

@interface ViewController()

@property (strong, nonatomic) ParseRevealService *parseRevealService;

@property (weak) IBOutlet NSTextField *applicationIdTextField;
@property (weak) IBOutlet NSTextField *clientKeyTextField;

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


@end
