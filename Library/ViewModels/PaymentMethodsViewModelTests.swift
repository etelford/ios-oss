// swiftlint:disable force_unwrapping

import Foundation
import XCTest
import ReactiveSwift
import Result
@testable import KsApi
@testable import Library
@testable import ReactiveExtensions_TestHelpers
import Prelude

internal final class PaymentMethodsViewModelTests: TestCase {

  let vm = PaymentMethodsViewModel()
  let didFetchPaymentMethods = TestObserver<[GraphUserCreditCard.CreditCard], NoError>()
  let goToAddCardScreen = TestObserver<Void, NoError>()

  internal override func setUp() {
    super.setUp()

    self.vm.outputs.didFetchPaymentMethods.observe(didFetchPaymentMethods.observer)
    self.vm.outputs.goToAddCardScreen.observe(goToAddCardScreen.observer)

  }

  func testPaymentMethodsFetch_OnViewDidLoad() {

    let response = UserEnvelope<GraphUserCreditCard.CreditCard>(
      me: GraphUserCreditCard.template.storedCards.nodes.first!
    )
    let apiService = MockService(fetchGraphCreditCardsResponse: response)
    withEnvironment(apiService: apiService) {

      self.vm.inputs.viewDidLoad()
      self.scheduler.advance()

      self.didFetchPaymentMethods.assertValues([GraphUserCreditCard.template.storedCards.nodes])
    }
  }

  func testGoToAddCardScreenEmits_WhenAddNewCardIsTapped() {

    self.goToAddCardScreen.assertValueCount(0)

    self.vm.inputs.didTapAddNewCardButton()

    self.goToAddCardScreen.assertValueCount(1, "Should emit after tapping button")
  }
}
