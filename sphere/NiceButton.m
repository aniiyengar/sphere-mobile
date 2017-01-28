//
//  NiceButton.m
//  sphere
//
//  Created by Aniruddh Iyengar on 1/21/17.
//  Copyright © 2017 Aniruddh. All rights reserved.
//

#import "NiceButton.h"
#import <QuartzCore/QuartzCore.h>

@interface NiceButton()

@end


@implementation NiceButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    self.layer.cornerRadius = 10;
    self.layer.cornerRadius = 10;
    
    self.clipsToBounds = YES;
    self.clipsToBounds = YES;
    
    self.showsTouchWhenHighlighted = TRUE;
    
    [super awakeFromNib];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.alpha = enabled ? 1 : 0.6;
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents {
    NSLog(@"SDFSDF");
    if (controlEvents == UIControlEventTouchDown) {
        [self setAlpha:0.7];
    }
    else if (controlEvents == UIControlEventTouchUpOutside || controlEvents == UIControlEventTouchUpInside) {
        [self setAlpha:1];
    }
    [super sendActionsForControlEvents:controlEvents];
}



@end
