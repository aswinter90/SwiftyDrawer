struct Trigger: Equatable {
    private var value = 0

    mutating func update() { value = .random(in: 1...1000) }
}
