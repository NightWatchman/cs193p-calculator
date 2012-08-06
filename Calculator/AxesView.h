//
//  AxesView.h
//  Calculator
//
//  Created by Eric Rushing on 7/25/12.
//  Copyright (c) 2012 Septen. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AxesViewDataSource

- (double)getYForX:(double)x;

@end


@interface AxesView : UIView

@property (readonly) CGPoint origin;
@property (nonatomic) CGFloat scale; // points per unit
@property (nonatomic, weak) id <AxesViewDataSource> dataSource;

@end
