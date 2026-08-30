import SwiftUI

struct WatchCatalogView: View {
    @StateObject private var viewModel: WatchCatalogViewModel
    let onSelectWatch: (Watch) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(
        viewModel: WatchCatalogViewModel,
        onSelectWatch: @escaping (Watch) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSelectWatch = onSelectWatch
    }

    var body: some View {
        ZStack {
            Color.catalogBackground.ignoresSafeArea()

            content
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { await viewModel.loadIfNeeded() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Curating watches…")
                .tint(.chronoGold)
        case let .failed(message):
            ContentUnavailableView {
                Label("Unable to Load Watches", systemImage: "clock.badge.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") { Task { await viewModel.retry() } }
                    .buttonStyle(.borderedProminent)
                    .tint(.chronoGold)
            }
        case .loaded:
            catalog
        }
    }

    private var catalog: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                header

                Section {
                    brandFilters
                    resultsHeader

                    if viewModel.visibleWatches.isEmpty {
                        ContentUnavailableView.search(text: viewModel.searchText)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                    } else {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.visibleWatches) { watch in
                                WatchCardView(
                                    watch: watch,
                                    isSaved: viewModel.savedWatchIDs.contains(watch.id),
                                    onSave: { viewModel.toggleSaved(watch) }
                                )
                                .contentShape(Rectangle())
                                .onTapGesture { onSelectWatch(watch) }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                } header: {
                    searchField
                        .padding(.vertical, 8)
                        .background(Color.catalogBackground)
                }
            }
            .padding(.bottom, 28)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Image("AllChronoLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 158, height: 28, alignment: .leading)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(
                        Color(red: 0.98, green: 0.97, blue: 0.94),
                        in: RoundedRectangle(cornerRadius: 8)
                    )
                    .accessibilityLabel("AllChrono")
                Spacer()
                Button(action: {}) {
                    Image(systemName: "bell")
                        .frame(width: 40, height: 40)
                        .background(Color.cardBackground, in: Circle())
                        .overlay(Circle().stroke(Color.cardBorder, lineWidth: 1))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Notifications")
            }
            VStack(alignment: .leading, spacing: 7) {
                Text("GLOBAL LUXURY WATCH MARKETPLACE")
                    .font(.caption2.weight(.bold))
                    .tracking(1.6)
                    .foregroundStyle(Color.chronoGold)
                Text("Trusted watch trading,\nworldwide.")
                    .font(.system(size: 34, weight: .regular, design: .serif))
                    .tracking(-1.2)
                    .lineSpacing(-2)
                Text("Anchored in Saudi Arabia")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 18)
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
            TextField("Search brand or model", text: $viewModel.searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            Image(systemName: "slider.horizontal.3")
        }
        .font(.subheadline)
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.cardBorder, lineWidth: 1))
        .padding(.horizontal, 20)
        .zIndex(1)
    }

    private var brandFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                BrandFilterChip(
                    title: "All watches",
                    isSelected: viewModel.selectedBrand == nil,
                    action: { viewModel.selectBrand(nil) }
                )

                ForEach(viewModel.brands, id: \.self) { brand in
                    BrandFilterChip(
                        title: brand,
                        isSelected: viewModel.selectedBrand == brand,
                        action: { viewModel.selectBrand(brand) }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 18)
    }

    private var resultsHeader: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Featured watches")
                .font(.system(size: 22, design: .serif))
            Spacer()
            Text("\(viewModel.visibleWatches.count.formatted()) results")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }
}

struct WatchCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        AppCoordinatorView(environment: .preview)
    }
}
