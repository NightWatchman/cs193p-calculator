//
//  A UIView that can graph an RPN Calculator Program object.
//
//  Created by Eric Rushing on 7/25/12.
//  Copyright (c) 2012 Septen. All rights reserved.
//
#import "AxesView.h"
#import "AxesDrawer.h"


@implementation AxesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
  
    return self;
}

- (void)drawRect:(CGRect)rect {
  CGPoint origin = CGPointMake(rect.origin.x + rect.size.width / 2,
                               rect.origin.y + rect.size.height / 2);
  [AxesDrawer drawAxesInRect:rect originAtPoint:origin scale:20];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
