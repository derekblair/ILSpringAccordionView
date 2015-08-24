//
//  ILSpringMenuLatticePointBehavior.m
//  SpringAccordionView
//
//  Created by Derek Blair on 2015-05-25.
//  Copyright (c) 2015 Derek Blair All rights reserved.
//

#import "ILSpringMenuLatticePointBehavior.h"

@implementation ILSpringMenuLatticePointBehavior

- (instancetype)initWithItems:(NSArray *)items {
    self = [super initWithItem:items[0] offsetFromCenter:UIOffsetZero attachedToItem:items[1] offsetFromCenter:UIOffsetZero];
    if (self != nil) {
        self.frequency = 8.0;
        self.damping = 1.6;
    }
    return self;
}

@end
