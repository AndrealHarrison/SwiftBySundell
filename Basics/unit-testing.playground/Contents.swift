// Swift by Sundell sample code
// https://www.swiftbysundell.com/basics/unit-testing
// (c) 2019 John Sundell
// Licensed under the MIT license

import XCTest

// --- Product and Coupon Models ---

struct Product: Equatable {
    let name: String
    var price: Double
}

struct Coupon {
    let name: String
    let discount: Double
}

// --- Product Extension ---

extension Product {
    mutating func apply(_ coupon: Coupon) {
        let multiplier = 1 - coupon.discount / 100
        price *= multiplier
    }
}

// --- ShoppingCart Class ---

class ShoppingCart {
    private var products: [Product] = []

    var totalPrice: Double {
        return products.reduce(0) { (result, product) -> Double in
            return result + product.price
        }
    }

    func add(_ product: Product) {
        products.append(product)
    }

    func remove(_ productToRemove: Product) {
        if let index = products.firstIndex(where: { $0 == productToRemove }) {
            products.remove(at: index)
        }
    }
}

// --- Unit Tests ---

class ProductTests: XCTestCase {
    func testApplyingCoupon() {
        // Given
        var product = Product(name: "Book", price: 25)
        let coupon = Coupon(name: "Holiday Sale", discount: 20)

        // When
        product.apply(coupon)

        // Then
        XCTAssertEqual(product.price, 20)
    }
}

class ShoppingCartTests: XCTestCase {
    private var shoppingCart: ShoppingCart!

    override func setUp() {
        super.setUp()
        shoppingCart = ShoppingCart()
    }

    func testCalculatingTotalPrice() {
        // Given
        XCTAssertEqual(shoppingCart.totalPrice, 0)

        // When
        shoppingCart.add(Product(name: "Book", price: 20))
        shoppingCart.add(Product(name: "Movie", price: 15))

        // Then
        XCTAssertEqual(shoppingCart.totalPrice, 35)
    }

    func testRemovingProduct() {
        // Given
        let book = Product(name: "Book", price: 20)
        let movie = Product(name: "Movie", price: 15)
        shoppingCart.add(book)
        shoppingCart.add(movie)
        XCTAssertEqual(shoppingCart.totalPrice, 35)

        // When
        shoppingCart.remove(book)

        // Then
        XCTAssertEqual(shoppingCart.totalPrice, 15)
    }
}

// --- Running all of our unit tests within the playground ---

XCTestSuite.default.run()
