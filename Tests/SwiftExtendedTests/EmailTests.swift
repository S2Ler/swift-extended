import XCTest
import SwiftExtended

class EmailTests: XCTestCase {
  func testCreateFailableInit() {
    XCTAssertNotNil(Email("email@email.com"))
    XCTAssertNotNil(Email("email@email"))
    XCTAssertNotNil(Email("    email@email.com"))
    XCTAssertNotNil(Email("    email@email"))
    XCTAssertNotNil(Email("email@email.com     "))
    XCTAssertNotNil(Email("   email@email   "))
    XCTAssertNil(Email("email@"))
    XCTAssertNil(Email("email"))
    XCTAssertNil(Email("email"))
    XCTAssertNil(Email(""))
    XCTAssertNil(Email(nil))
    XCTAssertNil(Email("@_asdf.com"))
  }

  func testDescription() {
    let email = "email@email.com"
    XCTAssertEqual(Email(email)!.description, email)
  }

  func testHashable() {
    let email1 = Email("email1@email")!
    let email11 = Email("email1@email")!
    let email2 = Email("email2@email")!
    let email22 = Email("email2@email")!

    XCTAssertEqual(email1, email11)
    XCTAssertEqual(email2, email22)

    XCTAssertNotEqual(email1, email2)
    XCTAssertNotEqual(email11, email2)
    XCTAssertNotEqual(email11, email22)

    XCTAssertEqual(email1.hashValue, email11.hashValue)
    XCTAssertEqual(email2.hashValue, email22.hashValue)
  }

  func testIsValidEmailString() {
    XCTAssertTrue(Email.isValidEmailString("email@email.com"))
    XCTAssertTrue(Email.isValidEmailString("email@email"))
    XCTAssertFalse(Email.isValidEmailString("email@"))
    XCTAssertFalse(Email.isValidEmailString("email"))
    XCTAssertFalse(Email.isValidEmailString("email"))
    XCTAssertFalse(Email.isValidEmailString(""))
    XCTAssertFalse(Email.isValidEmailString("@_asdf.com"))
  }

  func testHostVar() {
    let host = "email.com"
    let email = Email("name@" + host)!
    XCTAssertEqual(email.host, host)
  }

  func testNameVar() {
    let name = "name"
    let email = Email(name + "@email.com")!
    XCTAssertEqual(email.name, name)
  }
}
