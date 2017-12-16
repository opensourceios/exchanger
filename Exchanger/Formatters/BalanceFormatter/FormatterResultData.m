#import "ConvenientObjC.h"
#import "FormatterResultData.h"
#import "FormatterFactoryImpl.h"

@implementation FormatterResultData

- (instancetype)initWithFormattedString:(NSAttributedString *)formattedString string:(NSString *)string {
    self = [super init];
    if (self) {
        _formattedString = formattedString;
        _string = string;
    }
    return self;
}

- (float)floatValue {
    return self.string.floatValue;
}

+ (FormatterResultData *)formatterDataWithString:(NSString *)string {
    return [FormatterResultData formatterDataWithString:string sign:BalanceFormatterSignNone];
}

+ (FormatterResultData *)formatterDataWithString:(NSString *)string sign:(BalanceFormatterSign)sign {
    let formatter = [[FormatterFactoryImpl instance] exchangeCurrencyInputFormatter];
    return [formatter formatString:string sign:sign];
}

+ (FormatterResultData *)formatterDataWithNumber:(NSNumber *)number sign:(BalanceFormatterSign)sign {
    let formatter = [[FormatterFactoryImpl instance] exchangeCurrencyInputFormatter];
    return [formatter formatNumber:number sign:sign];
}

@end
