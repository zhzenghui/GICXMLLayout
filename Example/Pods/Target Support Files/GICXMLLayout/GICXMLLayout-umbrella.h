#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GICImageView.h"
#import "GICLable.h"
#import "LayoutElement.h"
#import "GICPanel.h"
#import "GICStackPanel.h"
#import "UIView+GICExtension.h"
#import "UIView+LayoutView.h"
#import "GICXMLLayout.h"
#import "UIColor+Extension.h"
#import "GICColorConverter.h"
#import "GICEdgeConverter.h"
#import "GICFloatConverter.h"
#import "GICStringConverter.h"
#import "GICURLConverter.h"
#import "GICValueConverter.h"

FOUNDATION_EXPORT double GICXMLLayoutVersionNumber;
FOUNDATION_EXPORT const unsigned char GICXMLLayoutVersionString[];

