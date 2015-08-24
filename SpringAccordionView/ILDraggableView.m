//
//  ILDraggableView.m
//  SpringAccordionView
//
//  Created by Derek Blair on 2015-05-25.
//  Copyright (c) 2015 Derek Blair All rights reserved.
//

#import "ILDraggableView.h"

@implementation ILDraggableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self addGestureRecognizer:recognizer];
}

- (void)didPan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self];
        velocity.x = 0;
        [self.delegate draggableView:self draggingEndedWithVelocity:velocity];
    } else if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.delegate draggableViewBeganDragging:self];
    } else {
        CGPoint velocity = [recognizer velocityInView:self];
        velocity.x = 0;
        [self.delegate draggableViewDragged:self velocity:velocity translation:[recognizer translationInView:self]];
    }
}

@end
