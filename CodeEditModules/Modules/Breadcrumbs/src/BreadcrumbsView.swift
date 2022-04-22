//
//  BreadcrumbsView.swift
//  CodeEdit
//
//  Created by Lukas Pistrol on 17.03.22.
//

import SwiftUI
import WorkspaceClient

public struct BreadcrumbsView: View {
    @Environment(\.colorScheme)
    private var colorScheme

    @Environment(\.controlActiveState)
    private var activeState

    @State private var fileItems: [WorkspaceClient.FileItem] = []

    private let file: WorkspaceClient.FileItem
    private let tappedOpenFile: (WorkspaceClient.FileItem) -> Void

    public init(
        file: WorkspaceClient.FileItem,
        tappedOpenFile: @escaping (WorkspaceClient.FileItem) -> Void
    ) {
        self.file = file
        self.tappedOpenFile = tappedOpenFile
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 1) {
                ForEach(fileItems, id: \.self) { fileItem in
                    if fileItem.parent != nil {
                        chevron
                    }
                    BreadcrumbsComponent(fileItem: fileItem, tappedOpenFile: tappedOpenFile)
                        .padding(.leading, 2)
                }
            }
            .padding(.horizontal, 11)
        }
        .frame(height: 29, alignment: .center)
        .background(Color(nsColor: .controlBackgroundColor))
        .overlay(alignment: .bottom) {
            Divider()
        }
        .onAppear {
            fileInfo(self.file)
        }
        .onChange(of: file) { newFile in
            fileInfo(newFile)
        }
    }

    private var chevron: some View {
        Image(systemName: "chevron.compact.right")
            .font(.system(size: 15, weight: .thin, design: .default))
            .foregroundStyle(.primary)
            .scaleEffect(x: 1.25, y: 1.0, anchor: .center)
            .imageScale(.large)
            .opacity(activeState != .inactive ? 0.8 : 0.5)
    }

    private func fileInfo(_ file: WorkspaceClient.FileItem) {
        fileItems = []
        var currentFile: WorkspaceClient.FileItem? = file
        while let currentFileLoop = currentFile {
            fileItems.insert(currentFileLoop, at: 0)
            currentFile = currentFileLoop.parent
        }
    }
}

struct BreadcrumbsView_Previews: PreviewProvider {
    static var previews: some View {
        BreadcrumbsView(file: .init(url: .init(fileURLWithPath: ""))) { _ in }
            .previewLayout(.fixed(width: 500, height: 29))
            .preferredColorScheme(.dark)

        BreadcrumbsView(file: .init(url: .init(fileURLWithPath: ""))) { _ in }
            .previewLayout(.fixed(width: 500, height: 29))
            .preferredColorScheme(.light)
    }
}
