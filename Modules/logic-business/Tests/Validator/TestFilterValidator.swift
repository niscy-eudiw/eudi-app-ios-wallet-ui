/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
import Combine
@testable import logic_business
@testable import logic_test
import Testing

final class TestFilterValidator: EudiTest {
  var filterValidator: FilterValidator!

  override func setUp() {
    super.setUp()
    self.filterValidator = FilterValidatorImpl()
  }

  override func tearDown() {
    filterValidator = nil
    super.tearDown()
  }

  func testInitializeValidator() async {
    // Given
    let expectedFilters = filtersWithSingleSelection
    let expectedFilterableList = filterableList

    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    // When
    guard let filterValidatorImpl = filterValidator as? FilterValidatorImpl else {
      XCTFail("FilterValidator should be of type FilterValidatorImpl")
      return
    }
    let appliedFilters = await filterValidatorImpl.appliedFiltersForTesting

    // Then
    XCTAssertEqual(
      appliedFilters.filterGroups.count,
      expectedFilters.filterGroups.count
    )
  }

  func testInitializeValidatorApplyFiltersEmitsFilterApplyResult() async {
    // Given
    let expectedFilters = filtersWithSingleSelection
    let expectedFilterableList = filterableList

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applyFilters(sortOrder: .ascending)

    var emittedState: FilterResultPartialState?
    let stream = filterValidator.getFilterResultStream()

//    Task {
      for await state in stream {
        emittedState = state
        break
      }

      // Then
      guard let emittedState = emittedState else {
        XCTFail("No value was emitted from the filter result stream")
        return
      }

      switch emittedState {
      case .success(let result):
        switch result {
        case .filterApplyResult(_, let updatedFilters, _):
          XCTAssertEqual(updatedFilters.filterGroups.count, expectedFilters.filterGroups.count)
        default:
          XCTFail("Unexpected result type received: \(result)")
        }
      case .completion:
        XCTFail("Expected a filter update result but received completion.")
      }
//    }
  }

  func testInitializeValidatorWhenCalledTwiceThenEmitsMergedFilterUpdate() async {
    // Given
    let expectedFilters = filtersWithSingleSelection
    let expectedFilterableList = filterableList

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applyFilters(sortOrder: .ascending)

    var emittedState: FilterResultPartialState?
    let stream = filterValidator.getFilterResultStream()

    Task {
      for await state in stream {
        emittedState = state
        break
      }

      // Then
      guard let emittedState = emittedState else {
        XCTFail("No value was emitted from the filter result stream")
        return
      }

      switch emittedState {
      case .success(let result):
        switch result {
        case .filterApplyResult(_, let updatedFilters, _):
          XCTAssertEqual(updatedFilters.filterGroups.count, expectedFilters.filterGroups.count)
        default:
          XCTFail("Unexpected result type received: \(result)")
        }
      case .completion:
        XCTFail("Expected a filter update result but received completion.")
      }
    }

    func testInitializeValidatorCalledTwiceWithDifferentFiltersThenEmitsMergedFilterUpdate() async {
      // Given
      let initialFilters = filtersWithMultipleSelectionSize3
      let updatedFilters = filtersWithMultipleSelectionSize4

      let expectedFilterableList = filterableList

      // When
      await filterValidator.initializeValidator(
        filters: initialFilters,
        filterableList: expectedFilterableList
      )
      await filterValidator.initializeValidator(
        filters: updatedFilters,
        filterableList: expectedFilterableList
      )

      await filterValidator.applyFilters(sortOrder: .ascending)

      var emittedState: FilterResultPartialState?
      let stream = filterValidator.getFilterResultStream()

      Task {
        for await state in stream {
          emittedState = state
          break
        }

        // Then
        guard let emittedState = emittedState else {
          XCTFail("No value was emitted from the filter result stream")
          return
        }

        switch emittedState {
          case .success(let result):
            switch result {
              case .filterApplyResult(_, let updatedFilters, _):
                XCTAssertEqual(
                  updatedFilters.filterGroups.first?.filters.first?.selected,
                  initialFilters.filterGroups.first?.filters.first?.selected
                )
                XCTAssertEqual(
                  updatedFilters.filterGroups.first?.filters.count,
                  initialFilters.filterGroups.first?.filters.count
                )
              default:
                XCTFail("Unexpected result type received: \(result)")
            }
          case .completion:
            XCTFail("Expected a filter update result but received completion.")
        }
      }
    }
  }

  func testUpdateListWhenApplyFiltersCalledThenEmitsCorrectFilterUpdate() async {
    // Given
    let expectedFilters = filtersWithSingleSelection
    let expectedFilterableList = filterableList

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.updateLists(
      sortOrder: .ascending,
      filterableList: expectedFilterableList
    )
    await filterValidator.applyFilters(sortOrder: .ascending)

    var emittedState: FilterResultPartialState?
    let stream = filterValidator.getFilterResultStream()

    Task {
      for await state in stream {
        emittedState = state
        break
      }

      // Then
      guard let emittedState = emittedState else {
        XCTFail("No value was emitted from the filter result stream")
        return
      }

      switch emittedState {
      case .success(let result):
        switch result {
        case .filterApplyResult(_, let updatedFilters, _):
            XCTAssertEqual(
              updatedFilters.filterGroups.first?.filters.count,
              expectedFilters.filterGroups.first?.filters.count
            )
        default:
          XCTFail("Unexpected result type received: \(result)")
        }
      case .completion:
        XCTFail("Expected a filter update result but received completion.")
      }
    }
  }

  func testUpdateFiltersWhenCalledThenEmitsCorrectFilterUpdate() async {
    // Given
    let expectedFilters = filtersWithSingleSelection
    let expectedFilterableList = filterableList

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.updateFilter(
      filterGroupId: singleSelectionGroup.id,
      filterId: filterItemsSingle[2].id
    )

    var emittedState: FilterResultPartialState?
    let stream = filterValidator.getFilterResultStream()

    Task {
      for await state in stream {
        emittedState = state
        break
      }

      // Then
      guard let emittedState = emittedState else {
        XCTFail("No value was emitted from the filter result stream")
        return
      }

      switch emittedState {
      case .success(let result):
        switch result {
        case .filterApplyResult(_, let updatedFilters, _):
            let updated = updatedFilters.filterGroups.first
            XCTAssertTrue(updated?.filters.first { $0.id == filterItemsSingle[2].id }?.selected ?? false)
        default:
          XCTFail("Unexpected result type received: \(result)")
        }
      case .completion:
        XCTFail("Expected a filter update result but received completion.")
      }
    }
  }

  func testApplyFiltersWhenFiltersHaveZeroSelectionsThenEmitsFilterApplyResult() async {
    // Given
    let expectedFilters = filtersWithMultipleSelectionNoSelection
    let expectedFilterableList = filterableList

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applyFilters(sortOrder: .ascending)

    var emittedState: FilterResultPartialState?
    let stream = filterValidator.getFilterResultStream()

    Task {
      for await state in stream {
        emittedState = state
        break
      }

      // Then
      guard let emittedState = emittedState else {
        XCTFail("No value was emitted from the filter result stream")
        return
      }

      switch emittedState {
      case .success(let result):
        switch result {
        case .filterApplyResult:
          XCTAssertTrue(true)
        default:
          XCTFail("Unexpected result type received: \(result)")
        }
      case .completion:
        XCTFail("Expected a filter update result but received completion.")
      }
    }
  }

  func testApplySearchWhenInvalidQueryThenEmitsFilterListEmptyResult() async {
    // Given
    let expectedFilters = filtersWithMultipleSelectionAllSelected
    let expectedFilterableList = filterableList

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applySearch(query: "invalid_search")

    var emittedState: FilterResultPartialState?
    let stream = filterValidator.getFilterResultStream()

    Task {
      for await state in stream {
        emittedState = state
        break
      }

      // Then
      guard let emittedState = emittedState else {
        XCTFail("No value was emitted from the filter result stream")
        return
      }

      switch emittedState {
      case .success(let result):
        switch result {
        case .filterApplyResult(_, let updatedFilters, _):
          XCTAssertTrue(updatedFilters.isEmpty)
        default:
          XCTFail("Unexpected result type received: \(result)")
        }
      case .completion:
        XCTFail("Expected a filter update result but received completion.")
      }
    }
  }

  func testApplySearchWhenQueryProvidedThenEmitsFilterApplyResult() async {
    // Given
    let expectedFilters = filtersWithMultipleSelectionAllSelected
    let expectedFilterableList = filterableList

    // When
    await filterValidator.initializeValidator(
      filters: expectedFilters,
      filterableList: expectedFilterableList
    )

    await filterValidator.applySearch(query: "secondary text")

    var emittedState: FilterResultPartialState?
    let stream = filterValidator.getFilterResultStream()

    Task {
      for await state in stream {
        emittedState = state
        break
      }

      // Then
      guard let emittedState = emittedState else {
        XCTFail("No value was emitted from the filter result stream")
        return
      }

      switch emittedState {
      case .success(let result):
        switch result {
        case .filterApplyResult(let filterableList, let updatedFilters, _):
          XCTAssertEqual(filterableList.items.count, 1)
        default:
          XCTFail("Unexpected result type received: \(result)")
        }
      case .completion:
        XCTFail("Expected a filter update result but received completion.")
      }
    }
  }
}
