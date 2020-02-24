import UIKit
import Gridicons


// MARK: - OrderNoteTableViewCell
//
class OrderNoteTableViewCell: UITableViewCell {

    /// Top Left Icon
    ///
    @IBOutlet private var iconButton: UIButton!

    /// Top Right Label
    ///
    @IBOutlet private var statusLabel: UILabel!

    /// Bottom Label
    ///
    @IBOutlet private var noteLabel: UILabel!


    // MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        configureBackground()
        configureLabels()
        configureIconButton()
    }

    /// Indicates if the note is visible to the Customer (or it's set to private!)
    ///
    var isCustomerNote: Bool = false {
        didSet {
            noteTypeWasUpdated()
        }
    }

    /// Indicates if the note was generated by the system
    ///
    var isSystemAuthor: Bool = false {
        didSet {
            noteTypeWasUpdated()
        }
    }

    var author: String? {
        didSet {
            noteTypeWasUpdated()
        }
    }

    var dateCreated: String? {
        didSet {
            noteTypeWasUpdated()
        }
    }

    /// Note's Payload
    ///
    var contents: String? {
        get {
            return noteLabel.text
        }
        set {
            noteLabel.text = newValue
        }
    }
}


// MARK: - Private Methods
//
private extension OrderNoteTableViewCell {

    /// Updates the Status Label + Icon's Color
    ///
    func noteTypeWasUpdated() {
        let theAuthor = author ?? ""
        let dateOfCreation = dateCreated ?? ""
        if isCustomerNote {
            iconButton.backgroundColor = .primary
            let template =
                NSLocalizedString("%1$@ - %2$@ (To Customer)",
                                  comment: "Labels an order note. The user know it's visible to the customer. Reads like 05:30 PM - username (To Customer)")
            statusLabel.text = String.localizedStringWithFormat(template, dateOfCreation, theAuthor)
        } else if isSystemAuthor {
            iconButton.backgroundColor = .listSmallIcon
            let template =
                NSLocalizedString("%1$@ - %2$@ (System)",
                                  comment: "Labels an order note. The user know it's a system status message. Reads like 05:30 PM - username (System)")
            statusLabel.text = String.localizedStringWithFormat(template, dateOfCreation, theAuthor)
        } else {
            iconButton.backgroundColor = .textSubtle
            let template =
                NSLocalizedString("%1$@ - %2$@ (Private)",
                                  comment: "Labels an order note. The user know it's not visible to the customer. Reads like 05:30 PM - username (Private)")
            statusLabel.text = String.localizedStringWithFormat(template, dateOfCreation, theAuthor)
        }
    }

    func configureBackground() {
        applyDefaultBackgroundStyle()
    }

    /// Setup: Labels
    ///
    func configureLabels() {
        statusLabel.applyBodyStyle()
        statusLabel.textColor = .textSubtle
        noteLabel.applyBodyStyle()
    }

    /// Setup: Icon Button
    ///
    func configureIconButton() {
        iconButton.setImage(.asideImage, for: .normal)
        iconButton.layer.cornerRadius = iconButton.frame.width / 2
        iconButton.tintColor = .neutral(.shade0)
    }
}
