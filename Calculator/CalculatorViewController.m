//  Controller for calculator view.
//
//  Created by Eric Rushing on 6/30/12.
//  Copyright (c) 2012 Septen. All rights reserved.


#import "CalculatorViewController.h"
#import "CalculatorBrain.h"


@interface CalculatorViewController()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;

@end


@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize variables = _variables;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

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
  self.testVariableValues = nil;
}

- (IBAction)variablePressed:(UIButton *)sender {
  [self.brain pushVariable:[sender currentTitle]];
  self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)backPressed {
  if (self.userIsInTheMiddleOfEnteringNumber) {
    NSString *displayText = self.display.text;
    displayText = [displayText substringToIndex: displayText.length - 1];
    if (displayText.length == 0) {
      self.userIsInTheMiddleOfEnteringNumber = NO;
		
      double result = [CalculatorBrain runProgram:self.brain.program
                              usingVariableValues:self.testVariableValues];
      displayText = [NSString stringWithFormat:@"%g", result];
      
      self.display.text = displayText;
    }
  } else {
    [self.brain removeLastOperation];
    double result = [CalculatorBrain runProgram:self.brain.program
                            usingVariableValues:self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.history.text = [CalculatorBrain descriptionOfProgram:
                         self.brain.program];
    [self updateVariablesDisplay];
  }
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
	[self.brain pushOperand:[self.display.text doubleValue]];
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
    [self.brain pushOperation:@"switch_sign"];
    double result = [CalculatorBrain runProgram:self.brain.program
                            usingVariableValues:self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.history.text = [CalculatorBrain descriptionOfProgram:
                         self.brain.program];
	}
}

- (IBAction)operationPressed:(id)sender {
	if (self.userIsInTheMiddleOfEnteringNumber) {
		[self enterPressed];
	}
  
	NSString *operation = [sender currentTitle];
  [self.brain pushOperation:operation];
  double result = [CalculatorBrain runProgram:self.brain.program
                          usingVariableValues:self.testVariableValues];
  
  self.display.text = [NSString stringWithFormat: @"%g", result];
  self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
  [self updateVariablesDisplay];
}

- (IBAction)testVariablesPressed:(UIButton *)sender {
  NSArray *keys = [NSArray arrayWithObjects:@"x", @"y", @"z", nil];
  
  if ([@"Test 1" isEqualToString:[sender currentTitle]]) {
    NSArray *vals = [NSArray arrayWithObjects:
                     [NSNumber numberWithInt:0],
                     [NSNumber numberWithInt:0],
                     [NSNumber numberWithInt:0],
                     nil];
    self.testVariableValues = [NSDictionary dictionaryWithObjects:
                               vals forKeys:keys];
  } else if ([@"Test 2" isEqualToString:[sender currentTitle]]) {
    NSArray *vals = [NSArray arrayWithObjects:
                     [NSNumber numberWithDouble:1.23],
                     [NSNumber numberWithDouble:4.56],
                     [NSNumber numberWithDouble:7.89],
                     nil];
    self.testVariableValues = [NSDictionary dictionaryWithObjects:
                               vals forKeys:keys];
  } else {
    self.testVariableValues = nil;
  }
  
  double result = [CalculatorBrain runProgram:self.brain.program
                          usingVariableValues:self.testVariableValues];
  self.display.text = [NSString stringWithFormat:@"%g", result];
  [self updateVariablesDisplay];
}

- (void)updateVariablesDisplay {
  NSSet *variablesUsedInProgram = [CalculatorBrain variablesUsedInProgram:
                                   self.brain.program];
  NSString *output = [NSString stringWithString:@""];
  NSNumber *val;
  for (NSString *var in variablesUsedInProgram) {
    val = [self.testVariableValues objectForKey:var];
    output = [output stringByAppendingFormat:@"%@ = %g ", var, [val doubleValue]];
  }
  
  self.variables.text = output;
}

- (void)viewDidUnload {
	[self setHistory:nil];
  [self setDisplay:nil];
  [self setVariables:nil];
	[super viewDidUnload];
}
@end
