//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

#if DEBUG
@available(iOS 15.0, *)
private struct PopupPreviews: View {
    private let L = Samples.Strings.locationAlert
    @Environment(\.theme) private var theme
    @State private var presentSystemAlert = false
    @State private var presentAlert = false
    @State private var presentAlertWithHeader = false
    @State private var presentToast = false
    @State private var presentWindow = false

    var body: some View {
        List {
            row(
                "Show System Alert",
                color: .blue,
                image: .appleLogo,
                toggle: $presentSystemAlert
            )

            row(
                "Show Alert",
                color: .indigo,
                image: .number1Circle,
                toggle: $presentAlert
            )

            row(
                "Show Alert with Header",
                color: .indigo,
                image: .number1Circle,
                toggle: $presentAlertWithHeader
            )

            ShowPartDetail()

            row(
                "Show Toast",
                color: .green,
                image: .number3Circle,
                toggle: $presentToast
            )

            row(
                "Show Window",
                color: .green,
                image: .macWindow,
                toggle: $presentWindow
            )
        }
        .navigationTitle("Popups")
        .alert(L.title, isPresented: $presentSystemAlert) {
            Button("OK") {
                presentSystemAlert = false
            }
        }
        .popup(L.title, message: L.message, isPresented: $presentAlert, dismissMethods: [.xmark, .tapOutside]) {
            Button("OK") {
                presentAlert = false
            }
            .buttonStyle(.fill)
        }
        .popup(isPresented: $presentAlertWithHeader) {
            StandardPopupAlert(Text(L.title), message: Text(L.message)) {
                Image(system: .locationSlashFill)
                    .resizable()
                    .frame(50)
            } footer: {
                Button("OK") {
                    presentAlertWithHeader = false
                }
                .buttonStyle(.fill)
            }
            .popupPreferredWidth(400)
        }
        .popup(isPresented: $presentToast, style: .toast) {
            CapsuleView("Z’s AirPods", subtitle: "Connected", systemImage: .airpods)
        }
        .window(isPresented: $presentWindow) {
            Button {
                presentWindow = false
            } label: {
                CapsuleView("Tap to Hide Window", systemImage: .macWindow)
                    .foregroundColor(.indigo)
            }
            .frame(height: 300)
            .padding(.s8)
            .backgroundColor(.systemBackground)
            .cornerRadius(AppConstants.tileCornerRadius)
        }
    }

    private func row(_ title: String, color: Color, image: SystemAssetIdentifier, toggle: Binding<Bool>) -> some View {
        Button {
            toggle.wrappedValue = true
        } label: {
            Label(title, systemImage: image)
                .labelStyle(.settingsIcon(tint: color))
        }
    }
}

// MARK: - Preview Provider

@available(iOS 15.0, *)
struct Popup_Previews: PreviewProvider {
    static var previews: some View {
        PopupPreviews()
            .embedInNavigation()
    }
}

extension Samples {
    @available(iOS 15.0, *)
    public static var popupPreviews: some View {
        PopupPreviews()
    }
}

private struct ShowPartDetail: View {
    @State private var popupDetail: InventoryItem?

    var body: some View {
        Button("Show Part Details") {
            popupDetail = InventoryItem(
                id: "0123456789",
                partNumber: "Z-1234A",
                quantity: 100,
                name: "Widget"
            )
        }
        .popup(item: $popupDetail) { detail in
            VStack(alignment: .leading, spacing: 20) {
                Text("Part Number: \(detail.partNumber)")
                Text("Name: \(detail.name)")
                Text("Quantity On-Hand: \(detail.quantity)")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                popupDetail = nil
            }
        }
    }
}

private struct InventoryItem: Identifiable {
    var id: String
    let partNumber: String
    let quantity: Int
    let name: String
}
#endif
