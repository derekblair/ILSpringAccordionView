//
//  ILSpringMenuBackPaneBehavior.h
//  SpringAccordionView
//
//  Created by Derek Blair on 2015-05-25.
//  Copyright (c) 2015 Derek Blair All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILSpringMenuBackPaneBehavior : UIDynamicBehavior

@property (nonatomic) CGPoint targetPoint;
@property (nonatomic) CGPoint velocity;

- (instancetype)initWithItem:(id <UIDynamicItem>)item;

@end
