//
//  ILSpringAccordionView.m
//  SpringAccordionView
//
//  Created by Derek Blair on 2015-05-25.
//  Copyright (c) 2015 Derek Blair All rights reserved.
//

#import "ILSpringAccordionView.h"
#import "ILDraggableView.h"
#import "ILSpringMenuBackPaneBehavior.h"
#import "ILSpringMenuLatticePointBehavior.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

static CGFloat const ILSpringAccordionViewLatticeHeight = 60;
static CGFloat const ILSpringAccordionViewLatticeLeftRightOverflow = 40;
static CGFloat const ILSpringAccordionViewLatticeDraggableViewOffsetFactor = 0.7;

@interface ILSpringAccordionView () <ILDraggableViewDelegate>

@property (nonatomic) ILDraggableView *pane;
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic, strong) ILSpringMenuBackPaneBehavior *paneBehavior;
@property (nonatomic, readonly) NSArray *latticeSpringPoints;
@property (nonatomic, readonly) NSArray *ribbons;

- (void)addBehavoirs;

@end

@implementation ILSpringAccordionView {
    NSArray *_latticeSpringPoints;
    NSArray *_ribbons;
    NSArray *_sectionViews;
}

#pragma mark -  UIView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) return YES;
    }
    return NO;
}

#pragma mark - ILSpringAccordionView

- (void)setupWithSectionViews:(NSArray *)sectionViews {
    CGFloat ILSpringAccordionViewLatticePoints = sectionViews.count + 1;
    CGFloat const latticeDy = ((self.bounds.size.height) / ILSpringAccordionViewLatticePoints);
    CGFloat const latticeTop = (self.bounds.size.height) - latticeDy;

    self.backgroundColor = [UIColor clearColor];
    CGSize size = self.bounds.size;
    self.paneState = ILSpringMenuStateClosed;
    self.pane = [[ILDraggableView alloc] initWithFrame:CGRectMake(0, ILSpringAccordionViewLatticeDraggableViewOffsetFactor * size.height, size.width, size.height)];
    self.pane.backgroundColor = [UIColor clearColor];
    self.pane.opaque = NO;
    self.pane.delegate = self;
    self.userInteractionEnabled = YES;
    self.pane.userInteractionEnabled = YES;
    [self addSubview:self.pane];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 0; i < ILSpringAccordionViewLatticePoints; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        [self addSubview:v];
        v.alpha = 0;
        v.center = CGPointMake(self.bounds.size.width / 2, latticeTop + latticeDy * i);
        [array addObject:v];
    }
    _sectionViews = sectionViews;

    for (UIView *tri in _sectionViews) {
        [self addSubview:tri];
        tri.layer.zPosition = 0;
        tri.userInteractionEnabled = NO;
    }

    _latticeSpringPoints = [NSArray arrayWithArray:array];
    NSMutableArray *arrayRibbon = [NSMutableArray array];
    for (NSUInteger i = 0; i < ILSpringAccordionViewLatticePoints - 1; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(-ILSpringAccordionViewLatticeLeftRightOverflow, 0, self.bounds.size.width + 2 * ILSpringAccordionViewLatticeLeftRightOverflow, ILSpringAccordionViewLatticeHeight)];
        [self addSubview:v];
        v.userInteractionEnabled = NO;
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = v.bounds;
        gradientLayer.colors = @[ (id)(UIColorFromRGB(0xdc0125).CGColor), (id)(UIColorFromRGB(0xfc002a).CGColor) ];
        [v.layer insertSublayer:gradientLayer atIndex:0];
        [arrayRibbon addObject:v];
    }
    _ribbons = [NSArray arrayWithArray:arrayRibbon];

    [self addBehavoirs];
    [self toggle];
}

- (void)addBehavoirs {
    CGFloat ILSpringAccordionViewLatticePoints = self.sectionViews.count + 1;
    [self.animator removeAllBehaviors];

    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:_latticeSpringPoints];
    itemBehavior.density = 2;
    itemBehavior.resistance = 3;
    [self.animator addBehavior:itemBehavior];

    ILSpringMenuLatticePointBehavior *bottomAttachmentBehavoir = [[ILSpringMenuLatticePointBehavior alloc] initWithItems:@[ [_latticeSpringPoints firstObject], self.pane ]];
    [self.animator addBehavior:bottomAttachmentBehavoir];

    for (NSUInteger i = 1; i < ILSpringAccordionViewLatticePoints; i++) {
        [self.animator addBehavior:[[ILSpringMenuLatticePointBehavior alloc] initWithItems:@[ _latticeSpringPoints[i], _latticeSpringPoints[i - 1] ]]];
    }

    ILSpringMenuBackPaneBehavior *behavior = [[ILSpringMenuBackPaneBehavior alloc] initWithItem:self.pane];
    self.paneBehavior = behavior;
    __weak ILSpringAccordionView *weakSelf = self;
    self.paneBehavior.action = ^{

        [weakSelf.delegate viewDragged:MIN(MAX(weakSelf.pane.frame.origin.y / self.bounds.size.height * (1 / ILSpringAccordionViewLatticeDraggableViewOffsetFactor), 0), 1.0) sender:weakSelf];

        for (NSUInteger i = 0; i < ILSpringAccordionViewLatticePoints - 1; i++) {
            CGFloat leftPoint = ((UIView *)(weakSelf.latticeSpringPoints[i])).center.y;
            CGFloat rightPoint = ((UIView *)(weakSelf.latticeSpringPoints[i + 1])).center.y;

            UIView *v = weakSelf.ribbons[i];
            float theta = atan((rightPoint - leftPoint) / weakSelf.bounds.size.width);
            v.center = CGPointMake(weakSelf.bounds.size.width / 2, leftPoint + (rightPoint - leftPoint) / 2);
            v.transform = CGAffineTransformMakeRotation((i & 1 ? 1 : -1) * theta);

            UIView *triangleBackView = (UIView *)(weakSelf.sectionViews[i]);
            CGFloat farPoint = i < ILSpringAccordionViewLatticePoints - 2 ? ((UIView *)(weakSelf.latticeSpringPoints[i + 2])).center.y : ((UIView *)(weakSelf.latticeSpringPoints[i + 1])).center.y;

            triangleBackView.frame = CGRectMake(0, leftPoint, weakSelf.bounds.size.width, farPoint - leftPoint);

            CAShapeLayer *mask = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            if (i % 2 == 1) {
                [path moveToPoint:CGPointZero];
                [path addLineToPoint:CGPointMake(triangleBackView.bounds.size.width, triangleBackView.bounds.size.height / 2)];
                [path addLineToPoint:CGPointMake(0, triangleBackView.bounds.size.height)];
                [path addLineToPoint:CGPointZero];
            } else {
                [path moveToPoint:CGPointMake(0, triangleBackView.bounds.size.height / 2)];
                [path addLineToPoint:CGPointMake(triangleBackView.bounds.size.width, 0)];
                [path addLineToPoint:CGPointMake(triangleBackView.bounds.size.width, triangleBackView.bounds.size.height)];
                [path addLineToPoint:CGPointMake(0, triangleBackView.bounds.size.height / 2)];
            }
            mask.frame = triangleBackView.bounds;
            mask.path = path.CGPath;

            triangleBackView.layer.mask = mask;
        }

    };

    [self.animator addBehavior:self.paneBehavior];
}

- (void)animatePaneWithInitialVelocity:(CGPoint)initialVelocity {
    self.paneBehavior.targetPoint = self.targetPoint;
    self.paneBehavior.velocity = initialVelocity;
}

- (CGPoint)targetPoint {
    CGSize size = self.bounds.size;
    return self.paneState == ILSpringMenuStateClosed > 0 ? CGPointMake(size.width / 2, size.height * 1.2) : CGPointMake(size.width / 2, size.height * 0.5);
}

#pragma mark - ILDraggableViewDelegate

- (void)draggableView:(ILDraggableView *)view draggingEndedWithVelocity:(CGPoint)velocity {
    ILSpringMenuState targetState = velocity.y >= 0 ? ILSpringMenuStateClosed : ILSpringMenuStateOpen;
    self.paneState = targetState;
    [self animatePaneWithInitialVelocity:velocity];
}

- (void)draggableViewBeganDragging:(ILDraggableView *)view {
}

- (void)draggableViewDragged:(ILDraggableView *)view velocity:(CGPoint)velocity translation:(CGPoint)translation {
    self.paneBehavior.targetPoint = CGPointMake(self.targetPoint.x, self.targetPoint.y + translation.y);
}

#pragma mark - Actions

- (void)toggle {
    self.paneState = self.paneState == ILSpringMenuStateOpen ? ILSpringMenuStateClosed : ILSpringMenuStateOpen;
    [self animatePaneWithInitialVelocity:self.paneBehavior.velocity];
}

@end