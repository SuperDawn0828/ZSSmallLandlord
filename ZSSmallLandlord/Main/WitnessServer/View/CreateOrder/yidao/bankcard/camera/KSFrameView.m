//
//  KSFrameView.m
//  MosiacCamera
//
//  Created by wangchen on 4/2/15.
//  Copyright (c) 2015 kimsungwhee.com. All rights reserved.
//

#import "KSFrameView.h"
#import "BankInfo.h"

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)
//#define LINE_LENGTH 20
@interface KSFrameView()
{
    int LINE_LENGTH;
    BOOL bShowLine;
}
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@end

@implementation KSFrameView
@synthesize promptLabel;
@synthesize supportLabel;
@synthesize timer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        LINE_LENGTH = frame.size.width / 10;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.15 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        [self.timer fire];
        bShowLine = NO;
        
        promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        promptLabel.backgroundColor = [UIColor clearColor];
        promptLabel.textAlignment = NSTextAlignmentCenter;
        promptLabel.textColor = [UIColor greenColor];
        promptLabel.font = [UIFont boldSystemFontOfSize:18];
        promptLabel.text = PROMPT_DEFAULT;
        [self addSubview:promptLabel];
        
        if (DISPLAY_LOGO_BANK) {
            supportLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            supportLabel.backgroundColor = [UIColor clearColor];
            supportLabel.textAlignment = NSTextAlignmentCenter;
            supportLabel.textColor = [UIColor lightGrayColor];
            supportLabel.font = [UIFont boldSystemFontOfSize:16];
            supportLabel.text = SUPPORT_INFO;
            [self addSubview:supportLabel];
        }

    }
    return self;
}
- (void)loadUI:(UIInterfaceOrientation)orientation
{
    self.orientation = orientation;

    float rotate;
    float promptX, promptY;
    float supportX, supportY;
    float fontSize = 16;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            rotate = 0.0f;
            promptX = self.frame.size.width/2;
            promptY = self.frame.size.height/3;
            supportX = self.frame.size.width/2;
            supportY = self.frame.size.height - fontSize;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotate = 270.0f;
            promptX = self.frame.size.width/3;
            promptY = self.frame.size.height/2;
            supportX = self.frame.size.width - fontSize;
            supportY = self.frame.size.height/2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotate = 90.0f;
            promptX = self.frame.size.width*2/3;
            promptY = self.frame.size.height/2;
            supportX = fontSize;
            supportY = self.frame.size.height/2;
            break;
        default:
            rotate = 0.0f;
            promptX = self.frame.size.width/2;
            promptY = self.frame.size.height/3;
            supportX = self.frame.size.width/2;
            supportY = self.frame.size.height - fontSize;
            break;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation((rotate * M_PI) / 180.0f);
    promptLabel.transform = transform;
    promptLabel.center = CGPointMake(promptX, promptY);
    if (DISPLAY_LOGO_BANK) {
        supportLabel.transform = transform;
        supportLabel.center = CGPointMake(supportX, supportY);
    }
}
- (void)dealloc
{
//    [self.timer invalidate];
}

- (void)timerFire:(id)notice
{
    bShowLine = !bShowLine;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 14);
    CGContextSetRGBStrokeColor(context, 0.3, 0.8, 0.3, 0.8);
    
    CGContextBeginPath(context);
    
    CGPoint pt = rect.origin;
    CGContextMoveToPoint(context, pt.x, pt.y+LINE_LENGTH);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x + LINE_LENGTH, pt.y);
    
    pt = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
    CGContextMoveToPoint(context, pt.x - LINE_LENGTH, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y + LINE_LENGTH);
    
    pt = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    CGContextMoveToPoint(context, pt.x, pt.y - LINE_LENGTH);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x + LINE_LENGTH, pt.y);
    
    
    pt = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    CGContextMoveToPoint(context, pt.x - LINE_LENGTH, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y-LINE_LENGTH);
    CGContextStrokePath(context);
    
    if(bShowLine)
    {
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 2);
        CGPoint p1, p2;
        float x;
        float y;
        switch (self.orientation) {
            case UIInterfaceOrientationPortrait:
                x = rect.origin.x;
                y = rect.origin.y + self.frame.size.height * (54 - 22) / 54;
                p1 = CGPointMake(x, y);
                p2 = CGPointMake(x + rect.size.width, y);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                x = rect.origin.x + self.frame.size.width * (54 - 22) / 54;
                y = rect.origin.y;
                p1 = CGPointMake(x, y);
                p2 = CGPointMake(x, y + rect.size.height);
                break;
            case UIInterfaceOrientationLandscapeRight:
                x = rect.origin.x + self.frame.size.width * 22 / 54;
                y = rect.origin.y;
                p1 = CGPointMake(x, y);
                p2 = CGPointMake(x, y + rect.size.height);
                break;
            default:
                x = rect.origin.x;
                y = rect.origin.y + self.frame.size.height * (54 - 22) / 54;
                p1 = CGPointMake(x, y);
                p2 = CGPointMake(x + rect.size.width, y);
                break;
        }

        CGContextMoveToPoint(context,p1.x, p1.y);
        CGContextAddLineToPoint(context, p2.x, p2.y);
        CGContextStrokePath(context);
    }
}

@end
