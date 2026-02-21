import SwiftUI

final class MixerScreenViewModel: ObservableObject {
    @Published var deck1Volume: Double = 0.8
    @Published var deck2Volume: Double = 0.8
    @Published var crossfader: Double = 0.5

    private let bridge: MixxxEngineBridge

    init(bridge: MixxxEngineBridge) {
        self.bridge = bridge
    }

    func send(_ action: DeckAction) {
        switch action {
        case .play(let deck):
            bridge.toggleControl(withGroup: "[Channel\(deck)]", item: "play")
        case .cue(let deck):
            bridge.triggerControl(withGroup: "[Channel\(deck)]", item: "cue_default")
        case .sync(let deck):
            bridge.toggleControl(withGroup: "[Channel\(deck)]", item: "sync_enabled")
        case .setFader(let deck, let value):
            bridge.setControl(withGroup: "[Channel\(deck)]", item: "volume", value: value)
            if deck == 1 {
                deck1Volume = value
            } else {
                deck2Volume = value
            }
        case .setEQ(let deck, let band, let value):
            let item: String
            switch band {
            case .low: item = "filterLow"
            case .mid: item = "filterMid"
            case .high: item = "filterHigh"
            }
            bridge.setControl(withGroup: "[Channel\(deck)]", item: item, value: value)
        case .setCrossfader(let value):
            crossfader = value
            bridge.setControl(withGroup: "[Master]", item: "crossfader", value: value)
        }
    }
}

struct MixerScreenView: View {
    @ObservedObject var viewModel: MixerScreenViewModel
    private let mapper = TouchGestureMapper()

    var body: some View {
        HStack(spacing: 20) {
            deckColumn(deck: 1, volume: viewModel.deck1Volume)
            VStack {
                Text("Crossfader")
                Slider(value: Binding(
                    get: { viewModel.crossfader },
                    set: { viewModel.send(.setCrossfader(value: $0)) }
                ))
            }
            .frame(maxWidth: 260)
            deckColumn(deck: 2, volume: viewModel.deck2Volume)
        }
        .padding()
    }

    private func deckColumn(deck: Int, volume: Double) -> some View {
        VStack(spacing: 12) {
            Text("Deck \(deck)")
            HStack {
                Button("PLAY") { viewModel.send(.play(deck: deck)) }
                Button("CUE") { viewModel.send(.cue(deck: deck)) }
                Button("SYNC") { viewModel.send(.sync(deck: deck)) }
            }
            Text("VOL: \(volume, specifier: "%.2f")")
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: geometry.size.height * volume)
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let action = mapper.mapFaderDrag(
                                    locationY: value.location.y,
                                    height: geometry.size.height,
                                    deck: deck
                                )
                                viewModel.send(action)
                            }
                    )
            }
            .frame(width: 60, height: 260)
        }
        .frame(maxWidth: .infinity)
    }
}
