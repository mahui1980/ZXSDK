

#import "ZXMraidWebView.h"

@implementation ZXMraidWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)scaleWebView:(float) fScale {
    UIScrollView* scrollView = [self getScrollView];
    if (scrollView) {
        scrollView.minimumZoomScale = 0.1;
        scrollView.maximumZoomScale = 10;
        [scrollView setZoomScale:fScale animated:NO];
    }
}

- (void)disableScrolling
{
    UIScrollView* scrollView = [self getScrollView];
    if (scrollView) {
        [scrollView setContentInset:UIEdgeInsetsZero];
        [scrollView setBounces:NO];
        [scrollView setScrollEnabled:NO];
        scrollView.minimumZoomScale = 0.1;
        scrollView.maximumZoomScale = 10;

    }
}

- (void)disableSelection
{
    NSString * js = @"window.getSelection().removeAllRanges();";
    [self stringByEvaluatingJavaScriptFromString:js];
}

- (void)scrollToTop
{
    UIScrollView* scrollView = nil;
    
    if ([self respondsToSelector:@selector(scrollView)])
    {
        scrollView = [self scrollView];
    }
    else
    {
        for (id sv in [self subviews])
        {
            if ([sv isKindOfClass:[UIScrollView class]])
            {
                scrollView = sv;
                break;
            }
        }
    }
    
    [scrollView setContentOffset:CGPointZero animated:NO];
}

-(UIScrollView* )getScrollView {
    UIScrollView* scrollView = nil;
    
    if ([self respondsToSelector:@selector(scrollView)])
    {
        scrollView = [self scrollView];
    }
    else
    {
        for (id sv in [self subviews])
        {
            if ([sv isKindOfClass:[UIScrollView class]])
            {
                scrollView = sv;
                break;
            }
        }
    }
    
    return scrollView;
}

@end
