extension Int {
    public var isSuccessHTTPCode: Bool {
        return self >= 200 && self < 300
    }
}
