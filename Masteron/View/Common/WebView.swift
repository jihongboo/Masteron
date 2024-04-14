//
//  WebView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.06.08.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    private let webView: WKWebView
    private let HTMLString: String?
    
    init(HTMLString: String) {
        webView = WKWebView(frame: .zero)
        self.HTMLString = HTMLString
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let HTMLString {
            webView.loadHTMLString(generateHTML(body: HTMLString), baseURL: nil)
        }
    }
    
    private func generateHTML(body: String) -> String {
        return """
<!doctype html>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1">
<html>
    <head>
        <style>
            body {
                font-size: 16px;
                font-family: "-apple-system"
            }
        </style>
    </head>
    <body>
        \(body)
    </body>
</html>
"""
    }
}

#Preview {
    WebView(HTMLString: "<p>Please mind that the <a href=\"mailto:staff@mastodon.social\">staff@mastodon.social</a> e-mail is for inquiries related to the operation of the mastodon.social server specifically. If your account is on another server, <strong>we will not be able to assist you</strong>. For inquiries not related specifically to the operation of this server, such as press inquiries about Mastodon gGmbH, please contact <a href=\"mailto:press@joinmastodon.org\">press@joinmastodon.org</a>. Additional addresses:</p>\n\n<ul>\n<li>Legal, GDPR, DMCA: <a href=\"mailto:legal@mastodon.social\">legal@mastodon.social</a></li>\n<li>Appeals: <a href=\"mailto:moderation@mastodon.social\">moderation@mastodon.social</a></li>\n</ul>\n\n<h2>Funding</h2>\n\n<p>This server is crowdfunded by <a href=\"https://patreon.com/mastodon\">Patreon donations</a>. For a list of sponsors, see <a href=\"https://joinmastodon.org/sponsors\">joinmastodon.org</a>.</p>\n\n<h2>Reporting and moderation</h2>\n\n<p>When reporting accounts, please make sure to include at least a few posts that show rule-breaking behaviour, when applicable. If there is any additional context that might help make a decision, please also include it in the comment. This is especially important when the content is in a language nobody on the moderation team speaks.</p>\n\n<p>We usually handle reports within 24 hours. Please mind that you are not notified when a report you have made has led to a punitive action, and that not all punitive actions are externally visible. For first time offenses, we may opt to delete offending content, escalating to harsher measures on repeat offenses.</p>\n\n<p>We have a team of paid moderators. If you would like to become a moderator, get in touch with us through the e-mail address above.</p>\n\n<h2>Impressum</h2>\n\n<p>Mastodon gGmbH<br>\nMühlenstraße 8a<br>\n14167 Berlin<br>\nGermany</p>\n\n<p>E-Mail-Adresse: hello@joinmastodon.org</p>\n\n<p>Vertretungsberechtigt: Eugen Rochko (Geschäftsführer)</p>\n\n<p>Umsatzsteuer Identifikationsnummer (USt-ID): DE344258260</p>\n\n<p>Handelsregister<br>\nGeführt bei: Amtsgericht Charlottenburg<br>\nNummer: HRB 230086 B</p>\n")
}
