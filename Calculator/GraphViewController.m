//
//  GraphViewControllerViewController.m
//  Calculator
//
//  Created by Eric Rushing on 7/23/12.
//  Copyright (c) 2012 Septen. All rights reserved.
//
#import "GraphViewController.h"
#import "CalculatorBrain.h"


@implementation GraphViewController

@synthesize description = description_;
@synthesize program = program_;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidLoad {
  self.description.text = [CalculatorBrain descriptionOfProgram: self.program];
}

- (void)viewDidUnload {
  description_ = nil;
}

@end
