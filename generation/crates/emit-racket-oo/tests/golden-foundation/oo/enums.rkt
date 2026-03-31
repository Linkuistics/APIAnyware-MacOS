#lang racket/base
;; Generated enum definitions for Foundation

(provide (all-defined-out))

;; NSActivityOptions

;; NSAlignmentOptions

;; NSAppleEventSendOptions

;; NSAttributedStringEnumerationOptions

;; NSAttributedStringFormattingOptions

;; NSAttributedStringMarkdownInterpretedSyntax

;; NSAttributedStringMarkdownParsingFailurePolicy

;; NSBackgroundActivityResult

;; NSBinarySearchingOptions

;; NSByteCountFormatterCountStyle

;; NSByteCountFormatterUnits

;; NSCalculationError

;; NSCalendarOptions

;; NSCalendarUnit

;; NSCollectionChangeType

;; NSComparisonPredicateModifier

;; NSComparisonPredicateOptions

;; NSComparisonResult

;; NSCompoundPredicateType

;; NSDataBase64DecodingOptions

;; NSDataBase64EncodingOptions

;; NSDataCompressionAlgorithm

;; NSDataReadingOptions

;; NSDataSearchOptions

;; NSDataWritingOptions

;; NSDateComponentsFormatterUnitsStyle

;; NSDateComponentsFormatterZeroFormattingBehavior

;; NSDateFormatterBehavior

;; NSDateFormatterStyle

;; NSDateIntervalFormatterStyle

;; NSDecodingFailurePolicy

;; NSDirectoryEnumerationOptions

;; NSDistributedNotificationOptions

;; NSEnergyFormatterUnit

;; NSEnumerationOptions

;; NSExpressionType

;; NSFileCoordinatorReadingOptions

;; NSFileCoordinatorWritingOptions

;; NSFileManagerItemReplacementOptions

;; NSFileManagerResumeSyncBehavior

;; NSFileManagerSupportedSyncControls

;; NSFileManagerUnmountOptions

;; NSFileManagerUploadLocalVersionConflictPolicy

;; NSFileVersionAddingOptions

;; NSFileVersionReplacingOptions

;; NSFileWrapperReadingOptions

;; NSFileWrapperWritingOptions

;; NSFormattingContext

;; NSFormattingUnitStyle

;; NSGrammaticalCase

;; NSGrammaticalDefiniteness

;; NSGrammaticalDetermination

;; NSGrammaticalGender

;; NSGrammaticalNumber

;; NSGrammaticalPartOfSpeech

;; NSGrammaticalPerson

;; NSGrammaticalPronounType

;; NSHTTPCookieAcceptPolicy

;; NSISO8601DateFormatOptions

;; NSInlinePresentationIntent

;; NSInsertionPosition

;; NSItemProviderErrorCode

;; NSItemProviderFileOptions

;; NSItemProviderRepresentationVisibility

;; NSJSONReadingOptions

;; NSJSONWritingOptions

;; NSKeyValueChange

;; NSKeyValueObservingOptions

;; NSKeyValueSetMutationKind

;; NSLengthFormatterUnit

;; NSLinguisticTaggerOptions

;; NSLinguisticTaggerUnit

;; NSLocaleLanguageDirection

;; NSMachPortOptions

;; NSMassFormatterUnit

;; NSMatchingFlags

;; NSMatchingOptions

;; NSMeasurementFormatterUnitOptions

;; NSNetServiceOptions

;; NSNetServicesError

;; NSNotificationCoalescing

;; NSNotificationSuspensionBehavior

;; NSNumberFormatterBehavior

;; NSNumberFormatterPadPosition

;; NSNumberFormatterRoundingMode

;; NSNumberFormatterStyle

;; NSOperationQueuePriority

;; NSOrderedCollectionDifferenceCalculationOptions

;; NSPersonNameComponentsFormatterOptions

;; NSPersonNameComponentsFormatterStyle

;; NSPointerFunctionsOptions

;; NSPostingStyle

;; NSPredicateOperatorType

;; NSPresentationIntentKind

;; NSPresentationIntentTableColumnAlignment

;; NSProcessInfoThermalState

;; NSPropertyListFormat

;; NSPropertyListMutabilityOptions

;; NSQualityOfService

;; NSRectEdge

;; NSRegularExpressionOptions

;; NSRelativeDateTimeFormatterStyle

;; NSRelativeDateTimeFormatterUnitsStyle

;; NSRelativePosition

;; NSRoundingMode

;; NSSaveOptions

;; NSSearchPathDirectory

;; NSSearchPathDomainMask

;; NSSortOptions

;; NSStreamEvent

;; NSStreamStatus

;; NSStringCompareOptions

;; NSStringEncodingConversionOptions

;; NSStringEnumerationOptions

;; NSTaskTerminationReason

;; NSTestComparisonOperation

;; NSTextCheckingType

;; NSTimeZoneNameStyle

;; NSURLBookmarkCreationOptions

;; NSURLBookmarkResolutionOptions

;; NSURLCacheStoragePolicy

;; NSURLCredentialPersistence

;; NSURLErrorNetworkUnavailableReason

;; NSURLHandleStatus

;; NSURLRelationship

;; NSURLRequestAttribution

;; NSURLRequestCachePolicy

;; NSURLRequestNetworkServiceType

;; NSURLSessionAuthChallengeDisposition

;; NSURLSessionDelayedRequestDisposition

;; NSURLSessionMultipathServiceType

;; NSURLSessionResponseDisposition

;; NSURLSessionTaskMetricsDomainResolutionProtocol

;; NSURLSessionTaskMetricsResourceFetchType

;; NSURLSessionTaskState

;; NSURLSessionWebSocketCloseCode

;; NSURLSessionWebSocketMessageType

;; NSUserNotificationActivationType

;; NSVolumeEnumerationOptions

;; NSWhoseSubelementIdentifier

;; NSXMLDTDNodeKind

;; NSXMLDocumentContentKind

;; NSXMLNodeKind

;; NSXMLNodeOptions

;; NSXMLParserError

;; NSXMLParserExternalEntityResolvingPolicy

;; NSXPCConnectionOptions

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/FoundationErrors.h:11:1)
(define NSFileNoSuchFileError 4)
(define NSFileLockingError 255)
(define NSFileReadUnknownError 256)
(define NSFileReadNoPermissionError 257)
(define NSFileReadInvalidFileNameError 258)
(define NSFileReadCorruptFileError 259)
(define NSFileReadNoSuchFileError 260)
(define NSFileReadInapplicableStringEncodingError 261)
(define NSFileReadUnsupportedSchemeError 262)
(define NSFileReadTooLargeError 263)
(define NSFileReadUnknownStringEncodingError 264)
(define NSFileWriteUnknownError 512)
(define NSFileWriteNoPermissionError 513)
(define NSFileWriteInvalidFileNameError 514)
(define NSFileWriteFileExistsError 516)
(define NSFileWriteInapplicableStringEncodingError 517)
(define NSFileWriteUnsupportedSchemeError 518)
(define NSFileWriteOutOfSpaceError 640)
(define NSFileWriteVolumeReadOnlyError 642)
(define NSFileManagerUnmountUnknownError 768)
(define NSFileManagerUnmountBusyError 769)
(define NSKeyValueValidationError 1024)
(define NSFormattingError 2048)
(define NSUserCancelledError 3072)
(define NSFeatureUnsupportedError 3328)
(define NSExecutableNotLoadableError 3584)
(define NSExecutableArchitectureMismatchError 3585)
(define NSExecutableRuntimeMismatchError 3586)
(define NSExecutableLoadError 3587)
(define NSExecutableLinkError 3588)
(define NSFileErrorMinimum 0)
(define NSFileErrorMaximum 1023)
(define NSValidationErrorMinimum 1024)
(define NSValidationErrorMaximum 2047)
(define NSExecutableErrorMinimum 3584)
(define NSExecutableErrorMaximum 3839)
(define NSFormattingErrorMinimum 2048)
(define NSFormattingErrorMaximum 2559)
(define NSPropertyListReadCorruptError 3840)
(define NSPropertyListReadUnknownVersionError 3841)
(define NSPropertyListReadStreamError 3842)
(define NSPropertyListWriteStreamError 3851)
(define NSPropertyListWriteInvalidError 3852)
(define NSPropertyListErrorMinimum 3840)
(define NSPropertyListErrorMaximum 4095)
(define NSXPCConnectionInterrupted 4097)
(define NSXPCConnectionInvalid 4099)
(define NSXPCConnectionReplyInvalid 4101)
(define NSXPCConnectionCodeSigningRequirementFailure 4102)
(define NSXPCConnectionErrorMinimum 4096)
(define NSXPCConnectionErrorMaximum 4224)
(define NSUbiquitousFileUnavailableError 4353)
(define NSUbiquitousFileNotUploadedDueToQuotaError 4354)
(define NSUbiquitousFileUbiquityServerNotAvailable 4355)
(define NSUbiquitousFileErrorMinimum 4352)
(define NSUbiquitousFileErrorMaximum 4607)
(define NSUserActivityHandoffFailedError 4608)
(define NSUserActivityConnectionUnavailableError 4609)
(define NSUserActivityRemoteApplicationTimedOutError 4610)
(define NSUserActivityHandoffUserInfoTooLargeError 4611)
(define NSUserActivityErrorMinimum 4608)
(define NSUserActivityErrorMaximum 4863)
(define NSCoderReadCorruptError 4864)
(define NSCoderValueNotFoundError 4865)
(define NSCoderInvalidValueError 4866)
(define NSCoderErrorMinimum 4864)
(define NSCoderErrorMaximum 4991)
(define NSBundleErrorMinimum 4992)
(define NSBundleErrorMaximum 5119)
(define NSBundleOnDemandResourceOutOfSpaceError 4992)
(define NSBundleOnDemandResourceExceededMaximumSizeError 4993)
(define NSBundleOnDemandResourceInvalidTagError 4994)
(define NSCloudSharingNetworkFailureError 5120)
(define NSCloudSharingQuotaExceededError 5121)
(define NSCloudSharingTooManyParticipantsError 5122)
(define NSCloudSharingConflictError 5123)
(define NSCloudSharingNoPermissionError 5124)
(define NSCloudSharingOtherError 5375)
(define NSCloudSharingErrorMinimum 5120)
(define NSCloudSharingErrorMaximum 5375)
(define NSCompressionFailedError 5376)
(define NSDecompressionFailedError 5377)
(define NSCompressionErrorMinimum 5376)
(define NSCompressionErrorMaximum 5503)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSBundle.h:127:1)
(define NSBundleExecutableArchitectureI386 7)
(define NSBundleExecutableArchitecturePPC 18)
(define NSBundleExecutableArchitectureX86_64 16777223)
(define NSBundleExecutableArchitecturePPC64 16777234)
(define NSBundleExecutableArchitectureARM64 16777228)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSByteOrder.h:10:1)
(define NS_UnknownByteOrder 0)
(define NS_LittleEndian 1)
(define NS_BigEndian 2)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSCalendar.h:113:1)
(define NSWrapCalendarComponents 1)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSCalendar.h:423:1)
(define NSDateComponentUndefined 9223372036854775807)
(define NSUndefinedDateComponent 9223372036854775807)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSCharacterSet.h:14:1)
(define NSOpenStepUnicodeReservedBase 62464)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSProcessInfo.h:11:1)
(define NSWindowsNTOperatingSystem 1)
(define NSWindows95OperatingSystem 2)
(define NSSolarisOperatingSystem 3)
(define NSHPUXOperatingSystem 4)
(define NSMACHOperatingSystem 5)
(define NSSunOSOperatingSystem 6)
(define NSOSF1OperatingSystem 7)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSScriptCommand.h:13:1)
(define NSNoScriptError 0)
(define NSReceiverEvaluationScriptError 1)
(define NSKeySpecifierEvaluationScriptError 2)
(define NSArgumentEvaluationScriptError 3)
(define NSReceiversCantHandleCommandScriptError 4)
(define NSRequiredArgumentsMissingScriptError 5)
(define NSArgumentsWrongScriptError 6)
(define NSUnknownKeyScriptError 7)
(define NSInternalScriptError 8)
(define NSOperationNotSupportedForKeyScriptError 9)
(define NSCannotCreateScriptCommandError 10)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSScriptObjectSpecifiers.h:13:1)
(define NSNoSpecifierError 0)
(define NSNoTopLevelContainersSpecifierError 1)
(define NSContainerSpecifierError 2)
(define NSUnknownKeySpecifierError 3)
(define NSInvalidIndexSpecifierError 4)
(define NSInternalSpecifierError 5)
(define NSOperationNotSupportedForKeySpecifierError 6)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSString.h:548:1)
(define NSProprietaryStringEncoding 65536)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSString.h:68:1)
(define NSASCIIStringEncoding 1)
(define NSNEXTSTEPStringEncoding 2)
(define NSJapaneseEUCStringEncoding 3)
(define NSUTF8StringEncoding 4)
(define NSISOLatin1StringEncoding 5)
(define NSSymbolStringEncoding 6)
(define NSNonLossyASCIIStringEncoding 7)
(define NSShiftJISStringEncoding 8)
(define NSISOLatin2StringEncoding 9)
(define NSUnicodeStringEncoding 10)
(define NSWindowsCP1251StringEncoding 11)
(define NSWindowsCP1252StringEncoding 12)
(define NSWindowsCP1253StringEncoding 13)
(define NSWindowsCP1254StringEncoding 14)
(define NSWindowsCP1250StringEncoding 15)
(define NSISO2022JPStringEncoding 21)
(define NSMacOSRomanStringEncoding 30)
(define NSUTF16StringEncoding 10)
(define NSUTF16BigEndianStringEncoding 2415919360)
(define NSUTF16LittleEndianStringEncoding 2483028224)
(define NSUTF32StringEncoding 2348810496)
(define NSUTF32BigEndianStringEncoding 2550137088)
(define NSUTF32LittleEndianStringEncoding 2617245952)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSTextCheckingResult.h:32:1)
(define NSTextCheckingAllSystemTypes 4294967295)
(define NSTextCheckingAllCustomTypes -4294967296)
(define NSTextCheckingAllTypes -1)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSURLError.h:101:1)
(define NSURLErrorUnknown -1)
(define NSURLErrorCancelled -999)
(define NSURLErrorBadURL -1000)
(define NSURLErrorTimedOut -1001)
(define NSURLErrorUnsupportedURL -1002)
(define NSURLErrorCannotFindHost -1003)
(define NSURLErrorCannotConnectToHost -1004)
(define NSURLErrorNetworkConnectionLost -1005)
(define NSURLErrorDNSLookupFailed -1006)
(define NSURLErrorHTTPTooManyRedirects -1007)
(define NSURLErrorResourceUnavailable -1008)
(define NSURLErrorNotConnectedToInternet -1009)
(define NSURLErrorRedirectToNonExistentLocation -1010)
(define NSURLErrorBadServerResponse -1011)
(define NSURLErrorUserCancelledAuthentication -1012)
(define NSURLErrorUserAuthenticationRequired -1013)
(define NSURLErrorZeroByteResource -1014)
(define NSURLErrorCannotDecodeRawData -1015)
(define NSURLErrorCannotDecodeContentData -1016)
(define NSURLErrorCannotParseResponse -1017)
(define NSURLErrorAppTransportSecurityRequiresSecureConnection -1022)
(define NSURLErrorFileDoesNotExist -1100)
(define NSURLErrorFileIsDirectory -1101)
(define NSURLErrorNoPermissionsToReadFile -1102)
(define NSURLErrorDataLengthExceedsMaximum -1103)
(define NSURLErrorFileOutsideSafeArea -1104)
(define NSURLErrorSecureConnectionFailed -1200)
(define NSURLErrorServerCertificateHasBadDate -1201)
(define NSURLErrorServerCertificateUntrusted -1202)
(define NSURLErrorServerCertificateHasUnknownRoot -1203)
(define NSURLErrorServerCertificateNotYetValid -1204)
(define NSURLErrorClientCertificateRejected -1205)
(define NSURLErrorClientCertificateRequired -1206)
(define NSURLErrorCannotLoadFromNetwork -2000)
(define NSURLErrorCannotCreateFile -3000)
(define NSURLErrorCannotOpenFile -3001)
(define NSURLErrorCannotCloseFile -3002)
(define NSURLErrorCannotWriteToFile -3003)
(define NSURLErrorCannotRemoveFile -3004)
(define NSURLErrorCannotMoveFile -3005)
(define NSURLErrorDownloadDecodingFailedMidStream -3006)
(define NSURLErrorDownloadDecodingFailedToComplete -3007)
(define NSURLErrorInternationalRoamingOff -1018)
(define NSURLErrorCallIsActive -1019)
(define NSURLErrorDataNotAllowed -1020)
(define NSURLErrorRequestBodyStreamExhausted -1021)
(define NSURLErrorBackgroundSessionRequiresSharedContainer -995)
(define NSURLErrorBackgroundSessionInUseByAnotherProcess -996)
(define NSURLErrorBackgroundSessionWasDisconnected -997)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSURLError.h:69:1)
(define NSURLErrorCancelledReasonUserForceQuitApplication 0)
(define NSURLErrorCancelledReasonBackgroundUpdatesDisabled 1)
(define NSURLErrorCancelledReasonInsufficientSystemResources 2)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSUbiquitousKeyValueStore.h:47:1)
(define NSUbiquitousKeyValueStoreServerChange 0)
(define NSUbiquitousKeyValueStoreInitialSyncChange 1)
(define NSUbiquitousKeyValueStoreQuotaViolationChange 2)
(define NSUbiquitousKeyValueStoreAccountChange 3)

;; enum (unnamed at /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSZone.h:32:1)
(define NSScannedOption 1)
(define NSCollectorDisabledOption 2)

;; InflectionRule
(define automatic 0)
(define explicit 1)

;; AttributeDynamicLookup

;; AttributeScopes

;; PredicateExpressions

;; NumberFormatStyleConfiguration

;; CurrencyFormatStyleConfiguration

;; DescriptiveNumberFormatConfiguration

;; SortOrder
(define forward 0)
(define reverse 1)

;; InflectionConcept
(define termsOfAddress 0)
(define localizedPhrase 1)

;; MachErrorCode

;; POSIXErrorCode

;; FloatingPointRoundingRule

;; EncodingError

;; DecodingError

;; Optional

;; ComparisonResult

;; Never

;; Change

;; CGRectEdge

