//
//  ILDraggableView.h
//  SpringAccordionView
//
//  Created by Derek Blair on 2015-05-25.
//  Copyright (c) 2015 Derek Blair All rights reserved.
//

#import <UIKit/UIKit.h>

@class ILDraggableView;

@protocol ILDraggableViewDelegate

- (void)draggableView:(ILDraggableView *)view
    draggingEndedWithVelocity:(CGPoint)velocity;
- (void)draggableViewBeganDragging:(ILDraggableView *)view;
- (void)draggableViewDragged:(ILDraggableView *)view
                    velocity:(CGPoint)velocity
                 translation:(CGPoint)translation;

@end

@interface ILDraggableView : UIView

@property(nonatomic, weak) id<ILDraggableViewDelegate> delegate;

@end