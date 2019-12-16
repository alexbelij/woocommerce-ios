import UIKit

struct UnitInputViewModel {
    let title: String
    let unit: String
    let value: String?
    let inputFormatter: UnitInputFormatter
    let onInputChange: ((_ input: String?) -> Void)?
}

/// Displays a title, an editable text field for user input and the unit of the text field value.
///
final class UnitInputTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var inputAndUnitStackView: UIStackView!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var unitLabel: UILabel!

    private var inputFormatter: UnitInputFormatter?
    private var onInputChange: ((_ input: String?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        configureTitleLabel()
        configureInputAndUnitStackView()
        configureInputTextField()
        configureUnitLabel()
        applyDefaultBackgroundStyle()
    }

    func configure(viewModel: UnitInputViewModel) {
        titleLabel.text = viewModel.title
        unitLabel.text = viewModel.unit
        inputTextField.text = viewModel.value
        inputFormatter = viewModel.inputFormatter
        onInputChange = viewModel.onInputChange
    }
}

private extension UnitInputTableViewCell {
    func configureTitleLabel() {
        titleLabel.applyBodyStyle()
    }

    func configureInputAndUnitStackView() {
        inputAndUnitStackView.spacing = 6
    }

    func configureInputTextField() {
        inputTextField.borderStyle = .none
        inputTextField.applyBodyStyle()
        inputTextField.textAlignment = .right
        inputTextField.keyboardType = .decimalPad
        inputTextField.delegate = self
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    func configureUnitLabel() {
        unitLabel.applyBodyStyle()
    }
}

extension UnitInputTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
            let textRange = Range(range, in: text) else {
                                                        return false
        }
        let updatedText = text.replacingCharacters(in: textRange,
                                                   with: string)
        return inputFormatter?.isValid(input: updatedText) == true
    }
}

private extension UnitInputTableViewCell {
    @objc func textFieldDidChange(textField: UITextField) {
        let formattedText = inputFormatter?.format(input: textField.text)
        textField.text = inputFormatter?.format(input: formattedText)
        onInputChange?(formattedText)
    }
}
