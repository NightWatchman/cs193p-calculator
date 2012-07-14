//  RPN Calculator model implementation
//
//  Created by Eric Rushing on 6/30/12.
//  Copyright (c) 2012 Septen. All rights reserved.

#import "CalculatorBrain.h"


@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *programStack;

@end


@implementation CalculatorBrain


+ (NSString *)descriptionOfProgram:(id)program {
  NSMutableArray *stack;
	if ([program isKindOfClass: [NSArray class]]) {
		stack = [program mutableCopy];
	}
	
  NSString *description = [self descriptionOfTopOfStack:stack:nil];
  while ([stack count] > 0) {
    description = [description stringByAppendingFormat:
                   @", %@", [self descriptionOfTopOfStack:stack:nil]];
  }
  
	return description;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)
                                stack:(NSString *)preOp {
  NSString *description;
  
  id topOfStack = [stack lastObject];
  if (topOfStack) [stack removeLastObject];
  
  if ([topOfStack isKindOfClass:[NSString class]]) {  
    if ([self isBinaryOperand:topOfStack]) {
      NSString *op1 = [self descriptionOfTopOfStack:stack:topOfStack];
      NSString *op2 = [self descriptionOfTopOfStack:stack:topOfStack];
      // outputted in reverse order to negate Reverse Polish order
      description = [[NSString alloc]
                     initWithFormat:@"%@ %@ %@", op2, topOfStack, op1];
      
      NSSet *plusAndMinus = [NSSet setWithObjects:@"+", @"-", nil];
      NSSet *multiplyAndDivide = [NSSet setWithObjects:@"*", @"/", nil];
      if ([plusAndMinus containsObject:topOfStack] &&
          [multiplyAndDivide containsObject:preOp])
        description = [NSString stringWithFormat:@"(%@)", description];
    } else if ([self isUnaryOperand:topOfStack]) {
      NSString *op = [self descriptionOfTopOfStack:stack:topOfStack];
      description = [[NSString alloc]
                     initWithFormat:@"%@(%@)", topOfStack, op];
    } else {
      description = topOfStack;
    }
  } else if ([topOfStack isKindOfClass:[NSNumber class]]) {
    description = [[NSString alloc]
                   initWithFormat:@"%g", [topOfStack doubleValue]];
  } else {
    description = @"ERR";
  }
  
  return description;
}

+ (BOOL)isBinaryOperand:(NSString *)operand {
  NSSet *binaryOperands = [NSSet setWithObjects:@"*", @"/", @"+", @"-", nil];

  return [binaryOperands containsObject:operand];
}

+ (BOOL)isUnaryOperand:(NSString *)operand {
  NSSet *unaryOperands =
  [[NSSet alloc] initWithObjects:@"sin", @"cos", @"sqrt", nil];
  return [unaryOperands containsObject:operand];
}

+ (BOOL)isUnadornedOperand:(NSString *)operand {
  NSSet *unadornedOperands = [NSSet setWithObjects:@"pi", @"switch_sign", nil];
  return [unadornedOperands containsObject:operand];
}

+ (BOOL)isOperation:(NSString *)operation {
  BOOL isOperation = NO;
  
  if ([self isBinaryOperand:operation]) isOperation = YES;
  if ([self isUnaryOperand:operation]) isOperation = YES;
  if ([self isUnaryOperand:operation]) isOperation = YES;
  
  return isOperation;
}

+ (NSSet *)variablesUsedInProgram:(id)program {
  NSMutableSet *vars;
  if ([program isKindOfClass:[NSArray class]]) {
    for (id operation in program) {
      if ([operation isKindOfClass:[NSString class]] &&
          [self isOperation:operation]) {
        if (!vars) vars = [[NSMutableSet alloc] init];
        [vars addObject:operation];
      }
    }
  }
  
  return [vars copy];
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

@synthesize programStack = programStack_;

- (NSMutableArray *)programStack {
	if (!programStack_)
		programStack_ = [[NSMutableArray alloc] init];
	
	return programStack_;
}

- (id)program {
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
