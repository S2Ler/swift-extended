import Foundation
import UIKit

public final class DSLPickerViewController<Value: Equatable & CustomStringConvertible>: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIToolbarDelegate {
  // MARK: - DI

  public var onDoneHandler: ((DSLPickerViewController, Value?) -> Void)!
  public var onCancelHandler: ((DSLPickerViewController) -> Void)!

  // MARK: - UIViews
  public var toolbar: UIToolbar!
  public var picker: UIPickerView!

  // MARK: - Private Vars
  private let values: [Value]
  private let initialValue: Value?
  private let additionalToolbarItems: [UIBarButtonItem]?

  public init(values: [Value],
              selectedValue: Value?,
              additionalToolbarItems: [UIBarButtonItem]? = nil) {
    self.values = values
    self.initialValue = selectedValue
    self.additionalToolbarItems = additionalToolbarItems
    super.init(nibName: nil, bundle: nil)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func loadView() {
    let view = UIView()
    view.backgroundColor = .white

    picker = UIPickerView(frame: .zero)
    picker.translatesAutoresizingMaskIntoConstraints = false

    toolbar = UIToolbar(frame: .zero)
    toolbar.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(picker)
    view.addSubview(toolbar)

    toolbar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    toolbar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

    picker.topAnchor.constraint(equalTo: toolbar.bottomAnchor).isActive = true
    picker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    picker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    picker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

    let pickerPreferredHeight = picker.intrinsicContentSize.height
    let toolbarPreferredHeight = toolbar.intrinsicContentSize.height
    preferredContentSize = CGSize(width: 0, height: pickerPreferredHeight+toolbarPreferredHeight)

    self.view = view
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    func setupPicker() {
      picker.dataSource = self
      picker.delegate = self

      if let initialValue = initialValue,
         let initialValueIndex = values.firstIndex(of: initialValue) {
        picker.selectRow(initialValueIndex, inComponent: 0, animated: false)
      }
    }

    func setupToolbar() {
      /// we setup top layout guide here because it is not available in `loadView`
      toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

      let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone))

      var items = additionalToolbarItems ?? []
      items.append(flexibleSpace)
      items.append(doneButton)
      toolbar.items = items

      toolbar.delegate = self
    }

    setupPicker()
    setupToolbar()
  }

  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return values.count
  }

  public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 44
  }

  public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    AttributedStringBuilder()
      .append(values[row].description, font: nil, color: .white)
      .build()
  }

  // MARK: - Actions

  @objc
  private func onDone() {
    onDoneHandler(self, extractSelectedValue())
  }

  @objc
  private func onCancel() {
    onCancelHandler(self)
  }

  // MARK: - Data

  private func extractSelectedValue() -> Value? {
    let selectedRow = picker.selectedRow(inComponent: 0)
    if selectedRow < values.count {
      return values[selectedRow]
    } else {
      return nil
    }
  }

  public func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}
