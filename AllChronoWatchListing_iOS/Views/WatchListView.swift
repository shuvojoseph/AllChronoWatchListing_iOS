import SwiftUI

struct WatchListView: View {
    let viewModel: WatchListViewModel

    var body: some View {
        Text("AllChrono")
    }
}

#Preview {
    WatchListView(viewModel: WatchListViewModel(watchRepository: LocalWatchRepository()))
}
