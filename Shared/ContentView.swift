/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The views of the app, which display details of the fetched earthquake data.
*/

import SwiftUI
import CoreData

struct ContentView: View {

    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        NavigationView {
            List(selection: $viewModel.selection) {
                ForEach(viewModel.quakes, id: \.code) { quake in
                    NavigationLink(destination: QuakeDetail(quake: quake)) {
                        QuakeRow(quake: quake)
                    }
                }
                .onDelete(perform: viewModel.deleteQuakes)
            }
            .listStyle(SidebarListStyle())
            .navigationTitle(viewModel.title)
            .toolbar(content: toolbarContent)
            .environment(\.editMode, $viewModel.editMode)
            .refreshable {
                await viewModel.fetchQuakes()
            }

            EmptyView()
        }
        .alert(isPresented: $viewModel.hasError, error: viewModel.error) { }
    }
}

// MARK: Toolbar Content

extension ContentView {
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if viewModel.editMode == .active {
                SelectButton(mode: $viewModel.selectMode) {
                    if viewModel.selectMode.isActive {
                        viewModel.selection = Set(viewModel.quakes.map { $0.code })
                    } else {
                        viewModel.selection = []
                    }
                }
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton(editMode: $viewModel.editMode) {
                viewModel.selection.removeAll()
                viewModel.editMode = .inactive
                viewModel.selectMode = .inactive
            }
        }

        ToolbarItemGroup(placement: .bottomBar) {
            RefreshButton {
                Task {
                    await viewModel.fetchQuakes()
                }
            }
            .disabled(viewModel.refreshButtonDisabled)

            Spacer()
            ToolbarStatus(
                isLoading: viewModel.isLoading,
                lastUpdated: viewModel.lastUpdated,
                quakesCount: viewModel.quakes.count
            )
            Spacer()

            if viewModel.showDeleteButton {
                DeleteButton {
                    Task {
                        await viewModel.deleteQuakes(for: viewModel.selection)
                    }
                }
                .disabled(viewModel.deleteButtonDisabled)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let quakesProvider = QuakesProvider.preview
    static var previews: some View {
        ContentView(
            viewModel: ContentViewModel(
                quakesProvider: quakesProvider,
                context: quakesProvider.container.viewContext
            )
        )
    }
}
