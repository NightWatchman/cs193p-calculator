//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Eric Rushing on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"


@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *operandStack;

@end


@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

-(NSMutableArray *)operandStack {
	if (!_operandStack)
		_operandStack = [[NSMutableArray alloc] init];
	
	return _operandStack;
}


-(double)popOperand {
	NSNumber *operandObject = [self.operandStack lastObject];
	if (operandObject) [self.operandStack removeLastObject];
	return [operandObject doubleValue];
}

-(void)pushOperand:(double)operand {
	NSNumber *operandObject = [NSNumber numberWithDouble: operand];
	[self.operandStack addObject: operandObject];
}

-(double)performOperation:(NSString *)operation {
	double result = 0;
	
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
	
	[self pushOperand: result];
	
	return result;
}

-(void)clear {
	[self.operandStack removeAllObjects];
}

@end
