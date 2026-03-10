# Absa iOS Banking App — Claude Code Guidelines

This file describes the architecture, design patterns, coding style, and conventions used by the Absa iOS Banking App team. Always follow these guidelines when generating or modifying Swift code for this project.

---

## Architecture Overview

The app uses a combination of **EBI (Entity Boundary Interactor)** and **MVVM (Model View ViewModel)** patterns, combined with a **modular component design pattern**.

### Layered Structure (top to bottom)

```
Backend Services (BMG / Express)
        ↓
App Networking Layers (BankKit / ABANetworkKit)
        ↓
Interactors (WebService-based / Express-based)
  ↕ Request/Response Models (DTOs)
ViewModel  ← Business Logic lives here
        ↓
ViewController
        ↓
ABAReusableKit / ABACoreKit Components
        ↓
User Interface
```

- **ViewControllers** compose UI using components from `ABACoreKit`
- Each **ViewController** owns a **ViewModel** that contains all business logic for that screen
- Unit tests should target the **ViewModel**, not the ViewController
- The **ViewModel** must never talk directly to any backend API
- **Interactors** are responsible for all backend communication
- All **Express** calls must route through `ABANetworkKit`
- All **BMG** calls must route through `BankKit`

---

## Design Patterns

### Delegate Pattern
Use delegation to extend class behaviour via composition rather than inheritance. This is used throughout UIKit and Foundation. When a class needs the assistance of another object, prefer delegation. Always favour **composition over inheritance**.

### Entity Boundary Interactor (EBI)

Three primary components:

- **Entity (Model):** Core business objects with application-independent business rules. No context-specific knowledge. Called "Models" in the iOS app.
- **Boundary (Protocol):** Defines the functional interface. Accepts requests and produces responses. Defined as protocols.
- **Interactor:** Concrete implementation of a Boundary. Accepts requests, returns responses, manipulates application state. All business logic for a feature is encapsulated here.

Request/Response data is passed as simple **Data Transfer Objects (DTOs)**.

### MVVM

- The **Model** holds data
- The **View** (ViewController) displays data and forwards user actions
- The **ViewModel** holds all business logic; it transforms model data into view-ready state and communicates with Interactors

### Key Rules
- Never call an Interactor directly from a ViewController — always go through the ViewModel
- Inject all ViewModel dependencies via `init` to support unit testing
- Do not build a ViewModel that auto-fetches on initialisation — the ViewController decides when to fetch
- Avoid creating new "Managers" — they are an anti-pattern. Use existing ones only where necessary

---

## First-Party Frameworks

### ABACoreKit
- Home of all UI components
- Each component is self-contained with its own formatting and sizing logic
- Built on Apple's `UIKit`, written in Swift
- Components use properly constrained `UIStackView`s with intrinsic content size
- Always use `ABACoreKit` components instead of standard UIKit components wherever possible
- Do not add or change styling (colours, fonts, sizes) — components already contain the correct styling

### ABANetworkKit
- Core networking framework built in Swift using Apple's networking APIs and `async/await`
- Handles all Express service calls, HMAC security logic, and general networking
- All web service calls (except BMG) must route through `ABANetworkKit`
- At its core is a `URLSession` call

### BankKit
- Objective-C based framework, handles all BMG (Barclays Mobile Gateway) service calls
- Manages request queuing, encryption/decryption, nVal/iVal states
- **Deprecated — all future service development must use Express via ABANetworkKit**

---

## Third-Party Frameworks

| Framework | Purpose |
|---|---|
| TransaktSDK | Connects to Entersekt's secure backend for 2FA |
| IMIConnectCoreSDK | In-app messages |
| iiDENTIFii frameworks | Biometric Authentication (BioCheck) |
| Lottie | JSON-based animations |
| Adobe frameworks | Analytics |
| ScanToPay | QR payments |
| tas frameworks | IBM SDKs for device profiling |

---

## UI Guidelines

- Always use `ABACoreKit` components instead of standard UIKit components
- Components are built with `UIStackView`s and a declarative UI pattern — leverage this
- For small or static lists, prefer `UIStackView` over `UITableView`
- Use `UITableView` / `UICollectionView` only when you have many repeated cells (hundreds or more) and need cell reuse
- Components are optimised to live inside `UIStackView`s

---

## Coding Style & Conventions

### Fundamentals
- **Clarity over brevity** — clear, readable code is the primary goal
- Types, variables, and methods are declared once; the name should be meaningful where it is *used*, not just where it is *declared*
- Spell names out fully — no meaningless abbreviations (e.g. `ViewController` not `VC`)
- Accepted abbreviations: `HTTP`, `URL`, `ID`, etc. (commonly understood)

### Naming

#### General
- Names must be **meaningful** and as long as necessary to convey intent
- Include all necessary words; remove words that add no value (`as`, `the`, `for`, `of`, `with`, `and`)
- Variables, Types, and Parameters are named by the **role they play**, not their type

#### Type Names (classes, structs, enums, protocols)
- Always start with an **uppercase** letter
- Use `camelCase`
- No underscores
- No three-letter prefix (e.g. not `ABAPaymentDetails` — use `PaymentDetails`)

#### Property Names
- Always start with a **lowercase** letter
- `camelCase`, no underscores
- Boolean properties should read as an assertion: `isActivated`, `shouldBeActivated`, `wasActivated`
- Getters are NOT prefixed with `get` — getter is called `name`, setter is called `setName`

#### Method Names
- Start with a **lowercase** letter, `camelCase`
- Should start with a verb or a getter/setter noun phrase
- No underscores
- Boolean methods should read as an assertion about the property
- Avoid using names that return something AND have a side effect — use a noun if it returns, a verb if it acts

#### Model Naming
- Model names should describe **what the model will contain** (typically the actual model struct/class)
- A representation of a model should **not** end in "Model" (e.g. use `request`, not `requestModel`)
- Variable names should be named after the model's role, not its type

#### Protocol Names
- Protocols describing what something **is**: use a noun (e.g. `Collection`, `UITableViewDataSource`)
- Protocols describing a **capability**: use suffixes `able`, `ible`, `ing` (e.g. `Equatable`, `Hashable`)

### Coding Style

#### File Structure (class/struct)
Order methods and declarations as follows:
1. Variable declarations (private first, then public)
2. Initialisers
3. Lifecycle methods & `@IBActions` (inside ViewControllers, group lifecycle events together, group all `@IBActions` together)
4. Void methods / functions
5. Setters
6. Getters
7. Computed properties / variables
8. Private methods / functions
9. Extensions used for protocol conformance
10. File-private extensions

#### `// MARK:` Comments
Use `// MARK:` to categorise methods in class/struct files. Refer to the IOS Project Structure for examples.

#### Extensions
- Prefer extensions over subclassing where possible
- Use extensions to subscribe to protocols — keeps code clean and easy to read
- Marking classes as `final` until you know you need to override prevents unwanted subclassing
- The main advantage of structs in Swift is memory efficiency (passed by copy); always try to use structs wherever possible. Use a class when the model must modify its own internal variables.

#### Lazy Variables
- Use `lazy` variables where the default value is available but not immediately needed

### Whitespace
- Single-line getters and setters are acceptable (100% acceptable)
- Do not exceed **140 characters per line**
- Use whitespace judiciously to improve readability — do not blindly add blank lines everywhere
- No more than **one blank line** between methods declared on a class
- In `enum`, `struct`, and `class` bodies: always add a space before the first `{`

### Indentation & Braces
- Use **4 spaces** (not tabs) — configure Xcode: Preferences → Editing → Indentation → 4 spaces
- K&R formatting: `if` / `else` clauses are **always surrounded by braces**, even when not required
- Opening brace is on the **same line** as the statement
- `else` is on the same line as the `if`'s closing brace

```swift
// Correct
if someCondition {
    someObject.doSomething()
} else {
    someObject.doSomethingElse()
}

// Incorrect — never do this
if someCondition
    someObject.doSomething()
```

### Conditionals

#### If statements
- Always use braces — even for single-line bodies
- Opening brace on same line as `if`
- `else` on same line as closing `}`

#### Ternary Operators
- Only use for **simple, single-value assignments**
- The full if-statement must fit on fewer than 100 characters when converted to ternary
- Do **not** use ternary operators to call functions — use a full `if/let` instead
- Never chain ternaries

```swift
// Acceptable
let result = testCondition ? valueA : valueB

// Never do this
let someResult = viewModel.lookupValue(using: testCondition) == "my value" ? "something" : "somethingElse"
```

#### Switch as Expression
You may use `if/let` switch statements as expressions:

```swift
let someValue = switch someEnum {
    case typeA: valueA
    default: adoptionalValue + somethingElse
}
```

### Trailing Closure Syntax
Prefer **Trailing Closure Syntax** for cleaner, more readable code. Default all `success` calls first, `failure` last.

```swift
// Preferred
func performPayment(_ payment: PaymentModel) {
    interactor.performPayment(payment) {
        delegate?.paymentSuccessful()
    } failure: { [weak self] error in
        delegate?.showErrorMessage(error)
    }
}
```

Do not use trailing closures when the closure is empty or nil.

### Comments
- Code should be **self-documenting** — comments should explain *why*, not *what*
- Block comments should be avoided; code should be self-explanatory
- Any comments that are kept must be up-to-date; stale comments must be deleted
- **Do not comment out code** — use source control instead
- Add documentation to all kits/reusable components/objects/functions following Apple's documentation standards: https://www.swift.org/documentation/docc/writing-symbol-documentation-in-your-source-files

### Properties

#### Declaring Properties
- Always declare properties as `optional` (`?`) where possible
- Initialise variables in-line where possible — avoid force-unwrapping
- Always unwrap optionals safely; be extremely careful with force-unwrapping (`!`)
- It is best practice to declare ViewModel properties as `lazy stored properties`

#### Explicitly Declaring Attributes
- Declare `private` on all variables where appropriate
- UI variables (labels, buttons, views) should be declared as `private`
- If you need a setter but only need a getter externally, use `private(set)`

#### `self`
- Use `self` where needed, as needed
- Inside closures, use `[weak self]` to prevent retain cycles — avoid using explicit `self` (unnamed self)
- In `UIView`s, `self` provides much needed context — use it
- In `UIViewController`s, `self` is not always needed

#### Instance Variables
- Should always be as private as possible
- If you need a setter and getter: use a property
- UI variables should be `private` and declared with `private lazy var` to prevent coupling with the parent class

### Constants
- Prefer constants (`let`) over inline string literals or magic numbers
- Constants can be quickly changed without find-and-replace
- Should only be used when a value will be used more than four times

### Enumerated Types
- Use Swift's fixed underlying type specification for enums when recommended
- In Swift, enum cases are written in `camelCase`
- When using enums, use the new fixed underlying type for stronger type checking

### Init Methods
- Follow the standard defined by Apple
- For `struct` — follow the example (no `super`)
- For `class` — initialise the class first then call `super`

### Methods
- Smaller, focused methods promote reuse
- Methods should ideally be 20 lines or fewer (guideline, not absolute rule)
- If methods exceed this, consider refactoring

### Use of `return`
- Use `return` only if it runs over 2 lines
- A single line is acceptable without `return` (150 characters or less)

### Cleaning Up Code
- As with all large code bases, continuously improve upon older work — boy scout rule
- If you touch a file, clean it up; if you touch the entire repo, clean it all up
- Don't go beyond reason

### `prepare(for:)` — Deprecated
- Do not use `prepare(for:)` segue — it is deprecated
- Most flows use a `BaseFlowViewController` to handle data transportation between screens
- Use `BaseFlowViewController` to pass relevant data models between flow screens

---

## async/await & Concurrency

The team has embraced Swift's `async/await` for concurrency:

```swift
// Preferred — async/await
func fetchRecentTransactions(limit: Int) {
    Task {
        do {
            self.transactions = try await interactor
                .fetchTransactionHistory(for: accountNumber, limit: limit)
            delegate?.refreshViewContents()
        } catch {
            delegate?.showErrorMessage(error.localizedDescription)
        }
    }
}
```

- For network/service calls, prefer `throws` to propagate errors to the caller
- You may also use `Result<SuccessType, Error>` when cleaner for your use case
- Legacy completion block / closure style is retained in older features — do not introduce it in new code

---

## Sample EBI + MVVM Feature Structure

When implementing a new feature, follow this structure:

### 1. Define your Models (Entities)
```swift
// Keep request/response models fileprivate — only the Interactor needs them
fileprivate struct RequestModel: ABABaseRequestModel {
    var header = ABABaseRequestHeader()
    var accountNumber: String
}

fileprivate struct ResponseModel: ABABaseResponseModel {
    var header: ABABaseResponseHeader
    var transactions: [TransactionModel]
}

// Transportation model — safe to pass to UI layer
struct TransactionModel: Codable {
    var description: String = ""
    var rawAmount: String = ""
    var date: Date = Date()
    var amount: ABAAmountModel { ABAAmountModel(amountString: rawAmount) }
}
```

### 2. Define the Boundary (Protocol)
```swift
protocol TransactionHistoryBoundary {
    func fetchTransactionHistory(for accountNumber: String, limit: Int) async throws -> [TransactionModel]
}
```

### 3. Implement the Interactor
```swift
final class TransactionHistoryInteractor: XTMSInteractable, TransactionHistoryBoundary {
    func fetchTransactionHistory(for accountNumber: String, limit: Int) async throws -> [TransactionModel] {
        let request = RequestModel(accountNumber: accountNumber)
        let response: ResponseModel = try await xtmsInteractor.post(request: request)
        return readResponse(response, limit: limit) ?? []
    }
}
```

### 4. Implement the ViewModel
```swift
final class TransactionHistoryViewModel {
    private weak var delegate: BaseViewModelDelegate?
    private var interactor: TransactionHistoryBoundary
    private var accountNumber: String
    private lazy var transactions = [TransactionModel]()

    let initialTransactionLimit = 30

    init(delegate: BaseViewModelDelegate,
         interactor: TransactionHistoryBoundary,
         accountNumber: String) {
        self.delegate = delegate
        self.interactor = interactor
        self.accountNumber = accountNumber
    }

    var transactionCount: Int { transactions.count }

    func fetchRecentTransactions(limit: Int) {
        Task {
            do {
                self.transactions = try await interactor
                    .fetchTransactionHistory(for: accountNumber, limit: limit)
                delegate?.refreshViewContents()
            } catch {
                delegate?.showErrorMessage(error.localizedDescription)
            }
        }
    }
}
```

### 5. Implement the ViewController
```swift
final class TransactionHistoryViewController: BaseViewController {

    // MARK: - Properties
    private lazy var tableView = ABAIntrinsicTableView()
    var viewModel: TransactionHistoryViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTransactions(limit: viewModel.initialTransactionLimit)
    }

    override func setupComponents() {
        tableView.register(TransactionHistoryTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self

        stack.addComponents([
            ABATitleAndDescriptionView()
                .titleLocalizationKey("Transaction history"),
            tableView
        ])
    }

    override func refreshViewContents() {
        DispatchQueue.main.async { [weak self] in
            self?.showLoadingIndicator(false)
            self?.tableView.animatedReloadAllSections()
        }
    }

    // MARK: - Private
    private func fetchTransactions(limit: Int) {
        showLoadingIndicator(true)
        viewModel.fetchRecentTransactions(limit: limit)
    }
}

// MARK: - TableView
extension TransactionHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactionCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TransactionHistoryTableViewCell.self, for: indexPath)
        let content = viewModel.transformTransaction(at: indexPath.row)!
        cell.populate(content)
        return cell
    }
}
```

---

## Anti-Patterns to Avoid

- ❌ Do not create new "Managers" — they are anti-patterns
- ❌ Do not call Interactors directly from ViewControllers
- ❌ Do not let the ViewModel talk directly to backend APIs
- ❌ Do not use `prepare(for segue:)` — deprecated
- ❌ Do not use `UITableView` for small/static lists — use `UIStackView`
- ❌ Do not introduce new BMG/BankKit service calls — use Express/ABANetworkKit
- ❌ Do not use completion block closures in new code — use `async/await`
- ❌ Do not force-unwrap (`!`) without a strong justification
- ❌ Do not comment out code — delete it and use source control
- ❌ Do not add or override styling in components — ABACoreKit handles all styling
- ❌ Do not misuse ternary operators for function calls or complex expressions
- ❌ Do not exceed 140 characters per line
- ❌ Do not use tabs — use 4 spaces

---

## References

- Swift Programming Language Guide: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/
- Apple Swift API Design Guidelines: https://swift.org/documentation/api-design-guidelines/
- Swift Conventions (Objective-C): https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Conventions/Conventions.html
- Improving Coding Practices: https://developer.apple.com/videos/play/wwdc/improving-code-efficiency-with-good-coding-practices/
- Clean Code (Robert C. Martin): recommended reading
- Trailing Closures: https://docs.swift.org/swift-book/LanguageGuide/Closures.html
- Swift Protocols: https://docs.swift.org/swift.org/swift-book/LanguageGuide/Protocols.html
- EBI Pattern: http://ebi.readthedocs.io/en/latest/index.html
- MVVM Pattern: https://en.wikipedia.org/wiki/Model–view–viewmodel
- Delegate Pattern: https://en.wikipedia.org/wiki/Delegation_pattern
- Symbol Documentation: https://www.swift.org/documentation/docc/writing-symbol-documentation-in-your-source-files
