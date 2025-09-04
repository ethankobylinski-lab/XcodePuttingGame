//
//  SettingsView.swift
//  PuttingGameV1
//
//  Created by Ethan Kobylinski on 7/7/25.
//


// File: Views/SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: PuttTrackerViewModel
    @State private var editMode = EditMode.inactive
    @State private var showRename = false
    @State private var tagToRename: String = ""
    @State private var newTagName: String = ""

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Tags")) {
                    ForEach(vm.tagOptions, id: \.self) { tag in
                        HStack {
                            Text(tag)
                            Spacer()
                            if vm.selectedTags.contains(tag) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            vm.toggleTag(tag)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                vm.removeTag(tag)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                tagToRename = tag
                                newTagName = tag
                                showRename = true
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .environment(\.editMode, $editMode)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showRename) {
                NavigationView {
                    Form {
                        Section(header: Text("Rename Tag")) {
                            TextField("New name", text: $newTagName)
                        }
                    }
                    .navigationTitle("Rename Tag")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showRename = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                vm.renameTag(from: tagToRename, to: newTagName)
                                showRename = false
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(PuttTrackerViewModel())
    }
}
