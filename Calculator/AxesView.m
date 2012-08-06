//
//  A UIView that can graph an RPN Calculator Program object.
//
//  Created by Eric Rushing on 7/25/12.
//  Copyright (c) 2012 Septen. All rights reserved.
//
#import "AxesView.h"
#import "AxesDrawer.h"


#define DEFAULT_SCALE 20;


@implementation AxesView

@synthesize scale = scale_;
@synthesize dataSource = dataSource_;

- (CGFloat)scale {
  if (!scale_) self.scale = DEFAULT_SCALE;
  return scale_;
}

- (CGPoint)originFromRect:(CGRect)rect {
  return CGPointMake(rect.origin.x + rect.size.width / 2,
                     rect.origin.y + rect.size.height / 2);
}

- (void)drawRect:(CGRect)rect {
  CGPoint origin = [self originFromRect:rect];
  [AxesDrawer drawAxesInRect:rect originAtPoint:origin scale:self.scale];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  UIGraphicsPushContext(context);
  
  int x = rect.origin.x;
  double xVal = x / self.scale - rect.origin.x;
  double yVal = [self.dataSource getYForX:xVal];
  int y = yVal * (self.scale + rect.origin.y);
  CGContextMoveToPoint(context, x, y);
  
  for (x++; x <= rect.size.width; x++) {
    xVal = x / self.scale - rect.origin.x;
    yVal = [self.dataSource getYForX:xVal];
    y = yVal * (self.scale + rect.origin.y);
    CGContextAddLineToPoint(context, x, y);
  }
  
  CGColorRef cyan = [UIColor colorWithRed:0 green:0.8 blue:0.8 alpha:1].CGColor;
  CGContextSetStrokeColorWithColor(context, cyan);
  CGContextSetLineWidth(context, 1);
  CGContextStrokePath(context);
  
  UIGraphicsPopContext();
}

@end
