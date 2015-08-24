//
//  ViewController.m
//  Spring Accordion View Demo
//
//  Created by Derek Blair on 2015-08-23.
//
//

#import "ViewController.h"
#import "ILSpringAccordionView.h"

@interface ViewController ()
@end

@implementation ViewController {
    ILSpringAccordionView *_springAccordionView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!_springAccordionView) {
        _springAccordionView = [[ILSpringAccordionView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_springAccordionView];

        UILabel *section0 = [[UILabel alloc] init];
        section0.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
        section0.textColor = [UIColor whiteColor];

        UILabel *section1 = [[UILabel alloc] init];
        section1.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:1 alpha:1];
        section1.textColor = [UIColor whiteColor];

        UILabel *section2 = [[UILabel alloc] init];
        section2.backgroundColor = [UIColor colorWithRed:0.5 green:0.0 blue:1 alpha:1];
        section2.textColor = [UIColor whiteColor];

        section0.font = [UIFont systemFontOfSize:36];
        section0.text = @"One   .";
        section0.textAlignment = NSTextAlignmentRight;

        section1.font = [UIFont systemFontOfSize:36];
        section1.text = @".  Two";
        section1.textAlignment = NSTextAlignmentLeft;

        section2.font = [UIFont systemFontOfSize:36];
        section2.text = @"Three  .";
        section2.textAlignment = NSTextAlignmentRight;

        // Hidden placeholder since we don't want a visible view at the bottom.
        UIView *section3 = [[UIView alloc] init];
        section3.backgroundColor = [UIColor clearColor];

        [_springAccordionView setupWithSectionViews:@[ section0, section1, section2, section3 ]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
