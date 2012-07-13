//  Controller for calculator view.
//
//  Created by Eric Rushing on 6/30/12.
//  Copyright (c) 2012 Septen. All rights reserved.


#import "CalculatorViewController.h"
#import "CalculatorBrain.h"


@interface CalculatorViewController()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;

@end


@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;

// Getter for brain (Calculator model)
- (CalculatorBrain *)brain {
	if (!_brain) _brain = [[CalculatorBrain alloc] init];
	
	return _brain;
}

// Executed when clear button is pressed.
// Resets calculator to zeroed out, initial defaults
- (IBAction)clearPressed {
	[self.brain clear];
	self.display.text = @"0";
	self.history.text = @"";
	self.userIsInTheMiddleOfEnteringNumber = NO;
}

- (IBAction)backPressed {
  NSString *displayText = self.display.text;
	displayText = [displayText substringToIndex: displayText.length - 1];
	if (displayText.length == 0) {
		displayText = @"0";
		self.userIsInTheMiddleOfEnteringNumber = NO;
	}
	
	self.display.text = displayText;
}

- (IBAction)digitPressed:(UIButton *)sender {
	NSString *digit = [sender currentTitle];
	
	if ([digit isEqualToString: @"."] &&
			[self.display.text rangeOfString: @"."].location != NSNotFound)
		digit = @"";
	
	if (self.userIsInTheMiddleOfEnteringNumber) {
		self.display.text = [self.display.text stringByAppendingString: digit];
	} else {
		self.display.text = digit;
		self.userIsInTheMiddleOfEnteringNumber = YES;
	}
}

- (IBAction)enterPressed {
	double pushing = [self.display.text doubleValue];
//	self.history.text = [self.history.text stringByAppendingFormat:@"%g ", pushing];
	[self.brain pushOperand: pushing];
  self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
	self.userIsInTheMiddleOfEnteringNumber = NO;
}

- (IBAction)plusMinusPressed {
	if (self.userIsInTheMiddleOfEnteringNumber) {
		if ([self.display.text characterAtIndex:0] == '-')
			self.display.text = [self.display.text substringFromIndex:1];
		else
			self.display.text = [@"-" stringByAppendingString:self.display.text];
	} else {
//    self.history.text = [self.history.text stringByAppendingFormat:@"%@ = ", @"±"];
    self.history.text =
            [CalculatorBrain descriptionOfProgram:self.brain.program];
    
		double result = [self.brain performOperation:@"switch_sign"];
		self.display.text = [NSString stringWithFormat:@"%g", result];
	}
}

- (IBAction)operationPressed:(id)sender {
	if (self.userIsInTheMiddleOfEnteringNumber) {
		[self enterPressed];
	}
  
	NSString *operation = [sender currentTitle];
//	self.history.text = [self.history.text stringByAppendingFormat: @"%@ = ", operation];
	double result = [self.brain performOperation:operation];
  
  self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
  
	self.display.text = [NSString stringWithFormat: @"%g", result];
}

- (void)viewDidUnload {
	[self setHistory:nil];
  [self setDisplay:nil];
	[super viewDidUnload];
}
@end
