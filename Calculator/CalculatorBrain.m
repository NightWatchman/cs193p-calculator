//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Eric Rushing on 6/30/12.
//  Copyright (c) 2012 Septentron Engineering. All rights reserved.
//

#import "CalculatorBrain.h"


@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *programStack;

@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;

-(NSMutableArray *)programStack {
	if (!_programStack)
		_programStack = [[NSMutableArray alloc] init];
	
	return _programStack;
}

-(id) program {
	return [self.programStack copy];
}

-(void)pushOperand:(double)operand {
	NSNumber *operandObject = [NSNumber numberWithDouble: operand];
	[self.programStack addObject: operandObject];
}

-(double)performOperation:(NSString *)operation {
	double result = 0;
	
	/*
	if ([operation isEqualToString:@"+"]) {
		result = [self popOperand] + [self popOperand];
	} else if ([@"*" isEqualToString:operation]) {
		result = [self popOperand] * [self popOperand];
	} else if ([operation isEqualToString:@"-"]) {
		double subtrahend = [self popOperand];
		result = [self popOperand] - subtrahend;
	} else if ([operation isEqualToString:@"/"]) {
		double divisor = [self popOperand];
		if (divisor != 0) result = [self popOperand] / divisor;
	} else if ([operation isEqualToString:@"sin"]) {
		result = sin([self popOperand]);
	} else if ([operation isEqualToString:@"cos"]) {
		result = cos([self popOperand]);
	} else if ([operation isEqualToString:@"sqrt"]) {
		result = sqrt([self popOperand]);
	} else if ([operation isEqualToString:@"pi"]) {
		result = 3.14159265;
	} else if ([operation isEqualToString:@"switch_sign"]) {
		result = -[self popOperand];
	}
	 */
	
	[self pushOperand: result];
	
	return result;
}

-(void)clear {
	[self.programStack removeAllObjects];
}

@end
