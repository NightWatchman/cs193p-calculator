//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Eric Rushing on 6/30/12.
//  Copyright (c) 2012 Septentron Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalculatorBrain : NSObject

@property (nonatomic, readonly) id program;

-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;
-(void)clear;

@end
