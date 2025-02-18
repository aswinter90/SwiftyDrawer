import Foundation

struct SafeAreaInsetsHolder: Decodable {
    enum CodingKeys: String, CodingKey {
        case top = "safeAreaTop"
        case bottom = "safeAreaBottom"
    }

    let top: Double
    let bottom: Double

    init(data: Data) throws {
        self = try JSONDecoder().decode(SafeAreaInsetsHolder.self, from: data)
    }

}
