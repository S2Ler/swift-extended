import Foundation
import UIKit

/// Allows creating NSAttributedStrings with builder like API.
public final class AttributedStringBuilder {
    private var storage = NSMutableAttributedString()

    public init() {}

    /// Resets builder state
    @discardableResult
    public func reset() -> AttributedStringBuilder {
        storage = NSMutableAttributedString()
        return self
    }

    /// Makes copy of current attributedString.
    public func build() -> NSAttributedString {
        return storage.copy() as! NSAttributedString
    }

    @discardableResult
    public func append(_ string: String,
                       font: UIFont? = nil,
                       color: UIColor? = nil,
                       letterSpacing: CGFloat? = nil,
                       adjustParagraph: ((NSMutableParagraphStyle) -> Void)? = nil,
                       adjustAttributes: ((inout [NSAttributedString.Key: Any]) -> Void)? = nil) -> Self {
        var attributes: [NSAttributedString.Key: Any] = [:]

        if let font = font {
            attributes[.font] = font
        }

        if let color = color {
            attributes[.foregroundColor] = color
        }

        if let letterSpacing = letterSpacing {
            attributes[.kern] = letterSpacing
        }

        if let adjustParagraph = adjustParagraph {
            let paragraph = NSMutableParagraphStyle()
            adjustParagraph(paragraph)
            attributes[.paragraphStyle] = paragraph
        }

        adjustAttributes?(&attributes)

        return append(NSAttributedString(string: string, attributes: attributes))
    }

    @discardableResult
    public func append(_ attributedString: NSAttributedString) -> Self {
        self.storage.append(attributedString)
        return self
    }

    /// Appends `image` and move it by `verticalDisposition` points down
    @discardableResult
    public func append(image: UIImage, tintColor: UIColor? = nil, verticalDisposition: CGFloat = 0) -> Self {
        let iconAttachment = NSTextAttachment()
        iconAttachment.bounds = CGRect(x: 0, y: verticalDisposition,
                                       width: image.size.width, height: image.size.height)
        iconAttachment.image = image
        let iconString = NSMutableAttributedString(attachment: iconAttachment)
        if let tintColor = tintColor {
            if #available(iOS 13, *) {
                iconString.addAttributes([.foregroundColor: tintColor], range: NSRange(location: 0, length: iconString.length))
            } else {
                // On <iOS13 we need to add a character with a foreground color before the image,
                // in order for the image to get a color.
                // Reference: https://stackoverflow.com/questions/29041458/how-to-set-color-of-templated-image-in-nstextattachment
                append("\0", color: tintColor)
            }
        }
        return append(iconString)
    }

    /// Breaks current line
    @discardableResult
    public func newLine(count: Int = 1) -> Self {
        return append(String(repeating: "\n", count: count))
    }

    /// Breaks current line and insert an empty line
    @discardableResult
    public func emptyLine() -> Self {
        return append("\n\n")
    }

    /// Adds `count` empty space chars
    @discardableResult
    public func space(count: Int = 1) -> Self {
        return append(String(repeating: " ", count: count))
    }

    /// Applies `attributes` for chars in `range`
    @discardableResult
    public func addAttributes(_ attributes: [NSAttributedString.Key: Any], range: NSRange) -> Self {
        storage.addAttributes(attributes, range: range)
        return self
    }
}
