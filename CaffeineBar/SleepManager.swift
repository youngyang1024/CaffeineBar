import Foundation
import IOKit.pwr_mgt

final class SleepManager {

    static let shared = SleepManager()

    private(set) var isAwake = false
    private var assertionID: IOPMAssertionID = IOPMAssertionID(0)

    private init() {}

    @discardableResult
    func enable() -> Bool {
        guard !isAwake else { return true }

        let reason = "CaffeineBar is keeping your Mac awake" as CFString
        let result = IOPMAssertionCreateWithName(
            kIOPMAssertionTypePreventUserIdleSystemSleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason,
            &assertionID
        )

        if result == kIOReturnSuccess {
            isAwake = true
            return true
        }
        return false
    }

    func disable() {
        guard isAwake else { return }
        IOPMAssertionRelease(assertionID)
        assertionID = IOPMAssertionID(0)
        isAwake = false
    }

    func toggle() {
        if isAwake {
            disable()
        } else {
            enable()
        }
    }
}
