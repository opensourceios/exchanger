#import "ConvenientObjC.h"
#import "NumberFilterFormatterImpl.h"

@interface NumberFilterFormatterImpl()
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@end

@implementation NumberFilterFormatterImpl

// MARK: - Init

- (instancetype)initWithNumberFormatter:(NSNumberFormatter *)numberFormatter {
    self = [super init];
    if (self) {
        self.numberFormatter = numberFormatter;
    }
    return self;
}

// MARK: - NumberFilterFormatter

- (nonnull NumberFilterFormatterData *)format:(nonnull NSString *)string; {
    var resultString = [self filterNonNumericAndSeparatorCharacters:string];
    resultString = [self filterExtraSeparators:resultString];
    resultString = [self filterStringEqualToSeparator:resultString];
    resultString = [self filterLeadingZeros:resultString];
    
    let resultNumber = [self.numberFormatter numberFromString:resultString];
    
    var result = [[NumberFilterFormatterData alloc] init];
    result.string = resultString;
    result.number = resultNumber;
    
    return result;
}

// MARK: - Private

- (NSString *)separator {
    return [self.numberFormatter.locale objectForKey:NSLocaleDecimalSeparator];
}

- (NSString *)filterNonNumericAndSeparatorCharacters:(NSString *)targetString {
    var set = [NSMutableCharacterSet decimalDigitCharacterSet];
    
    let separator = [self separator];
    
    [set addCharactersInString:separator];
    [set invert];
    
    return [[targetString componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
}

- (NSString *)filterExtraSeparators:(NSString *)targetString {
    let separator = [self separator];
    let components = [targetString componentsSeparatedByString:separator];
    if (components.count > 2) {
        let index = [targetString rangeOfString:separator].location;
        let range = NSMakeRange(index + 1, targetString.length - index - 1);
        return [targetString stringByReplacingOccurrencesOfString:separator
                                                                 withString:@""
                                                                    options:0
                                                                      range:range];
    }
    return targetString;
}

- (NSString *)filterStringEqualToSeparator:(NSString *)targetString {
    let separator = [self separator];
    if ([targetString isEqualToString:separator]) {
        return @"";
    }
    return targetString;
}

- (NSString *)filterLeadingZeros:(NSString *)targetString {
    
    if ([targetString isEqualToString:@"0"]) {
        return targetString;
    }
    
    let range = [targetString rangeOfString:@"^0*" options:NSRegularExpressionSearch];
    let result = [targetString stringByReplacingCharactersInRange:range withString:@""];
    
    return [result isEqualToString:@""] ? @"0" : result;
}

@end
