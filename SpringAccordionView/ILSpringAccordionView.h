//
//  ILSpringAccordionView.h
//  SpringAccordionView
//
//  Created by Derek Blair on 2015-05-25.
//  Copyright (c) 2015 Derek Blair All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ILSpringMenuState) {
    ILSpringMenuStateOpen,
    ILSpringMenuStateClosed,
};

@protocol ILSpringAccordionViewDelegate <NSObject>
- (void)viewDragged:(CGFloat)level sender:(id)sender;
@end

@interface ILSpringAccordionView : UIView

@property (nonatomic) ILSpringMenuState paneState;
@property (nonatomic, weak) id<ILSpringAccordionViewDelegate> delegate;
@property (nonatomic, readonly) NSArray *sectionViews;

- (void)toggle;
- (void)setupWithSectionViews:(NSArray *)sectionViews;

@end
