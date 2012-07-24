//
//  GraphViewController.h
//  Calculator
//
//  Created by Eric Rushing on 7/23/12.
//  Copyright (c) 2012 Septen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"


@interface GraphViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) NSArray *program;

@end
