/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The views of the app, which display details of the fetched earthquake data.
*/

import SwiftUI
import CoreData

struct ContentView: View {
    var quakesProvider: QuakesProvider = .shared

    @AppStorage("lastUpdated")
    private var lastUpdated = Date.distantFuture.timeIntervalSince1970

    @FetchRequest(sortDescriptors: [SortDescriptor(\.time, order: .reverse)])
    private var quakes: FetchedResults<Quake>

    @StateObject private var state = ContentViewState()

    var body: some View {
        NavigationView {
            List(selection: $state.selection) {
                ForEach(quakes, id: \.code) { quake in
                    NavigationLink(destination: QuakeDetail(quake: quake)) {
                        QuakeRow(quake: quake)
                    }
                }
                .onDelete(perform: deleteQuakes)
            }
            .listStyle(SidebarListStyle())
            .navigationTitle(state.title)
            .toolbar(content: toolbarContent)
            .environment(\.editMode, $state.editMode)
            .refreshable {
                await fetchQuakes()
            }

            EmptyView()
        }
        .alert(isPresented: $state.hasError, error: state.error) { }
    }
}

// MARK: Core Data

extension ContentView {
    private func deleteQuakes(at offsets: IndexSet) {
        let objectIDs = offsets.map { quakes[$0].objectID }
        quakesProvider.deleteQuakes(identifiedBy: objectIDs)
        state.selection.removeAll()
    }

    private func deleteQuakes(for codes: Set<String>) async {
        do {
            let quakesToDelete = quakes.filter { codes.contains($0.code) }
            try await quakesProvider.deleteQuakes(quakesToDelete)
        } catch {
            state.error = error as? QuakeError ?? .unexpectedError(error: error)
            state.hasError = true
        }
        state.selection.removeAll()
        state.editMode = .inactive
    }

    private func fetchQuakes() async {
        state.isLoading = true
        do {
            try await quakesProvider.fetchQuakes()
            lastUpdated = Date().timeIntervalSince1970
        } catch {
            state.error = error as? QuakeError ?? .unexpectedError(error: error)
            state.hasError = true
        }
        state.isLoading = false
    }
}

// MARK: Toolbar Content

extension ContentView {
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if state.editMode == .active {
                SelectButton(mode: $state.selectMode) {
                    if state.selectMode.isActive {
                        state.selection = Set(quakes.map { $0.code })
                    } else {
                        state.selection = []
                    }
                }
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton(editMode: $state.editMode) {
                state.selection.removeAll()
                state.editMode = .inactive
                state.selectMode = .inactive
            }
        }

        ToolbarItemGroup(placement: .bottomBar) {
            RefreshButton {
                Task {
                    await fetchQuakes()
                }
            }
            .disabled(state.refreshButtonDisabled)

            Spacer()
            ToolbarStatus(
                isLoading: state.isLoading,
                lastUpdated: lastUpdated,
                quakesCount: quakes.count
            )
            Spacer()

            if state.showDeleteButton {
                DeleteButton {
                    Task {
                        await deleteQuakes(for: state.selection)
                    }
                }
                .disabled(state.deleteButtonDisabled)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let quakesProvider = QuakesProvider.preview
    static var previews: some View {
        ContentView(quakesProvider: quakesProvider)
            .environment(\.managedObjectContext,
                          quakesProvider.container.viewContext)
    }
}
