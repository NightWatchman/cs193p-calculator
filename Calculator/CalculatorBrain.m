//  RPN Calculator model implementation
//
//  Created by Eric Rushing on 6/30/12.
//  Copyright (c) 2012 Septentron Engineering. All rights reserved.
//

#import "CalculatorBrain.h"


@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *programStack;

+ (double)popOperationOffProgramStack:(NSMutableArray *)stack;

@end


@implementation CalculatorBrain

@synthesize programStack = programStack_;

+ (NSString *)descriptionOfProgram:(id)program {
  return @"Implement this in Homework #2";
}

+ (double)popOperationOffProgramStack:(NSMutableArray *)stack {
	double result = 0;
	
	id topOfStack = [stack lastObject];
	if (topOfStack) [stack removeLastObject];
	
	if ([topOfStack isKindOfClass: [NSNumber class]]) {
		result = [topOfStack doubleValue];
	} else if ([topOfStack isKindOfClass: [NSString class]]) {
		NSString *operation = topOfStack;
		
		if ([operation isEqualToString:@"+"]) {
			result = [self popOperationOffProgramStack: stack] + [self popOperationOffProgramStack: stack];
		} else if ([@"*" isEqualToString:operation]) {
			result = [self popOperationOffProgramStack: stack] * [self popOperationOffProgramStack: stack];
		} else if ([operation isEqualToString:@"-"]) {
			double subtrahend = [self popOperationOffProgramStack: stack];
			result = [self popOperationOffProgramStack: stack] - subtrahend;
		} else if ([operation isEqualToString:@"/"]) {
			double divisor = [self popOperationOffProgramStack: stack];
			if (divisor != 0) result = [self popOperationOffProgramStack: stack] / divisor;
		} else if ([operation isEqualToString:@"sin"]) {
			result = sin([self popOperationOffProgramStack: stack]);
		} else if ([operation isEqualToString:@"cos"]) {
			result = cos([self popOperationOffProgramStack: stack]);
		} else if ([operation isEqualToString:@"sqrt"]) {
			result = sqrt([self popOperationOffProgramStack: stack]);
		} else if ([operation isEqualToString:@"pi"]) {
			result = 3.14159265;
		} else if ([operation isEqualToString:@"switch_sign"]) {
			result = -[self popOperationOffProgramStack: stack];
		}
	}
	
	return result;
}

+ (double)runProgram:(id)program {
	NSMutableArray *stack;
	if ([program isKindOfClass: [NSArray class]]) {
		stack = [program mutableCopy];
	}
	
	return [self popOperationOffProgramStack: stack];
}

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues {
  NSMutableArray *stack;
  if ([program isKindOfClass: [NSArray class]]) stack = [program mutableCopy];
  
  id programValue;
  id variableValue;
  for (NSUInteger i = 0; i < [stack count]; i++) {
    programValue = [stack objectAtIndex:i];
    variableValue = [variableValues objectForKey:programValue];
    
    // replaces with nil if variable not defined in variableValues
    [stack replaceObjectAtIndex:i withObject:variableValue];
  }
  
  return [self runProgram:[stack copy]];
}                                                      

- (NSMutableArray *)programStack {
	if (!programStack_)
		programStack_ = [[NSMutableArray alloc] init];
	
	return programStack_;
}

- (id) program {
	return [self.programStack copy];
}

- (void)pushOperand:(double)operand {
	NSNumber *operandObject = [NSNumber numberWithDouble: operand];
	[self.programStack addObject: operandObject];
}

- (void)pushVariable:(NSString *)variable {
	// attempts to push variables with the same names as operations are
	// not protected against
	[self.programStack addObject: variable];
}

- (double)performOperation:(NSString *)operation {
	[self.programStack addObject:operation];
	return [[self class] runProgram: self.programStack];
}

- (void)clear {
	[self.programStack removeAllObjects];
}

@end
